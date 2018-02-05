//
//  TinderCardSetView.swift
//  TinderUISamples
//
//  Created by 酒井文也 on 2018/02/04.
//  Copyright © 2018年 酒井文也. All rights reserved.
//

import Foundation
import UIKit

/**
 * 下記のライブラリでの実装を参考にして作成
 * https://github.com/nickypatson/TinderSwipeView
 */
 
// MARK: - Protocol

protocol TinderCardSetDelegate: NSObjectProtocol {

    // 左側への移動割合のしきい値を超えた場合に実行されるアクション
    func swipedLeftPosition(_ cardView: TinderCardSetView)

    // 右側への移動割合のしきい値を超えた場合に実行されるアクション
    func swipedRightPosition(_ cardView: TinderCardSetView)

    // 位置の変化が生じた際に実行されるアクション
    func updatePosition(_ cardView: TinderCardSetView, centerX: CGFloat, centerY: CGFloat)
}

class TinderCardSetView: CustomViewBase {

    @IBOutlet weak private var titleLabel: UILabel!
    @IBOutlet weak private var dateLabel: UILabel!
    @IBOutlet weak private var remarkLabel: UILabel!
    @IBOutlet weak private var thumbnailImageView: UIImageView!
    @IBOutlet weak private var descriptionLabel: UILabel!
    @IBOutlet weak private var readmoreButton: UIButton!

    // Viewの初期状態の中心点を決める変数(意図的に揺らぎを与えてランダムで少しずらす)
    private var initialCenter: CGPoint = CGPoint(
        x: UIScreen.main.bounds.size.width / 2,
        y: UIScreen.main.bounds.size.height / 2
    )

    // Viewの初期状態の傾きを決める変数(意図的に揺らぎを与えてランダムで少しずらす)
    private var initialTransform: CGAffineTransform = .identity

    // ドラッグ処理開始時のViewがある位置を格納する変数
    private var originalPoint: CGPoint = CGPoint.zero

    // 中心位置からのX軸＆Y軸方向の位置を格納する変数
    private var xPositionFromCenter: CGFloat = 0.0
    private var yPositionFromCenter: CGFloat = 0.0

    // 中心位置からのX軸方向へ何パーセント移動したか（移動割合）を格納する変数
    // MEMO: 端部まで来た状態を1とする
    private var currentMovePercentFromCenter: CGFloat = 0.0

    // TinderCardSetViewDefaultSettingsで設定した値を反映するための定数値
    private let durationOfInitialize: TimeInterval = TinderCardSetViewDefaultSettings.durationOfInitialize
    private let durationOfDragging: TimeInterval   = TinderCardSetViewDefaultSettings.durationOfDragging

    private let startDraggingAlpha: CGFloat = TinderCardSetViewDefaultSettings.startDraggingAlpha
    private let stopDraggingAlpha: CGFloat  = TinderCardSetViewDefaultSettings.stopDraggingAlpha
    private let maxScaleOfDragging: CGFloat = TinderCardSetViewDefaultSettings.maxScaleOfDragging

    private let swipeLeftLimitRatio: CGFloat  = TinderCardSetViewDefaultSettings.swipeLeftLimitRatio
    private let swipeRightLimitRatio: CGFloat = TinderCardSetViewDefaultSettings.swipeRightLimitRatio

    private let beforeInitializeScale: CGFloat = TinderCardSetViewDefaultSettings.beforeInitializeScale
    private let afterInitializeScale: CGFloat  = TinderCardSetViewDefaultSettings.afterInitializeScale

    // TinderCardSetDelegateのインスタンス宣言
    weak var delegate: TinderCardSetDelegate?
    
    // 「続きを読む」ボタンタップ時に実行されるクロージャー
    var readmoreButtonAction: (() -> ())?

    // MARK: - Initializer

    override func initWith() {
        setupTinderCardSetView()
        setupReadmoreButton()
        setupPanGestureRecognizer()
        setupSlopeAndIntercept()
    }

    // MARK: - Function

    /*
    func setViewData() {}
    */

    // MARK: - Private Function

