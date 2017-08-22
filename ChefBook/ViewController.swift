//
//  ViewController.swift
//  ChefBook
//
//  Created by bradley on 8/6/17.
//  Copyright © 2017 Ben Bradley. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "IntroSearchToGrid" {
            let dvc = segue.destination as! MyRecipesViewController
            dvc.searchClicked = true
        }
    }
}

