//
//  Recipe.swift
//  ChefBook
//
//  Created by bradley on 8/12/17.
//  Copyright © 2017 Ben Bradley. All rights reserved.
//

import Foundation

class Recipe {
    var recipeID: Int?
    var instructions: String?
    var title: String?
    var readyinMinutes: Int?
    var imageURL: String?
    var servings: Int?
    var ingredients: [Ingredient] = []
    
    init(recipeID: Int, title: String, instructions: String, readyTime: Int, servings: Int, ingredients: [Ingredient], imageURL: String) {
        self.recipeID = recipeID
        self.title = title
        self.instructions = instructions
        self.readyinMinutes = readyTime
        self.servings = servings
        self.ingredients = ingredients
        self.imageURL = imageURL
    }
    
    init(recipeID: Int, title: String, imageURL: String) {
        self.recipeID = recipeID
        self.title = title
        self.imageURL = imageURL
    }
    
    init(recipeID: Int, title: String) {
        self.recipeID = recipeID
        self.title = title
    }
    
}
