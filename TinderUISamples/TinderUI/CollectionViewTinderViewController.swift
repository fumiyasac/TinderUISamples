//
//  CollectionViewTinderViewController.swift
//  TinderUISamples
//
//  Created by 酒井文也 on 2018/01/25.
//  Copyright © 2018年 酒井文也. All rights reserved.
//

import UIKit

class CollectionViewTinderViewController: UIViewController {

    @IBOutlet weak var tinderCardSetCollectionView: UICollectionView!

    private let tinderCardCollectionViewCellIdentifier = "TinderCardCollectionViewCell"

    // カード表示用のViewを格納するための配列
    fileprivate var tinderCardCollectionViewCellList: [TinderCardSetView] = []

    //RecipePresenterに設定したプロトコルを適用するための変数
    fileprivate var presenter: RecipePresenter!

    // 追加できるカード枚数の上限値
    fileprivate let tinderCardSetViewCountLimit: Int = 16

    override func viewDidLoad() {
        super.viewDidLoad()

        setupRecipePresenter()
        setupAddCardButton()
        setupTinderCardSetCollectionView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

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

        //tinderCardSetCollectionView.delegate = self
        //tinderCardSetCollectionView.dataSource = self
        tinderCardSetCollectionView.register(UINib(nibName: tinderCardCollectionViewCellIdentifier, bundle: nil), forCellWithReuseIdentifier: tinderCardCollectionViewCellIdentifier)
    }
}

// MARK: - RecipePresenterProtocol

extension CollectionViewTinderViewController: RecipePresenterProtocol {

    // レシピデータ取得に成功した際の処理
    func bindRecipes(_ recipes: [RecipeModel]) {

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
