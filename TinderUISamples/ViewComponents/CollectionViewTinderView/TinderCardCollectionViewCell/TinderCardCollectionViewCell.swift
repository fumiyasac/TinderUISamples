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

    // MARK: - Initializer

    override func awakeFromNib() {
        super.awakeFromNib()
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

}
