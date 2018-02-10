//
//  PureViewTinderViewController.swift
//  TinderUISamples
//
//  Created by 酒井文也 on 2018/01/28.
//  Copyright © 2018年 酒井文也. All rights reserved.
//

import UIKit

class PureViewTinderViewController: UIViewController {

    //
    fileprivate var tinderCardSetViewList: [TinderCardSetView] = []

    //
    private let tinderCardSetViewCount: Int = 4

    //
    private let tinderCardSetViewCountLimit: Int = 20

    override func viewDidLoad() {
        super.viewDidLoad()

        addTinderCardSetViews()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Private Function

    private func addTinderCardSetViews() {
 
        //
        for _ in 0..<tinderCardSetViewCount {

            //
            let tinderCardSetView = TinderCardSetView()
            tinderCardSetView.delegate = self
            tinderCardSetView.isUserInteractionEnabled = false
            tinderCardSetViewList.append(tinderCardSetView)

            //
            view.addSubview(tinderCardSetView)
            view.sendSubview(toBack: tinderCardSetView)
        }

        //
        enableUserInteractionToFirstCardSetView()
    }

    // MARK: - Fileprivate Function

    //
    fileprivate func enableUserInteractionToFirstCardSetView() {

        //
        if !tinderCardSetViewList.isEmpty {
            if let firsttTinderCardSetView = tinderCardSetViewList.first {
                firsttTinderCardSetView.isUserInteractionEnabled = true
            }
        }
    }
}

extension PureViewTinderViewController: TinderCardSetDelegate {

    //
    func swipedLeftPosition(_ cardView: TinderCardSetView) {
        tinderCardSetViewList.removeFirst()
        enableUserInteractionToFirstCardSetView()
        
        // Debug.
        //print("左方向へのスワイプが完了")
    }

    //
    func swipedRightPosition(_ cardView: TinderCardSetView) {
        tinderCardSetViewList.removeFirst()
        enableUserInteractionToFirstCardSetView()
        
        // Debug.
        //print("右方向へのスワイプが完了")
    }

    //
    func updatePosition(_ cardView: TinderCardSetView, centerX: CGFloat, centerY: CGFloat) {

        // Debug.
        //print("タグ番号(インデックス値):\(cardView.tag) 移動した座標点 X軸:\(centerX) Y軸:\(centerY)")
    }
}
