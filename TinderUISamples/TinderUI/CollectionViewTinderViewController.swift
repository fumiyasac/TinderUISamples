//
//  CollectionViewTinderViewController.swift
//  TinderUISamples
//
//  Created by 酒井文也 on 2018/01/25.
//  Copyright © 2018年 酒井文也. All rights reserved.
//

import UIKit
import SafariServices

class CollectionViewTinderViewController: UIViewController, SFSafariViewControllerDelegate {

    @IBOutlet weak var tinderCardSetCollectionView: UICollectionView!

    private let tinderCardCollectionViewCellIdentifier = "TinderCardCollectionViewCell"

    // ドラッグ可能なイメージビュー
    fileprivate var draggableImageView: UIImageView!

    // カード表示用のUICollectionViewCell格納用のレシピデータ配列
    fileprivate var recipeDataList: [RecipeModel] = [] {
        didSet {
            self.tinderCardSetCollectionView.reloadData()
        }
    }

    // RecipePresenterに設定したプロトコルを適用するための変数
    fileprivate var presenter: RecipePresenter!

    // 選択状態の判定用のフラグ
    fileprivate var isSelectedFlag: Bool = false

    // 追加できるカード枚数の上限値
    fileprivate let tinderCardSetViewCountLimit: Int = 16

    override func viewDidLoad() {
        super.viewDidLoad()

        setupRecipePresenter()
        setupAddCardButton()
        setupDismissButton()
        setupTinderCardSetCollectionView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Private Function

    // カードを新しく追加するボタン押下時に実行されるアクションに関する設定を行う
    @objc private func addCardButtonTapped() {
        presenter.getRecipes()
    }

    // 戻るボタン押下時に実行されるアクションに関する設定を行う
    @objc private func dismissButtonTapped() {
        dismiss(animated: true, completion: nil)
    }

    // カードを新しく追加するボタンに関する設定を行う
    private func setupAddCardButton() {
        self.navigationItem.rightBarButtonItem =
            UIBarButtonItem(title: "追加!", style: .done, target: self, action: #selector(self.addCardButtonTapped))
    }

    // 戻るボタンに関する設定を行う
    private func setupDismissButton() {
        self.navigationItem.leftBarButtonItem =
            UIBarButtonItem(title: "戻る", style: .done, target: self, action: #selector(self.dismissButtonTapped))
    }

    // Presenterとの接続に関する設定を行う
    private func setupRecipePresenter() {
        presenter = RecipePresenter(presenter: self)
        presenter.getRecipes()
    }

    // UICollectionViewに関する設定を行う
    private func setupTinderCardSetCollectionView() {
        tinderCardSetCollectionView.delegate = self
        tinderCardSetCollectionView.dataSource = self
        tinderCardSetCollectionView.register(UINib(nibName: tinderCardCollectionViewCellIdentifier, bundle: nil), forCellWithReuseIdentifier: tinderCardCollectionViewCellIdentifier)
    }
}

// MARK: - RecipePresenterProtocol

extension CollectionViewTinderViewController: RecipePresenterProtocol {

    // レシピデータ取得に成功した際の処理
    func bindRecipes(_ recipes: [RecipeModel]) {
        guard recipeDataList.count < tinderCardSetViewCountLimit else {
            showAlertControllerWith(title: "表示データを制限しています", message: "この画面内に追加できるレシピデータの総数は合計16件までとなっておりますのでご注意下さい。")
            return
        }
        recipeDataList += recipes
    }

    // レシピデータ取得に失敗した際の処理
    func showErrorMessage() {
        showAlertControllerWith(title: "通信時にエラーが発生しました", message: "データの取得に失敗しました。通信状態の良い場所かWift等ネットワークに接続した状態で再度お試し下さい。")
    }

    // MARK: - Private Function
    
    private func showAlertControllerWith(title: String, message: String) {
        let errorAlert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        errorAlert.addAction(
            UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil)
        )
        self.present(errorAlert, animated: true, completion: nil)
    }
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource

extension CollectionViewTinderViewController: UICollectionViewDelegate, UICollectionViewDataSource {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return recipeDataList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: tinderCardCollectionViewCellIdentifier, for: indexPath) as! TinderCardCollectionViewCell
        let recipe = recipeDataList[indexPath.row]
        
        cell.isUserInteractionEnabled = (indexPath.row > 0) ? false : true
        cell.tag = indexPath.row
        cell.setCellData(recipe)
        cell.readmoreButtonAction = {

            // 遷移先のURLをセットする
            if let linkUrl = URL(string: recipe.recipeUrl) {
                let safariViewController = SFSafariViewController(url: linkUrl)
                safariViewController.delegate = self
                self.present(safariViewController, animated: true, completion: nil)
            }
        }

        // UILongPressGestureRecognizerの定義を行う
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(self.longPressCell(sender:)))

        // イベント発生までのタップ時間：0.05秒
        longPressGesture.minimumPressDuration = 0.05

        // 指のズレを許容する範囲：0.5px
        longPressGesture.allowableMovement = 0.5

        // セルに対してLongPressGestureRecognizerを付与する
        cell.addGestureRecognizer(longPressGesture)

        return cell
    }

