//
//  TinderCardSetViewDefaultSettings.swift
//  TinderUISamples
//
//  Created by 酒井文也 on 2018/02/04.
//  Copyright © 2018年 酒井文也. All rights reserved.
//

import Foundation
import UIKit

struct TinderCardSetViewDefaultSettings {

    // MARK: - Initializer

    init() {}

    // MARK: - Properties

    private let DEFAULT_FONT_NAME      = "HiraKakuProN-W3"
    private let DEFAULT_FONT_NAME_BOLD = "HiraKakuProN-W6"

    private let DEFAULT_TITLE_FONT_SIZE            = 13.0
    private let DEFAULT_REMARK_FONT_SIZE           = 13.0
    private let DEFAULT_DESCRIPTION_FONT_SIZE      = 11.0
    private let DEFAULT_READ_MORE_BUTTON_FONT_SIZE = 12.0

    static let cardSetViewWidth: CGFloat = 300

    static let cardSetViewHeight: CGFloat = 320

    static let defaultAlpha: CGFloat = 1.0

    static let hoverAlpha: CGFloat = 0.85

    static let backgroundCornerRadius: CGFloat = 5.0

    static let backgroundBorderColor: CGColor = UIColor.init(code: "#DDDDDD").cgColor

    static let backgroundShadowRadius: CGFloat = 3

    static let backgroundShadowOpacity: CGFloat = 0.4

    static let backgroundShadowOffset: CGSize = CGSize(width: 0.5, height: 3)

    static let backgroundShadowColor: CGColor = UIColor.init(code: "#DDDDDD").cgColor

    static let backgroundColor: UIColor = UIColor.init(code: "#FFFFFF")

    static let remarkLabelBackgroundColor: UIColor = UIColor.init(code: "#FF6222")

    static let remarkLabelFontColor: UIColor = UIColor.init(code: "#FFFFFF")

    static let readMoreButtonBackgroundColor: UIColor = UIColor.clear

    static let readMoreButtonFontColor: UIColor = UIColor.init(code: "#FDAA01")
}
