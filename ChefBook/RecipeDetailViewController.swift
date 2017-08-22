//
//  RecipeDetailViewController.swift
//  ChefBook
//
//  Created by bradley on 8/13/17.
//  Copyright © 2017 Ben Bradley. All rights reserved.
//

import UIKit

class RecipeDetailViewController: UIViewController {

    @IBOutlet weak var addToRecipesButton: UIBarButtonItem!
    @IBOutlet weak var navBar: UINavigationBar!
    @IBOutlet weak var detailImageView: UIImageView!
    @IBOutlet weak var prepTimeLabel: UILabel!
    @IBOutlet weak var servingsLabel: UILabel!
    @IBOutlet weak var ingredientsSwitch: UISwitch!
    @IBOutlet weak var ingredientsBody: UILabel!
    @IBOutlet weak var instructionsLabel: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!

    var recipeIngredients = [Ingredient]()
    var recipeID: Int!
    var recipeTitle: String!
    var recipeInstructions: String!
    var recipeImagePath: String!
    var recipeReadyInMinutes: Int!
    var recipeServings: Int!
    var ingredientsBodyString: String!
    var isMyRecipe = false
    var isRandom = false
    
    
    @IBAction func onClickMyRecipes(_ sender: Any) {
        if !isMyRecipe {
            addToMyRecipes()
            addToRecipesButton.title = "Remove From My Recipes"
        } else {
            removeFromMyRecipes()
            addToRecipesButton.title = "Addd To My Recipes"
        }
    }

    
    @IBAction func onClickListAdd(_ sender: Any) {
        addToList()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if recipeID != nil {
            fetchRecipeDetail(recipeID: recipeID)
            detailImageView.contentMode = UIViewContentMode.scaleAspectFill
            detailImageView.clipsToBounds = true
            detailImageView.kf.setImage(with: URL(string: recipeImagePath))
            navBar.topItem?.title = recipeTitle
            if checkIfMyRecipe() {
                isMyRecipe = true
            }
            if isMyRecipe {
                addToRecipesButton.title = "Remove From My Recipes"
            }
        } else {
            isRandom = true
            fetchRandomRecipe()
        }
    }
    
    func fetchRandomRecipe() {
        var finalID = 0
        let urlToRequest = "https://spoonacular-recipe-food-nutrition-v1.p.mashape.com/recipes/random?limitLicense=false&number=1"
        let apiKey = "yMn7M1DywmmshjLnVrGx90sD2ESIp1XfB2ijsnfU7kDaPhYGLb"
        let url1 = URL(string: urlToRequest)!
        let session1 = URLSession.shared
        let request = NSMutableURLRequest(url: url1)
        request.httpMethod = "GET"
        request.setValue(apiKey, forHTTPHeaderField: "X-Mashape-Key")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        let task = session1.dataTask(with: request as URLRequest) {
            (data, response, error) in
            guard let _: Data = data, let _: URLResponse = response, error == nil else {
                print("error")
                return
            }
            do {
                while finalID == 0 {
                    let jsonResult = try JSONSerialization.jsonObject(with: data!, options: []) as! [String: Any]
                    finalID = self.getRandomIDFromJson(result: jsonResult)
                }
                self.fetchRecipeDetail(recipeID: finalID)
            }
            catch let err {
                print(err.localizedDescription)
            }
        }
        task.resume()
    }
    
    func getRandomIDFromJson(result: [String: Any]) -> Int {
        let RECIPES = "recipes"
        let ID = "id"
        let TITLE = "title"
        let finalID = 0
        
        guard let recipeJsonArray = result[RECIPES] as? [[String: Any]] else {
            print("failed to process json")
            return finalID
        }
        for recipe in recipeJsonArray {
            if recipe[TITLE] == nil || recipe[TITLE]! as! String == "" {
            } else {
                return recipe[ID] as! Int
            }
        }
        return finalID
    }
    
