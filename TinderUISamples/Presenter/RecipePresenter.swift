//
//  RecipePresenter.swift
//  TinderUISamples
//
//  Created by 酒井文也 on 2018/02/11.
//  Copyright © 2018年 酒井文也. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON

protocol RecipePresenterProtocol: class {
    func bindRecipes(_ recipes: [RecipeModel])
    func showErrorMessage()
}

class RecipePresenter {

    var presenter: RecipePresenterProtocol!

    // MARK: - Initializer

    init(presenter: RecipePresenterProtocol) {
        self.presenter = presenter
    }

    // MARK: - Functions

    // レシピデータをAPI経由で取得する
    func getRecipes() {

        let parameters = [
            "format"        : "json",
            "applicationId" : APIConstant.API_KEY_RAKUTEN_RECIPE_RANKING,
            "categoryId"    : APIConstant.getCategoryByRandom()
        ]

        // 楽天レシピカテゴリ別ランキングAPIへアクセスをするための準備をする
        let apiRequestManager = APIRequestManager(
            endPoint: "/Recipe/CategoryRanking/20121121",
            method: .get,
            parameters: parameters
        )

        // 楽天レシピカテゴリ別ランキングAPIへの通信処理を実行する
        apiRequestManager.request()
            // 成功時の処理をクロージャー内に記載する
            .done { data in
                // JSONデータを解析してRecipeModel型データを作成
                let json = JSON(data)
                let recipes: [RecipeModel] = json["result"].map{ (_, result) in
                    return RecipeModel(result: JSON(result))
                }
                // 通信成功時の処理をプロトコルを適用したViewController側で行う
                self.presenter.bindRecipes(recipes)
            }
            // 失敗時の処理をクロージャー内に記載する
            .catch { error in
                // 通信失敗時の処理をプロトコルを適用したViewController側で行う
                self.presenter.showErrorMessage()
            }
    }
}
