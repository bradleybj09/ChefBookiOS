//
//  MyRecipesDB.swift
//  ChefBook
//
//  Created by bradley on 8/18/17.
//  Copyright © 2017 Ben Bradley. All rights reserved.
//

import Foundation
import SQLite

class MyRecipesDB {
    
    static let instance = MyRecipesDB()
    
    init() {
        instantiateMyTables()
        instantiateListTables()
    }
    
    let db = try! Connection("\(NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!)/db.sqlite3")
    
    let tableMyRecipes = Table("my_recipes")
    let tableMyIngredients = Table("my_ingrediets")
    let tableListRecipes = Table("list_recipes")
    let tableListIngredients = Table("list_ingredients")
    
    let table_R_Name = "my_recipes"
    let column_R_ID = Expression<Int64>("recipe_id")
    let column_R_Title = Expression<String>("recipe_title")
    let column_R_Image = Expression<String>("recipe_image")
    let column_R_Instructions = Expression<String>("recipe_instructions")
    let column_R_ReadyTime = Expression<String>("ready_time")
    let column_R_Servings = Expression<String>("servings")
    
    let table_I_Name = "my_ingredients"
    let column_I_JoinRecipeId = Expression<Int64>("join_recipe_id")
    let column_I_IID = Expression<Int64>("ingredient_id")
    let column_I_IName = Expression<String>("ingredient_name")
    let column_I_Amount = Expression<Double>("amount")
    let column_I_Unit = Expression<String>("unit")
    let column_I_UnitShort = Expression<String>("unit_short")
    let column_I_UnitLong = Expression<String>("unit_long")
    let column_I_OriginalString = Expression<String>("original_string")
    
    let table_LR_Name = "list_recipes"
    let column_LR_ID = Expression<Int64>("list_recipe_id")
    let column_LR_Name = Expression<String>("list_recipe_name")

    
    let table_LI_Name = "list_ingredients"
    let column_LI_JoinRecipeID = Expression<Int64>("list_join_id")
    let column_LI_ID = Expression<Int64>("list_ingredient_id")
    let column_LI_Name = Expression<String>("list_ingredient_name")
    let column_LI_Amount = Expression<Double>("list_amount")
    let column_LI_Unit = Expression<String>("list_unit")
    let column_LI_UnitShort = Expression<String>("list_unit_short")
    let column_LI_UnitLong = Expression<String>("list_unit_long")
    
    func instantiateMyTables() {
        
        try! db.run(tableMyRecipes.create(ifNotExists: true) { t in
            t.column(column_R_ID, unique: true)
            t.column(column_R_Title)
            t.column(column_R_Image)
            t.column(column_R_Instructions)
            t.column(column_R_ReadyTime)
            t.column(column_R_Servings)
        })
        
        try! db.run(tableMyIngredients.create(ifNotExists: true) { t in
            t.column(column_I_JoinRecipeId)
            t.column(column_I_IID)
            t.column(column_I_IName)
            t.column(column_I_Amount)
            t.column(column_I_Unit)
            t.column(column_I_UnitShort)
            t.column(column_I_UnitLong)
            t.column(column_I_OriginalString)
        })
    }
    
    func instantiateListTables() {
        
        try! db.run(tableListRecipes.create(ifNotExists: true) { t in
            t.column(column_LR_ID)
            t.column(column_LR_Name)
        })
        
        try! db.run(tableListIngredients.create(ifNotExists: true) { t in
            t.column(column_LI_ID)
            t.column(column_LI_JoinRecipeID)
            t.column(column_LI_Name)
            t.column(column_LI_Amount)
            t.column(column_LI_Unit)
            t.column(column_LI_UnitShort)
            t.column(column_LI_UnitLong)
        })
    }
    
    func queryMyRecipes() -> [Recipe] {
        var recipes = [Recipe]()
        for recipe in try! db.prepare(tableMyRecipes) {
            let rRecipe = Recipe(recipeID: Int(recipe[column_R_ID]), title: recipe[column_R_Title], imageURL: recipe[column_R_Image])
            recipes.append(rRecipe)
        }
        return recipes
    }
    
