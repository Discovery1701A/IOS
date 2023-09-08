//
//  ViewController.swift
//  Koki
//
//  Created by Anna Rieckmann on 28.07.23.
//

import UIKit

class ViewController: UITableViewController {

    var rezept = [
        Rezept(name: "Pudding", zutaten:["Eier","Milch"], zubereitung : "rühren")
        
    ]
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rezept.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PokemonCell", for: indexPath)
        cell.textLabel?.text = rezept[indexPath.row].name
        return cell
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "PokemonSegue"{
            if let destination = segue.destination as? KokiViewController{
                destination.rezept = rezept[tableView.indexPathForSelectedRow!.row]
            }
        }
    }
}