    func checkIfMyRecipe() -> Bool {
        let db = MyRecipesDB()
        return db.checkIsMyRecipe(recipeID: recipeID!)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setUI() {
        ingredientsBody.text = ingredientsBodyString
        instructionsLabel.text = recipeInstructions
        servingsLabel.text = "Prep time: \(String(recipeServings)) minutes"
        prepTimeLabel.text = "Servings: \(String(recipeReadyInMinutes))"
        ingredientsBody.sizeToFit()
        instructionsLabel.sizeToFit()
        scrollView.sizeToFit()
        if isRandom {
            detailImageView.contentMode = UIViewContentMode.scaleAspectFill
            detailImageView.clipsToBounds = true
            detailImageView.kf.setImage(with: URL(string: recipeImagePath))
            navBar.topItem?.title = recipeTitle
            if checkIfMyRecipe() {
                isMyRecipe = true
            }
            if isMyRecipe {
                addToRecipesButton.title = "Remove From My Recipes"
            }
        }
    }
    
    func addToMyRecipes() {
        let db = MyRecipesDB()
        db.addToMyRecipes(recipe: Recipe(recipeID: recipeID, title: recipeTitle, instructions: recipeInstructions, readyTime: recipeReadyInMinutes, servings: recipeServings, ingredients: recipeIngredients, imageURL: recipeImagePath))
    }
    
    func addToList() {
        let db = MyRecipesDB()
        db.addToList(recipe: Recipe(recipeID: recipeID, title: recipeTitle, instructions: recipeInstructions, readyTime: recipeReadyInMinutes, servings: recipeServings, ingredients: recipeIngredients, imageURL: recipeImagePath))
    }
    
    func removeFromMyRecipes() {
        let db = MyRecipesDB()
        db.removeFromMyRecipes(recipeID: recipeID)
    }
    
    func fetchRecipeDetail(recipeID: Int) {
        let urlToRequest = "https://spoonacular-recipe-food-nutrition-v1.p.mashape.com/recipes/\(recipeID)/information?includeNutrition=false"
        let apiKey = "yMn7M1DywmmshjLnVrGx90sD2ESIp1XfB2ijsnfU7kDaPhYGLb"
        
        let url1 = URL(string: urlToRequest)!
        let session1 = URLSession.shared
        
        let request = NSMutableURLRequest(url: url1)
        request.httpMethod = "GET"
        request.setValue(apiKey, forHTTPHeaderField: "X-Mashape-Key")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        
        let task = session1.dataTask(with: request as URLRequest) {
            (data, response, error) in
            guard let _: Data = data, let _: URLResponse = response, error == nil else {
                print("error")
                return
            }
            do {
                let jsonResult = try JSONSerialization.jsonObject(with: data!, options: []) as! [String: Any]
                self.getRecipeDetailFromJson(result: jsonResult)
            }
            catch let err {
                print(err.localizedDescription)
            }
        }
        task.resume()
    }
    
    func getRecipeDetailFromJson(result: [String: Any]) {
        let RECIPEID = "id"
        let RECIPETITLE = "title"
        let INSTRUCTIONS = "instructions"
        let IMAGE = "image"
        let READYINMINUTES = "readyInMinutes"
        let SERVINGS = "servings"
        let INGREDIENTS = "extendedIngredients"
        let IID = "id"
        let INAME = "name"
        let IAMOUNT = "amount"
        let IUNIT = "unit"
        let ISHORTUNIT = "unitShort"
        let ILONGUNIT = "unitLong"
        let IORIGINALSTRING = "originalString"
        
        guard let ingredientJsonArray = result[INGREDIENTS] as? [[String: Any]] else {
            print("failed to process json")
            return
        }
        if let rID = result[RECIPEID] as? Int,
        let rTitle = result[RECIPETITLE] as? String,
        let rInstructions = result[INSTRUCTIONS] as? String,
        let rImage = result[IMAGE] as? String,
        let rReadyInMinutes = result[READYINMINUTES] as? Int,
        let rServings = result[SERVINGS] as? Int {
            //add data to views
            //add data to class
            recipeID = rID
            recipeTitle = rTitle
            recipeInstructions = rInstructions
            recipeImagePath = rImage
            recipeReadyInMinutes = rReadyInMinutes
            recipeServings = rServings
        }
        
        
        var ingredientBodyString: String = ""
        for ingredient in ingredientJsonArray {
            if let iID = ingredient[IID] as? Int,
                let iName = ingredient[INAME] as? String,
                let iAmount = ingredient[IAMOUNT] as? Double,
                let iUnit = ingredient[IUNIT] as? String,
                let iShortUnit = ingredient[ISHORTUNIT] as? String,
                let iLongUnit = ingredient[ILONGUNIT] as? String,
                let iOriginalString = ingredient[IORIGINALSTRING] as? String {
                let returnIngredient = Ingredient(ingredientID: iID, name: iName, amount: iAmount, unit: iUnit, unitShort: iShortUnit, unitLong: iLongUnit, originalString: iOriginalString)
                recipeIngredients.append(returnIngredient)
                ingredientBodyString.append("\(iOriginalString)\n")
                ingredientsBodyString = ingredientBodyString.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
            }
        }
        DispatchQueue.main.asyncAfter(deadline: .now()) {
            self.setUI()

            //refresh view
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
}
