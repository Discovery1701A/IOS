//
//  KokiViewController.swift
//  Koki
//
//  Created by Anna Rieckmann on 28.07.23.
//

import UIKit
class KokiViewController : UIViewController {
    @IBOutlet var nameLabel : UILabel!
    @IBOutlet var nummerLabel : UILabel!
    @IBOutlet var zutatenTable : UITableView!
    
    var rezept : Rezept!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nameLabel.text = rezept.name
        var zutatenstring : String
        for zutat in rezept.zutaten {
            zutatenstring = zutat
        }
        nummerLabel.text = rezept.zubereitung
       
        
    
    }
}
