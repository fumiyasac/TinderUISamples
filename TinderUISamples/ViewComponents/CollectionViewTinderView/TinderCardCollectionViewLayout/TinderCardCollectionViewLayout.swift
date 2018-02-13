//
//  TinderCardCollectionViewLayout.swift
//  TinderUISamples
//
//  Created by 酒井文也 on 2018/02/12.
//  Copyright © 2018年 酒井文也. All rights reserved.
//

import UIKit

class TinderCardCollectionViewLayout: UICollectionViewLayout {

    // MEMO: 下記の記事を参考に作成しています。
    // 「UICollectionViewのLayoutで悩んだら」
    // http://techlife.cookpad.com/entry/2017/06/29/190000
    
    // 設定したレイアウト属性を格納するための変数
    private var layout = [UICollectionViewLayoutAttributes]()

    // セル表示時の拡大縮小の変化割合とアルファ値の割合
    private let reduceRatio: CGFloat = 0.018
    private let alphaRatio: CGFloat  = 0.008
    
    // レイアウトの事前計算を行う前に実行する
    override func prepare() {
        super.prepare()

        // 設定したレイアウト属性を事前計算処理前にリセットする
        layout.removeAll()

        // UICollectionViewの要素数を取得する
        var numberOfItemCount: Int = 0
        if let targetCollectionView = collectionView {
            numberOfItemCount = targetCollectionView.numberOfItems(inSection: 0)
        }

        // 現在画面に表示されている要素分のレイアウト属性の算出を行う
        for targetCount in (0..<numberOfItemCount).reversed() {

            // indexPathの値を取得する
            let indexPath = IndexPath(item: targetCount, section: 0)

            // X軸＆Y軸の値を新たに算出する
            let newPositionX: CGFloat = (UIScreen.main.bounds.width - TinderCardDefaultSettings.cardSetViewWidth) / 2
            let newPositionY: CGFloat = (UIScreen.main.bounds.height - TinderCardDefaultSettings.cardSetViewHeight) / 2.7
                - CGFloat(6 * targetCount)

            // レイアウトの配列に位置とサイズに関する情報を登録する
            let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            attributes.frame = CGRect(
                x: newPositionX,
                y: newPositionY,
                width: TinderCardDefaultSettings.cardSetViewWidth,
                height: TinderCardDefaultSettings.cardSetViewHeight
            )

            // 後ろに配置されているUICollectionViewCellほど小さく見えるように拡大縮小比を調節する
            let targetScale: CGFloat = 1 - reduceRatio * CGFloat(targetCount)
            let targetAlpha: CGFloat = 1 - alphaRatio * CGFloat(targetCount)

            attributes.alpha = targetAlpha
            attributes.transform = CGAffineTransform(scaleX: targetScale, y: targetScale)
            attributes.zIndex = numberOfItemCount - targetCount

            layout.append(attributes)
        }
    }
    
    // 範囲内に含まれるすべてのセルのレイアウト属性を返す
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        super.layoutAttributesForElements(in: rect)

        return layout
    }
}
