//
//  APIConstant.swift
//  TinderUISamples
//
//  Created by 酒井文也 on 2018/02/11.
//  Copyright © 2018年 酒井文也. All rights reserved.
//

import Foundation

// MEMO: APIキーの取得方法及び設定方法に関しては下記のURLも参考にしてみてください。
// https://qiita.com/fumiyasac@github/items/6c4c2b909a821932be04

// 注意:
// 楽天レシピ別カテゴリランキングの画像URLはhttpなのでテスト用にATSをOFFにしてください。

struct APIConstant {

    // 楽天レシピ別カテゴリランキングのAPIキー ※各自取得をお願いします。
    static let API_KEY_RAKUTEN_RECIPE_RANKING = ""

    // MARK: - Static Function

    // ランダムに1件だけカテゴリーを選択する
    static func getCategoryByRandom() -> String {

        // CSVファイルで登録してあるカテゴリーの一覧を読み込む
        var categories: [String] = []
        if let csvPath = Bundle.main.path(forResource: "rakuten_recipe_category_list", ofType: "csv") {
            do {

                // CSVファイルの改行位置で分割して配列に格納する
                let csvString = try String(contentsOfFile: csvPath, encoding: String.Encoding.utf8)
                categories = csvString.components(separatedBy: .newlines)

            } catch let error as NSError {
                print(error.localizedDescription)
            }
        }

        return categories.isEmpty ? "" : categories[Int.createRandom(range: Range(0..<categories.count))]
    }
}