    // ドラッグが開始された際に実行される処理
    @objc private func startDragging(_ sender: UIPanGestureRecognizer) {

        // 中心位置からのX軸＆Y軸方向の位置の値を更新する
        xPositionFromCenter = sender.translation(in: self).x
        yPositionFromCenter = sender.translation(in: self).y

        // UIPangestureRecognizerの状態に応じた処理を行う
        switch sender.state {

        // ドラッグ開始時の処理
        case .began:

            // ドラッグ処理開始時のViewがある位置を取得する
            originalPoint = CGPoint(
                x: self.center.x - xPositionFromCenter,
                y: self.center.y - yPositionFromCenter
            )
            print("beganCenterX", originalPoint.x)
            print("beganCenterY", originalPoint.y)

            // ドラッグ処理開始時のViewのアルファ値を変更する
            UIView.animate(withDuration: durationOfDragging, delay: 0.0, options: [.curveEaseInOut], animations: {
                self.alpha = self.startDraggingAlpha
            }, completion: nil)

            break

        // ドラッグ最中の処理
        case .changed:

            // 動かした位置の中心位置を取得する
            let newCenterX = originalPoint.x + xPositionFromCenter
            let newCenterY = originalPoint.y + yPositionFromCenter

            // Viewの中心位置を更新して動きをつける
            self.center = CGPoint(x: newCenterX, y: newCenterY)

            // DelegeteメソッドのupdatePositionを実行する
            //self.delegate?.updatePosition(self, centerX: newCenterX, centerY: newCenterY)

            // 中心位置からのX軸方向へ何パーセント移動したか（移動割合）を計算する
            currentMovePercentFromCenter = min(xPositionFromCenter / UIScreen.main.bounds.size.width, 1)

            // Debug.
            //print(currentMovePercentFromCenter)

            // 上記で算出した移動割合から回転量を取得し、初期配置時の回転量へ加算した値でアファイン変換を適用する
            let initialRotationAngle = atan2(initialTransform.b, initialTransform.a)
            let whenDraggingRotationAngel = initialRotationAngle + CGFloat.pi / 10 * currentMovePercentFromCenter
            let transforms = CGAffineTransform(rotationAngle: whenDraggingRotationAngel)

            // 上記で算出した移動割合から拡大縮小比を取得し、アファイン変換を適用する
            let whenDraggingScale = max(1 - fabs(currentMovePercentFromCenter) / 5, maxScaleOfDragging)
            let scaleTransform: CGAffineTransform = transforms.scaledBy(x: whenDraggingScale, y: whenDraggingScale)
            self.transform = scaleTransform

            break

        // ドラッグ終了時の処理
        case .ended, .cancelled:
            let whenEndedVelocity = sender.velocity(in: self)

            print("currentMovePercentFromCenter", currentMovePercentFromCenter)
            print("whenEndedVelocity", whenEndedVelocity)

            if currentMovePercentFromCenter < swipeLeftLimitRatio {
                moveInvisiblePosition(verocity: whenEndedVelocity, isLeft: true)
            } else if swipeRightLimitRatio < currentMovePercentFromCenter {
                moveInvisiblePosition(verocity: whenEndedVelocity, isLeft: false)
            } else {
                moveOriginalPosition()
            }

            // ドラッグ開始時の座標位置の変数をリセットする
            originalPoint = CGPoint.zero
            xPositionFromCenter = 0.0
            yPositionFromCenter = 0.0
            currentMovePercentFromCenter = 0.0

            break

        default:
            break
        }
    }

    // 続きを読むボタンがタップされた際に実行される処理
    @objc private func readmoreButtonTapped(_ sender: UIButton) {
        readmoreButtonAction?()
    }

    // このViewに対する初期設定を行う
    private func setupTinderCardSetView() {
        self.clipsToBounds   = true
        self.backgroundColor = TinderCardSetViewDefaultSettings.backgroundColor

        // MEMO: この部分では背景のViewに関する設定のみ実装
        self.layer.masksToBounds = false
        self.layer.borderColor   = TinderCardSetViewDefaultSettings.backgroundBorderColor
        self.layer.borderWidth   = TinderCardSetViewDefaultSettings.backgroundBorderWidth
        self.layer.cornerRadius  = TinderCardSetViewDefaultSettings.backgroundCornerRadius
        self.layer.shadowRadius  = TinderCardSetViewDefaultSettings.backgroundShadowRadius
        self.layer.shadowOpacity = TinderCardSetViewDefaultSettings.backgroundShadowOpacity
        self.layer.shadowOffset  = TinderCardSetViewDefaultSettings.backgroundShadowOffset
        self.layer.shadowColor   = TinderCardSetViewDefaultSettings.backgroundBorderColor
    }