    func addToMyRecipes(recipe: Recipe) {
        try! db.run(tableMyRecipes.insert(column_R_ID <- Int64.init(exactly: recipe.recipeID!)!, column_R_Title <- recipe.title!, column_R_Image <- recipe.imageURL!, column_R_Instructions <- recipe.instructions!, column_R_ReadyTime <- String(recipe.readyinMinutes!), column_R_Servings <- String(recipe.servings!)))
        
        for ingredient in recipe.ingredients {
            try! db.run(tableMyIngredients.insert(column_I_JoinRecipeId <- Int64.init(exactly: recipe.recipeID!)! ,column_I_IID <- Int64.init(exactly: ingredient.ingredientID!)!, column_I_IName <- ingredient.name!, column_I_Amount <- ingredient.amount!, column_I_Unit <- ingredient.unit!, column_I_UnitShort <- ingredient.unitShort!, column_I_UnitLong <- ingredient.unitLong!, column_I_OriginalString <- ingredient.originalString!))
        }
    }
    
    func addToList(recipe: Recipe) {
        try! db.run(tableListRecipes.insert(column_LR_ID <- Int64.init(exactly: recipe.recipeID!)!, column_LR_Name <- recipe.title!))
        
        for ingredient in recipe.ingredients {
            try! db.run(tableListIngredients.insert(column_LI_JoinRecipeID <- Int64.init(exactly: recipe.recipeID!)! ,column_LI_ID <- Int64.init(exactly: ingredient.ingredientID!)!, column_LI_Name <- ingredient.name!, column_LI_Amount <- ingredient.amount!, column_LI_Unit <- ingredient.unit!, column_LI_UnitShort <- ingredient.unitShort!, column_LI_UnitLong <- ingredient.unitLong!))
        }
    }
    
    func removeFromMyRecipes(recipeID: Int) {
        let removalInt: Int64 = Int64.init(exactly: recipeID)!
        let removalRecipe = tableMyRecipes.filter(column_R_ID == removalInt)
        let removalIngredients = tableMyIngredients.filter(column_I_JoinRecipeId == removalInt)
        try! db.run(removalRecipe.delete())
        try! db.run(removalIngredients.delete())
    }
    
    func queryListRecipes() -> [Recipe] {
        var recipes = [Recipe]()
        for recipe in try! db.prepare(tableListRecipes) {
            let rRecipe = Recipe(recipeID: Int(recipe[column_LR_ID]), title: recipe[column_LR_Name])
            recipes.append(rRecipe)
        }
        return recipes
    }
    
    func queryListIngredients() -> [Ingredient]{
        let query = "SELECT \("list_ingredient_id"), \("list_ingredient_name"), SUM(\("list_amount")), \("list_unit"), \("list_unit_short"), \("list_unit_long") FROM \(table_LI_Name) GROUP BY \("list_unit"), \("list_ingredient_name") ORDER BY \("list_ingredient_name") ASC"
        var ingredients = [Ingredient]()
        for ingredient in try! db.prepare(query) {
            let rIngredient = Ingredient(ingredientID: Int(ingredient[0] as! Int64), name: ingredient[1] as! String, amount: ingredient[2] as! Double, unit: ingredient[3] as! String, unitShort: ingredient[4] as! String, unitLong: ingredient[5] as! String)
            ingredients.append(rIngredient)
        }
        return ingredients
    }
    
    func removeRecipeFromList(recipeID: Int) {
        let removalInt: Int64 = Int64.init(exactly: recipeID)!
        let removalRecipe = tableListRecipes.filter(column_LR_ID == removalInt)
        let removalIngredients = tableListIngredients.filter(column_LI_JoinRecipeID == removalInt)
        try! db.run(removalRecipe.delete())
        try! db.run(removalIngredients.delete())
    }
    
    func removeIngredientFromList(ingredientID: Int) {
        let removalInt: Int64 = Int64.init(exactly: ingredientID)!
        let removalIngredient = tableListIngredients.filter(column_LI_ID == removalInt)
        try! db.run(removalIngredient.delete())
    }
    
    func emptyList() {
        try! db.run(tableListIngredients.delete())
        try! db.run(tableListRecipes.delete())
    }
    
    func checkIsMyRecipe(recipeID: Int) -> Bool {
        let checkRecipeID = Int64.init(exactly: recipeID)!
        let checkRecipe = tableMyRecipes.filter(column_R_ID == checkRecipeID)
        for _ in try! db.prepare(checkRecipe) {
            return true
        }
        return false
    }
}
