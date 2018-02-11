//
//  RecipeModel.swift
//  TinderUISamples
//
//  Created by 酒井文也 on 2018/02/11.
//  Copyright © 2018年 酒井文也. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON

struct RecipeModel {

    //メンバ変数（取得したJSONレスポンスのKeyに対応する値が入る）
    let recipeId: Int
    let recipeTitle: String
    let recipeUrl: String
    let foodImageUrl: String
    let recipeIndication: String
    let recipeCost: String
    let recipeDescription: String
    let recipePublishday: String

    //イニシャライザ（取得したJSONレスポンスに対して必要なものを抽出する）
    init(result: JSON) {
        self.recipeId          = result["recipeId"].int ?? 0
        self.recipeTitle       = result["recipeTitle"].string ?? ""
        self.recipeUrl         = result["recipeUrl"].string ?? ""
        self.foodImageUrl      = result["foodImageUrl"].string ?? ""
        self.recipeIndication  = result["recipeIndication"].string ?? ""
        self.recipeCost        = result["recipeCost"].string ?? ""
        self.recipeDescription = result["recipeDescription"].string ?? ""
        self.recipePublishday  = result["recipePublishday"].string ?? ""
    }
}