    // MARK: - Private Function

    // セルを長押しした際(UILongPressGestureRecognizerで実行された際)に発動する処理
    @objc private func longPressCell(sender: UILongPressGestureRecognizer) {

        guard let targetView = sender.view else { return }

        // 長押ししたセルのタグ名と現在位置を設定する
        let targetTag: Int = targetView.tag
        let pressPoint: CGPoint = sender.location(ofTouch: 0, in: self.view)

        // 現在の中心位置を算出する
        let centerX = pressPoint.x
        let centerY = pressPoint.y

        // ドラッグ可能なImageViewとぶつかる範囲の設定
        let minX: CGFloat = 75.0
        let maxX: CGFloat = UIScreen.main.bounds.width - minX
        let minY: CGFloat = 100.0
        let maxY: CGFloat = UIScreen.main.bounds.height - minY

        // 長押し対象のセルに配置されていたものを格納するための変数
        var targetCell: TinderCardCollectionViewCell? = nil

        // CollectionView内の要素で該当のセルのものを抽出する
        for targetView in tinderCardSetCollectionView.subviews {
            if targetView is TinderCardCollectionViewCell {
                let cc = targetView as! TinderCardCollectionViewCell
                if cc.tag == targetTag {
                    targetCell = cc
                    break
                }
            }
        }

        // UILongPressGestureRecognizerが開始された際の処理
        if sender.state == UIGestureRecognizerState.began {

            guard let targetView = targetCell?.subviews.first else { return }

            // セル内のViewを非表示にする
            targetCell?.isHidden = true
            
            // ドラッグ可能なUIImageViewを作成＆配置する
            setDraggableImageView(targetView: targetView, x: centerX, y: centerY)
            view.addSubview(draggableImageView)
            
        // UILongPressGestureRecognizerが動作中の際の処理
        } else if sender.state == UIGestureRecognizerState.changed {

            // 中心位置の更新と回転量の反映を行う
            let diffOfCenterX = pressPoint.x - (UIScreen.main.bounds.size.width / 2)
            let targetRotationAngel = CGFloat.pi / 180 + diffOfCenterX / 1000
            let transforms = CGAffineTransform(rotationAngle: targetRotationAngel)

            draggableImageView.center = CGPoint(x: centerX, y: centerY)
            draggableImageView.transform = transforms

            // Debug.
            //print("x:\(minX) ~ \(maxX), y:\(minY) ~ \(maxY)");
            //print("x:\(pressPoint.x), y:\(pressPoint.y)");

            // 設定した領域の範囲内にあるか否かを判定する
            let containsOfTargetRect: Bool = ((minX <= pressPoint.x && pressPoint.x <= maxX) && (minY <= pressPoint.y && pressPoint.y <= maxY))
            isSelectedFlag = (containsOfTargetRect) ? false : true

        // UILongPressGestureRecognizerが終了した際の処理
        } else if sender.state == UIGestureRecognizerState.ended {

            // 設定した領域の範囲内に中心位置がない場合は該当のレシピデータを削除してUICollectionViewを更新
            if isSelectedFlag {

                // 左右のどちらにスワイプするかを決定する
                let isSwipeLeft  = (minX > pressPoint.x)
                let isSwipeRight = (pressPoint.x > maxX)

                var swipeOutPosX: CGFloat = 0
                let swipeOutPosY: CGFloat = self.draggableImageView.center.y

                UIView.animate(withDuration: TinderCardDefaultSettings.durationOfSwipeOut / 2.5, animations: {

                    if isSwipeLeft {
                        swipeOutPosX = -UIScreen.main.bounds.width * 2.0
                    } else if isSwipeRight {
                        swipeOutPosX = UIScreen.main.bounds.width * 2.0
                    }

                    self.draggableImageView.center = CGPoint(x: swipeOutPosX, y: swipeOutPosY)

                }, completion: { _ in

                    if isSwipeLeft {
                        self.swipeOutLeftDraggableImageView()
                    } else if isSwipeRight {
                        self.swipeOutRightDraggableImageView()
                    }

                    self.recipeDataList.remove(at: targetTag)
                    self.removeDraggableImageView()

                    // セル内のViewを表示する
                    targetCell?.isHidden = false
                })
                isSelectedFlag = false

            // 設定した領域の範囲内に中心位置がある場合はUICollectionViewの表示を元に戻す
            } else {

                removeDraggableImageView()

                // セル内のViewを表示する
                targetCell?.isHidden = false
            }
        }
    }

