//
//  Ingredient.swift
//  ChefBook
//
//  Created by bradley on 8/12/17.
//  Copyright © 2017 Ben Bradley. All rights reserved.
//

import Foundation
class Ingredient {
    var ingredientID: Int?
    var name: String?
    var amount: Double?
    var unit: String?
    var unitShort: String?
    var unitLong: String?
    var originalString: String?
    
    init(ingredientID: Int, name: String, amount: Double, unit: String, unitShort: String, unitLong: String, originalString: String = "") {
        self.ingredientID = ingredientID
        self.name = name
        self.amount = amount
        self.unit = unit
        self.unitShort = unitShort
        self.unitLong = unitLong
        self.originalString = originalString
    }
    
    init(ingredientID: Int, name: String, unit: String) {
        self.ingredientID = ingredientID
        self.name = name
        self.unit = unit
    }
}
