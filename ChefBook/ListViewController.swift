//
//  ListViewController.swift
//  ChefBook
//
//  Created by bradley on 8/20/17.
//  Copyright © 2017 Ben Bradley. All rights reserved.
//

import UIKit


class ListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, RecipeCellDelegate, IngredientCellDelegate {

    var listRecipeArray: [Recipe] = []
    var listIngredientArray: [Ingredient] = []
    
    @IBOutlet weak var recipeTableView: UITableView!
    @IBOutlet weak var ingredientTableView: UITableView!
    
    @IBAction func emptyShoppingList(_ sender: Any) {
        let db = MyRecipesDB()
        db.emptyList()
        listRecipeArray.removeAll()
        listIngredientArray.removeAll()
        recipeTableView.reloadData()
        ingredientTableView.reloadData()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        recipeTableView.delegate = self
        recipeTableView.dataSource = self
        ingredientTableView.delegate = self
        ingredientTableView.dataSource = self
        fetchListRecipes()
        fetchListIngredients()
        recipeTableView.reloadData()
        ingredientTableView.reloadData()
    }
    
    func fetchListRecipes() {
        let db = MyRecipesDB()
        listRecipeArray = db.queryListRecipes()
    }
    
    func fetchListIngredients() {
        let db = MyRecipesDB()
        listIngredientArray = db.queryListIngredients()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == self.recipeTableView {
            if listRecipeArray.count == 0 {
                return tableView.dequeueReusableCell(withIdentifier: "RecipeListCell")!
            }
            let cell = tableView.dequeueReusableCell(withIdentifier: "RecipeListCell") as! ListRecipeCell
            cell.id = listRecipeArray[indexPath.item].recipeID
            cell.title = listRecipeArray[indexPath.item].title
            cell.recipeTitleLabel.text = cell.title
            cell.indexPath = indexPath
            cell.delegate = self
            return cell
        } else {
            if listIngredientArray.count == 0 {
                return tableView.dequeueReusableCell(withIdentifier: "IngredientListCell")!
            }
            let cell = tableView.dequeueReusableCell(withIdentifier: "IngredientListCell") as! ListIngredientCell
            cell.id = listIngredientArray[indexPath.item].ingredientID
            cell.title = listIngredientArray[indexPath.item].name
            cell.amount = listIngredientArray[indexPath.item].amount
            cell.unit = listIngredientArray[indexPath.item].unit
            cell.unitLong = listIngredientArray[indexPath.item].unitLong
            var unitString = ""
            if cell.amount! > 1.0 {
                unitString = cell.unit!
            } else {
                unitString = cell.unitLong!
            }
            cell.ingredientTitleLabel.text = "\(cell.amount!) \(unitString) \(cell.title!)"
            cell.indexPath = indexPath
            cell.delegate = self
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == self.recipeTableView {
            if listRecipeArray.count == 0 {
                return 0
            }
            return listRecipeArray.count
        } else {
            if listIngredientArray.count == 0 {
                return 0
            }
            return listIngredientArray.count
        }
    }

    func removeRCellFromTable(at: IndexPath) {
        listRecipeArray.remove(at: at.row)
        recipeTableView.deleteRows(at: [at], with: .automatic)
        fetchListIngredients()
        recipeTableView.reloadData()
        ingredientTableView.reloadData()
    }
    
    func removeICellFromTable(at: IndexPath) {
        listIngredientArray.remove(at: at.row)
        ingredientTableView.deleteRows(at: [at], with: .automatic)
        ingredientTableView.reloadData()
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