    // ドラッグ可能なUIImageViewを左側の画面外へ動かす
    private func swipeOutLeftDraggableImageView() {

        // Debug.
        //print("左方向へのスワイプ完了しました。")
    }

    // ドラッグ可能なUIImageViewを右側の画面外へ動かす
    private func swipeOutRightDraggableImageView() {

        // Debug.
        //print("右方向へのスワイプ完了しました。")
    }

    // ドラッグ可能なUIImageViewを画面から消去する
    private func removeDraggableImageView() {
        draggableImageView.image = nil
        draggableImageView.removeFromSuperview()
    }

    // ドラッグ可能なUIImageViewに関する初期設定をする
    private func setDraggableImageView(targetView: UIView, x: CGFloat, y: CGFloat) {

        draggableImageView = UIImageView()
        draggableImageView.frame.size = CGSize(
            width: TinderCardDefaultSettings.cardSetViewWidth,
            height: TinderCardDefaultSettings.cardSetViewHeight
        )
        draggableImageView.center = CGPoint(
            x: x,
            y: y
        )
        draggableImageView.backgroundColor = UIColor.white
        draggableImageView.image = getSnapshotOfCell(inputView: targetView)

        // MEMO: この部分では背景のViewに関する設定のみ実装
        draggableImageView.layer.borderColor   = TinderCardDefaultSettings.backgroundBorderColor
        draggableImageView.layer.borderWidth   = TinderCardDefaultSettings.backgroundBorderWidth
        draggableImageView.layer.cornerRadius  = TinderCardDefaultSettings.backgroundCornerRadius
        draggableImageView.layer.shadowRadius  = TinderCardDefaultSettings.backgroundShadowRadius
        draggableImageView.layer.shadowOpacity = TinderCardDefaultSettings.backgroundShadowOpacity
        draggableImageView.layer.shadowOffset  = TinderCardDefaultSettings.backgroundShadowOffset
        draggableImageView.layer.shadowColor   = TinderCardDefaultSettings.backgroundBorderColor
    }

    // 選択したCollectionViewCellのスナップショットを取得する
    private func getSnapshotOfCell(inputView: UIView) -> UIImage? {

        UIGraphicsBeginImageContextWithOptions(inputView.bounds.size, false, 0.0)
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        inputView.layer.render(in: context)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
}
