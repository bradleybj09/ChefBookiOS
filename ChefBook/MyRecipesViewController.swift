//
//  MyRecipesViewController.swift
//  ChefBook
//
//  Created by bradley on 8/10/17.
//  Copyright © 2017 Ben Bradley. All rights reserved.
//

import UIKit
import Kingfisher

class MyRecipesViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UISearchBarDelegate {
    
    var searchClicked = false
    let cellIdentifier = "RecipeCell"
    private let itemsPerRow: CGFloat = 2
    private let sectionInsets = UIEdgeInsets(top: 8.0, left: 8.0, bottom: 8.0, right: 8.0)
    var recipeArray: [Recipe] = []
    var finished = false
    var cellSize = CGSize(width: 0, height: 0)
    var targeted = false

    @IBAction func loadMyRecipes(_ sender: Any) {
        fetchMyRecipeGrid()
    }
    
    @IBAction func initializeSearch(_ sender: Any) {
        searchController = UISearchController(searchResultsController: nil)
        
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.keyboardType = UIKeyboardType.asciiCapable
        
        self.searchController.searchBar.delegate = self
        present(searchController, animated: true, completion: nil)
    }
    
    func removeSearch() {
        searchController.dismiss(animated: true, completion: nil)
    }
    
    
    @IBOutlet weak var recipeCollectionView: UICollectionView!
    var searchController: UISearchController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        recipeCollectionView.dataSource = self
        recipeCollectionView.delegate = self
        fetchMyRecipeGrid()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if searchClicked {
            searchController = UISearchController(searchResultsController: nil)
            
            searchController.hidesNavigationBarDuringPresentation = false
            searchController.searchBar.keyboardType = UIKeyboardType.asciiCapable
            
            self.searchController.searchBar.delegate = self
            present(searchController, animated: true, completion: nil)
        }
    }
    
    func reloadCollection() {
        self.recipeCollectionView!.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func fetchMyRecipeGrid() {
        let db = MyRecipesDB()
        recipeArray = db.queryMyRecipes()
        if recipeArray.count < 1 {
            return
        }
        finished = true
        self.recipeCollectionView.reloadData()
    }
    
    func fetchRecipeGrid(query: String) {
        recipeArray.removeAll()
        let formattedQuery: String = query.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
        let urlToSearch = "https://spoonacular-recipe-food-nutrition-v1.p.mashape.com/recipes/search?limitLicense=false&number=24&offset=0&query=\(formattedQuery))"
        let apiKey = "yMn7M1DywmmshjLnVrGx90sD2ESIp1XfB2ijsnfU7kDaPhYGLb"
        
        let url1 = URL(string: urlToSearch)!
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
                self.getRecipesFromJson(result: jsonResult)
            }
            catch let err {
                print(err.localizedDescription)
            }
        }
        task.resume()
    }
    
    func getRecipesFromJson(result: [String: Any]) {
 //       let RECIPES = "recipes"
        let RESULTS = "results"
        let ID = "id"
        let TITLE = "title"
        let IMAGEURL = "image"
        
        guard let recipeJsonArray = result[RESULTS] as? [[String: Any]] else {
            print("failed to process json")
            return
        }
        for recipe in recipeJsonArray {
            if let recipeTitle = recipe[TITLE] as? String,
            let recipeID = recipe[ID] as? Int,
                let recipeImageUrl = recipe[IMAGEURL] as? String {
                let returnRecipe = Recipe(recipeID: recipeID, title: recipeTitle, imageURL: "https://spoonacular.com/recipeImages/\(recipeImageUrl)")
                recipeArray.append(returnRecipe)
                print(recipeTitle)
            }
        }
        DispatchQueue.main.asyncAfter(deadline: .now()) {
            self.finished = true
            self.recipeCollectionView.reloadData()
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

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "GridCellToDetail" {
            let cell = sender as! RecipeCollectionViewCell
            let dvc =  segue.destination as! RecipeDetailViewController
            dvc.recipeID = cell.recipeID
            dvc.recipeTitle = cell.recipeTitle
            dvc.recipeImagePath = cell.recipeImagePath
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if finished {
            return recipeArray.count
        } else {
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! RecipeCollectionViewCell
        if finished {
            let url = URL(string: recipeArray[indexPath.item].imageURL!)
            let rID = recipeArray[indexPath.item].recipeID
            let rTitle = recipeArray[indexPath.item].title
            let rImagePath = recipeArray[indexPath.item].imageURL
            cell.recipeCellImage.contentMode = UIViewContentMode.scaleAspectFill
            cell.recipeCellImage.clipsToBounds = true
            cell.recipeCellImage.kf.setImage(with: url)
            cell.recipeCellTitle.text = rTitle!
            cell.recipeID = rID!
            cell.recipeTitle = rTitle!
            cell.recipeImagePath = rImagePath!
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let paddingSpace = sectionInsets.left * (itemsPerRow + 2)
        let availableWidth = view.subviews[1].frame.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow
        cellSize = CGSize(width: widthPerItem, height: widthPerItem*1.25)
        return cellSize
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.left
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let search: String = searchBar.text!.trimmingCharacters(in: CharacterSet.whitespaces)
        searchBar.resignFirstResponder()
        removeSearch()
        if search.characters.count > 0 {
            fetchRecipeGrid(query: search)
        }
    }
}
