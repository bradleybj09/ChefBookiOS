//
//  ListRecipeCell.swift
//  ChefBook
//
//  Created by bradley on 8/20/17.
//  Copyright © 2017 Ben Bradley. All rights reserved.
//

import UIKit

protocol RecipeCellDelegate {
    func removeRCellFromTable(at: IndexPath)
}

class ListRecipeCell: UITableViewCell {
    
    var delegate: RecipeCellDelegate!
    var indexPath: IndexPath?
    var id: Int?
    var title: String?

    @IBOutlet weak var recipeTitleLabel: UILabel!
    
    @IBAction func removeRecipeFromList(_ sender: Any) {
        let db = MyRecipesDB()
        db.removeRecipeFromList(recipeID: id!)
        self.delegate?.removeRCellFromTable(at: indexPath!)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
