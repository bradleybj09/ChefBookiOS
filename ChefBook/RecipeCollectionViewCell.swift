//
//  RecipeCollectionViewCell.swift
//  ChefBook
//
//  Created by bradley on 8/12/17.
//  Copyright © 2017 Ben Bradley. All rights reserved.
//

import UIKit

class RecipeCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var recipeCellImage: UIImageView!
    @IBOutlet weak var recipeCellTitle: UILabel!
    var recipeID = 0
    var recipeTitle = ""
    var recipeImagePath = ""
    
}
