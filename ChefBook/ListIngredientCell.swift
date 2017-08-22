//
//  ListIngredientCell.swift
//  ChefBook
//
//  Created by bradley on 8/20/17.
//  Copyright © 2017 Ben Bradley. All rights reserved.
//

import UIKit

protocol IngredientCellDelegate {
    func removeICellFromTable(at: IndexPath)
}
class ListIngredientCell: UITableViewCell {

    var indexPath: IndexPath?
    var delegate: IngredientCellDelegate!
    var id: Int?
    var title: String?
    var amount: Double?
    var unit: String?
    var unitLong: String?

    @IBOutlet weak var ingredientTitleLabel: UILabel!
    @IBAction func removeIngredientFromList(_ sender: Any) {
        let db = MyRecipesDB()
        db.removeIngredientFromList(ingredientID: id!)
        self.delegate?.removeICellFromTable(at: indexPath!)
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
