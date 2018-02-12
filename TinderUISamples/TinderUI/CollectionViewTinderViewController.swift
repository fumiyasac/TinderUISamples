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

    //
    fileprivate let selectedView = UIView()

    //
    fileprivate var recipeDataList: [RecipeModel] = []

    // カード表示用のViewを格納するための配列
    fileprivate var tinderCardCollectionViewCellList: [TinderCardCollectionViewCell] = []

    //RecipePresenterに設定したプロトコルを適用するための変数
    fileprivate var presenter: RecipePresenter!

    // 追加できるカード枚数の上限値
    fileprivate let tinderCardSetViewCountLimit: Int = 16

    //
    /*
    fileprivate var layout: TinderCardCollectionViewLayout {
        return tinderCardSetCollectionView?.collectionViewLayout as! TinderCardCollectionViewLayout
    }
    */

    override func viewDidLoad() {
        super.viewDidLoad()

        setupRecipePresenter()
        setupAddCardButton()
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
        tinderCardSetCollectionView.reloadData()
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
        cell.setCellData(recipe)
        cell.readmoreButtonAction = {

            // 遷移先のURLをセットする
            if let linkUrl = URL(string: recipe.recipeUrl) {
                let safariViewController = SFSafariViewController(url: linkUrl)
                safariViewController.delegate = self
                self.present(safariViewController, animated: true, completion: nil)
            }
        }
        return cell
    }
}