    // このViewのViewの右下にあるボタンに対する初期設定を行う
    private func setupReadmoreButton() {
        readmoreButton.addTarget(self, action: #selector(self.readmoreButtonTapped), for: .touchUpInside)
    }

    // このViewのUIPanGestureRecognizerの付与を行う
    private func setupPanGestureRecognizer() {
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(self.startDragging))
        self.addGestureRecognizer(panGestureRecognizer)
    }

    // このViewの初期状態での傾きと切片の付与を行う
    private func setupSlopeAndIntercept() {

        // 中心位置のゆらぎを表現する値を設定する
        let fluctuationsPosX: CGFloat = CGFloat(Int.createRandom(range: Range(-8...8)))
        let fluctuationsPosY: CGFloat = CGFloat(Int.createRandom(range: Range(-8...8)))

        // 基準となる中心点のX座標を設定する（デフォルトではデバイスの中心点）
        let initialCenterPosX: CGFloat = UIScreen.main.bounds.size.width / 2
        let initialCenterPosY: CGFloat = UIScreen.main.bounds.size.height / 2

        // 配置したViewに関する中心位置を算出する
        initialCenter = CGPoint(
            x: initialCenterPosX + fluctuationsPosX,
            y: initialCenterPosY + fluctuationsPosY
        )

        // 傾きのゆらぎを表現する値を設定する
        let fluctuationsRotateAngle: CGFloat = CGFloat(Int.createRandom(range: Range(-6...6)))
        let angle = fluctuationsRotateAngle * .pi / 180.0 * 0.25
        initialTransform = CGAffineTransform(rotationAngle: angle)
        initialTransform.scaledBy(x: afterInitializeScale, y: afterInitializeScale)

        // カードの初期配置をするアニメーションを実行する
        moveInitialPosition()
    }

    // カードを初期配置する位置へ戻す
    private func moveInitialPosition() {

        // 表示前のカードの位置を設定する
        let beforeInitializePosX: CGFloat = CGFloat(-Int.createRandom(range: Range(100...300)))
        let beforeInitializePosY: CGFloat = CGFloat(-Int.createRandom(range: Range(100...300)))
        let beforeInitializeCenter = CGPoint(x: beforeInitializePosX, y: beforeInitializePosY)

        // 表示前のカードの傾きを設定する
        let beforeInitializeRotateAngle: CGFloat = CGFloat(Int.createRandom(range: Range(-90...90)))
        let angle = beforeInitializeRotateAngle * .pi / 180.0
        let beforeInitializeTransform = CGAffineTransform(rotationAngle: angle)
        beforeInitializeTransform.scaledBy(x: beforeInitializeScale, y: beforeInitializeScale)

        self.alpha = 0
        self.center = beforeInitializeCenter
        self.transform = beforeInitializeTransform

        UIView.animate(withDuration: durationOfInitialize, animations: {
            self.alpha = 1
            self.center = self.initialCenter
            self.transform = self.initialTransform
        })
    }

    // カードを元の位置へ戻す
    private func moveOriginalPosition() {

        UIView.animate(withDuration: durationOfDragging, delay: 0.0, usingSpringWithDamping: 0.68, initialSpringVelocity: 0.0, options: [.curveEaseInOut], animations: {

            // ドラッグ処理終了時はViewのアルファ値を元に戻す
            self.alpha = self.stopDraggingAlpha

            // Viewの配置を元の位置まで戻す
            self.center = self.initialCenter
            self.transform = self.initialTransform

        }, completion: nil)
    }

    // カードを左側の領域外へ動かす
    private func moveInvisiblePosition(verocity: CGPoint, isLeft: Bool = true) {

        // 変化後の予定位置を算出する
        let absPosX = UIScreen.main.bounds.size.width * 2
        let endCenterPosX = isLeft ? -absPosX : absPosX
        let endCenterPosY = verocity.y
        let endCenterPosition = CGPoint(x: endCenterPosX, y: endCenterPosY)

        UIView.animate(withDuration: durationOfDragging, delay: 0.0, usingSpringWithDamping: 0.68, initialSpringVelocity: 0.0, options: [.curveEaseInOut], animations: {

            // ドラッグ処理終了時はViewのアルファ値を元に戻す
            self.alpha = self.stopDraggingAlpha

            // 変化後の予定位置までViewを移動する
            self.center = endCenterPosition
            
        }, completion: { _ in

            // 画面から該当のViewを削除する
            self.removeFromSuperview()
        })

        // DelegeteメソッドのswipedLeftPositionを実行する
        //let _ = isLeft ? self.delegate?.swipedLeftPosition(self) : self.delegate?.swipedRightPosition(self)
    }
}
