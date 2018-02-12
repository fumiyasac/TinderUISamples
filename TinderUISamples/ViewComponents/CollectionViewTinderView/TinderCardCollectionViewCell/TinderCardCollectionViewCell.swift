//
//  TinderCardCollectionViewCell.swift
//  TinderUISamples
//
//  Created by 酒井文也 on 2018/02/12.
//  Copyright © 2018年 酒井文也. All rights reserved.
//

import UIKit
import Kingfisher


class TinderCardCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak private var titleLabel: UILabel!
    @IBOutlet weak private var dateLabel: UILabel!
    @IBOutlet weak private var remarkLabel: UILabel!
    @IBOutlet weak private var thumbnailImageView: UIImageView!
    @IBOutlet weak private var descriptionLabel: UILabel!
    @IBOutlet weak private var readmoreButton: UIButton!

    // 「続きを読む」ボタンタップ時に実行されるクロージャー
    var readmoreButtonAction: (() -> ())?

    // MARK: - Initializer

    override func awakeFromNib() {
        super.awakeFromNib()

        setupTinderCardCollectionViewCell()
        setupReadmoreButton()
    }

    // MARK: - Function

    func setCellData(_ recipe: RecipeModel) {
        titleLabel.text = recipe.recipeTitle
        dateLabel.text = recipe.recipePublishday + " : " + recipe.recipeCost
        remarkLabel.text = recipe.recipeIndication
        thumbnailImageView.kf.indicatorType = .activity
        thumbnailImageView.kf.setImage(with: URL(string: recipe.foodImageUrl))
        descriptionLabel.text = recipe.recipeDescription
    }

    // MARK: - Private Function

    // 続きを読むボタンがタップされた際に実行される処理
    @objc private func readmoreButtonTapped(_ sender: UIButton) {
        readmoreButtonAction?()
    }

    // このViewのViewの右下にあるボタンに対する初期設定を行う
    private func setupReadmoreButton() {
        readmoreButton.addTarget(self, action: #selector(self.readmoreButtonTapped), for: .touchUpInside)
    }

    private func setupTinderCardCollectionViewCell() {
        self.clipsToBounds   = true
        self.backgroundColor = TinderCardDefaultSettings.backgroundColor

        // MEMO: この部分では背景のViewに関する設定のみ実装
        self.layer.masksToBounds = false
        self.layer.borderColor   = TinderCardDefaultSettings.backgroundBorderColor
        self.layer.borderWidth   = TinderCardDefaultSettings.backgroundBorderWidth
        self.layer.cornerRadius  = TinderCardDefaultSettings.backgroundCornerRadius
        self.layer.shadowRadius  = TinderCardDefaultSettings.backgroundShadowRadius
        self.layer.shadowOpacity = TinderCardDefaultSettings.backgroundShadowOpacity
        self.layer.shadowOffset  = TinderCardDefaultSettings.backgroundShadowOffset
        self.layer.shadowColor   = TinderCardDefaultSettings.backgroundBorderColor
    }
}
