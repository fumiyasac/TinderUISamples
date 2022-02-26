//
//  APIRequestManager.swift
//  TinderUISamples
//
//  Created by 酒井文也 on 2018/02/11.
//  Copyright © 2018年 酒井文也. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import PromiseKit

// APIへのアクセスを汎用的に利用するための構造体
// 参考：https://qiita.com/tmf16/items/d2f13088dd089b6bb3e4

struct APIRequestManager {

    // APIのベースとなるURL情報
    private let apiBaseURL = "https://app.rakuten.co.jp/services/api"

    // URLアクセス用のメンバ変数
    let apiUrl: String
    let method: HTTPMethod
    let parameters: Parameters

    init(endPoint: String, method: HTTPMethod = .get, parameters: Parameters = [:]) {

        // イニシャライザの定義
        apiUrl = apiBaseURL + endPoint
        self.method = method
        self.parameters = parameters
    }

    // 該当APIのエンドポイントに向けてデータを取得する
    func request() -> Promise<JSON> {

        return Promise { seal in
            AF.request(apiUrl, method: .get, parameters: parameters, encoding: URLEncoding.default).responseData { response in

                switch response.result {

                // 成功時の処理(以降はレスポンス結果を取得して返す)
                case .success(let response):
                    let json = JSON(response)
                    seal.fulfill(json)

                // 失敗時の処理(以降はエラーの結果を返す)
                case .failure(let error):
                    seal.reject(error)
                }
            }
        }
    }
}
