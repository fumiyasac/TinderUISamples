//
//  TinderCardDefaultSettings.swift
//  TinderUISamples
//
//  Created by 酒井文也 on 2018/02/04.
//  Copyright © 2018年 酒井文也. All rights reserved.
//

import Foundation
import UIKit

class TinderCardDefaultSettings: TinderCardSetting {

    // MARK: - Properties

    private let DEFAULT_FONT_NAME      = "HiraKakuProN-W3"
    private let DEFAULT_FONT_NAME_BOLD = "HiraKakuProN-W6"

    private let DEFAULT_TITLE_FONT_SIZE            = 13.0
    private let DEFAULT_REMARK_FONT_SIZE           = 13.0
    private let DEFAULT_DESCRIPTION_FONT_SIZE      = 11.0
    private let DEFAULT_READ_MORE_BUTTON_FONT_SIZE = 12.0

    // MARK: - TinderCardSetViewSettingプロトコルで定義した変数
    
    static var cardSetViewWidth: CGFloat = 300

    static var cardSetViewHeight: CGFloat = 320

    static var backgroundCornerRadius: CGFloat = 0.0

    static var backgroundBorderWidth: CGFloat = 0.75

    static var backgroundBorderColor: CGColor = UIColor.init(code: "#DDDDDD").cgColor

    static var backgroundShadowRadius: CGFloat = 3

    static var backgroundShadowOpacity: Float = 0.5

    static var backgroundShadowOffset: CGSize = CGSize(width: 0.75, height: 1.75)

    static var backgroundShadowColor: CGColor = UIColor.init(code: "#999999").cgColor

    static var backgroundColor: UIColor = UIColor.init(code: "#FFFFFF")

    static var remarkLabelBackgroundColor: UIColor = UIColor.init(code: "#FF6222")

    static var remarkLabelFontColor: UIColor = UIColor.init(code: "#FFFFFF")

    static var readMoreButtonBackgroundColor: UIColor = UIColor.clear

    static var readMoreButtonFontColor: UIColor = UIColor.init(code: "#FDAA01")

    static var beforeInitializeScale: CGFloat = 1.00

    static var afterInitializeScale: CGFloat = 1.00

    static var durationOfInitialize: TimeInterval = 0.93

    static var durationOfDragging: TimeInterval = 0.26

    static var startDraggingAlpha: CGFloat = 1.00
    
    static var stopDraggingAlpha: CGFloat = 1.00

    static var maxScaleOfDragging: CGFloat = 1.00

    static var swipeLeftLimitRatio: CGFloat = -0.58

    static var swipeRightLimitRatio: CGFloat = 0.58
}
