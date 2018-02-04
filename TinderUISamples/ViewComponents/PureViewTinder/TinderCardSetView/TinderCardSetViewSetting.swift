//
//  TinderCardSetViewSetting.swift
//  TinderUISamples
//
//  Created by 酒井文也 on 2018/02/04.
//  Copyright © 2018年 酒井文也. All rights reserved.
//

import Foundation
import UIKit

protocol TinderCardSetViewSetting {

    // MARK: - Static Properties

    static var cardSetViewWidth: CGFloat { get }

    static var cardSetViewHeight: CGFloat { get }

    static var backgroundCornerRadius: CGFloat { get }

    static var backgroundBorderWidth: CGFloat { get }

    static var backgroundBorderColor: CGColor { get }

    static var backgroundShadowRadius: CGFloat { get }

    static var backgroundShadowOpacity: Float { get }

    static var backgroundShadowOffset: CGSize { get }

    static var backgroundShadowColor: CGColor { get }

    static var backgroundColor: UIColor { get }

    static var remarkLabelBackgroundColor: UIColor { get }

    static var remarkLabelFontColor: UIColor { get }

    static var readMoreButtonBackgroundColor: UIColor { get }

    static var readMoreButtonFontColor: UIColor { get }

    static var durationOfDragging: TimeInterval { get }

    static var startDraggingAlpha: CGFloat { get }

    static var stopDraggingAlpha: CGFloat { get }
    
    static var maxScaleOfDragging: CGFloat { get }
}
