//
//  APIRequestManager.swift
//  TinderUISamples
//
//  Created by 酒井文也 on 2018/02/11.
//  Copyright © 2018年 酒井文也. All rights reserved.
//

import Foundation
import Alamofire

//APIへのアクセスを汎用的に利用するための構造体
//参考：https://qiita.com/tmf16/items/d2f13088dd089b6bb3e4

struct APIRequestManager {

    //APIのベースとなるURL情報
    private let apiBaseURL = "https://app.rakuten.co.jp/services/api"

    //URLアクセス用のメンバ変数
    let apiUrl: String
    let method: HTTPMethod
    let parameters: Parameters

    init(endPoint: String, method: HTTPMethod = .get, parameters: Parameters = [:]) {

        //イニシャライザの定義
        apiUrl = apiBaseURL + endPoint
        self.method = method
        self.parameters = parameters
    }

    //該当APIのエンドポイントに向けてデータを取得する
    func request(success: @escaping (_ data: Dictionary<String, Any>)-> Void, fail: @escaping (_ error: Error?)-> Void) {

        //Alamofireによる非同期通信
        Alamofire.request(apiUrl, method: method, parameters: parameters).responseJSON { response in
            if response.result.isSuccess {
                success(response.result.value as! Dictionary)
            } else {
                fail(response.result.error)
            }
        }
    }
}
