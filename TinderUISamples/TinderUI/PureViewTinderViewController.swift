//
//  PureViewTinderViewController.swift
//  TinderUISamples
//
//  Created by 酒井文也 on 2018/01/28.
//  Copyright © 2018年 酒井文也. All rights reserved.
//

import UIKit
import SafariServices

class PureViewTinderViewController: UIViewController, SFSafariViewControllerDelegate {

    // カード表示用のViewを格納するための配列
    fileprivate var tinderCardSetViewList: [TinderCardSetView] = []

    //RecipePresenterに設定したプロトコルを適用するための変数
    fileprivate var presenter: RecipePresenter!

    // 追加できるカード枚数の上限値
    fileprivate let tinderCardSetViewCountLimit: Int = 16

    override func viewDidLoad() {
        super.viewDidLoad()

        setupRecipePresenter()
        setupAddCardButton()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Private Function

    // カードを新しく追加するボタン押下時に実行されるアクションに関する設定を行う
    @objc private func addCardButtonTapped() {

        presenter.getRecipes()
    }

    // カードを新しく追加するボタンに関する設定を行う
    private func setupAddCardButton() {

        self.navigationItem.rightBarButtonItem =
            UIBarButtonItem(title: "追加!", style: .done, target: self, action: #selector(self.addCardButtonTapped))
    }
    
    // Presenterとの接続に関する設定を行う
    private func setupRecipePresenter() {

        presenter = RecipePresenter(presenter: self)
        presenter.getRecipes()
    }

    // MARK: - Fileprivate Function

    // 画面上にカードを追加する
    fileprivate func addTinderCardSetViews(recipes: [RecipeModel]) {

        for index in 0..<recipes.count {
            
            // Debug.
            //print(recipes[index])

            // TinderCardSetViewのインスタンスを作成してプロトコル宣言やタッチイベント等の初期設定を行う
            let tinderCardSetView = TinderCardSetView()
            tinderCardSetView.delegate = self
            tinderCardSetView.setViewData(recipes[index])
            tinderCardSetView.readmoreButtonAction = {

                // 遷移先のURLをセットする
                if let linkUrl = URL(string: recipes[index].recipeUrl) {
                    let safariViewController = SFSafariViewController(url: linkUrl)
                    safariViewController.delegate = self
                    self.present(safariViewController, animated: true, completion: nil)
                }
            }
            tinderCardSetView.isUserInteractionEnabled = false
            tinderCardSetViewList.append(tinderCardSetView)

            // 現在表示されているカードの背面へ新たに作成したカードを追加する
            view.addSubview(tinderCardSetView)
            view.sendSubview(toBack: tinderCardSetView)
        }

        // MEMO: 配列(tinderCardSetViewList)に格納されているViewのうち、先頭にあるViewのみを操作可能にする
        enableUserInteractionToFirstCardSetView()
        
        // 画面上にあるカードの山の拡大縮小比を調節する
        changeScaleToCardSetViews(skipSelectedView: false)
    }

    // 画面上にあるカードの山のうち、一番上にあるViewのみを操作できるようにする
    fileprivate func enableUserInteractionToFirstCardSetView() {

        if !tinderCardSetViewList.isEmpty {
            if let firsttTinderCardSetView = tinderCardSetViewList.first {
                firsttTinderCardSetView.isUserInteractionEnabled = true
            }
        }
    }

    // 現在配列に格納されている(画面上にカードの山として表示されている)Viewの拡大縮小を調節する
    fileprivate func changeScaleToCardSetViews(skipSelectedView: Bool = false) {

        // アニメーション関連の定数値
        let duration: TimeInterval = 0.26
        let reduceRatio: CGFloat   = 0.018

        var targetCount: CGFloat = 0
        for (targetIndex, tinderCardSetView) in tinderCardSetViewList.enumerated() {

            // 現在操作中のViewの縮小比を変更しない場合は、以降の処理をスキップする
            if skipSelectedView && targetIndex == 0 { continue }

            // 後ろに配置されているViewほど小さく見えるように縮小比を調節する
            let targetScale: CGFloat = 1 - reduceRatio * targetCount
            UIView.animate(withDuration: duration, animations: {
                tinderCardSetView.transform = CGAffineTransform(scaleX: targetScale, y: targetScale)
            })
            targetCount += 1
        }
    }
}

extension PureViewTinderViewController: RecipePresenterProtocol {

    // レシピデータ取得に成功した際の処理
    func bindRecipes(_ recipes: [RecipeModel]) {

        guard tinderCardSetViewList.count + recipes.count < tinderCardSetViewCountLimit else {

            showAlertControllerWith(title: "表示データを制限しています", message: "この画面内に追加できるレシピデータの総数は合計16件までとなっておりますのでご注意下さい。")
            return
        }

        // カード表示用のViewを画面に追加する
        addTinderCardSetViews(recipes: recipes)
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


extension PureViewTinderViewController: TinderCardSetDelegate {

    // ドラッグ処理が開始された際にViewController側で実行する処理
    func beganDragging(_ cardView: TinderCardSetView) {

        // Debug.
        //print("ドラッグ処理が開始されました。")

        changeScaleToCardSetViews(skipSelectedView: true)
    }

    // ドラッグ処理中に位置情報が更新された際にViewController側で実行する処理
    func updatePosition(_ cardView: TinderCardSetView, centerX: CGFloat, centerY: CGFloat) {

        // Debug.
        //print("移動した座標点 X軸:\(centerX) Y軸:\(centerY)")
    }

    // 左方向へのスワイプが完了した際にViewController側で実行する処理
    func swipedLeftPosition(_ cardView: TinderCardSetView) {

        // Debug.
        //print("左方向へのスワイプ完了しました。")

        tinderCardSetViewList.removeFirst()
        enableUserInteractionToFirstCardSetView()
        changeScaleToCardSetViews(skipSelectedView: false)
    }

    // 右方向へのスワイプが完了した際にViewController側で実行する処理
    func swipedRightPosition(_ cardView: TinderCardSetView) {

        // Debug.
        //print("右方向へのスワイプ完了しました。")

        tinderCardSetViewList.removeFirst()
        enableUserInteractionToFirstCardSetView()
        changeScaleToCardSetViews(skipSelectedView: false)
    }

    // 元の位置へ戻った際にViewController側で実行する処理
    func returnToOriginalPosition(_ cardView: TinderCardSetView) {

        // Debug.
        //print("元の位置へ戻りました。")

        changeScaleToCardSetViews(skipSelectedView: false)
    }
}
