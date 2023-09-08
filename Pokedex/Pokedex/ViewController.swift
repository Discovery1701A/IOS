//
//  ViewController.swift
//  Pokedex
//
//  Created by Anna Rieckmann on 28.07.23.
//

import UIKit

class ViewController: UITableViewController {

    var pokemon : [Pokemon] = []
    func capitalize (text : String) -> String {
        return text.prefix(1).uppercased() + text.dropFirst()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        let url = URL(string: "https://pokeapi.co/api/v2/pokemon?limit=1000")
        guard let u = url else {
            return
        }
        URLSession.shared.dataTask(with: u) { data, respons, error in
            guard let data = data else {
                return
            }
            do {
                let pokemonList = try JSONDecoder().decode(PokemonList.self, from: data)
                //print (pokemonList["results"]["name"])
                self.pokemon = pokemonList.results
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                    print("\(self.pokemon)")
                }
            }
            catch let error {
                print("\(error)")
            }
        }.resume()
    }
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pokemon.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PokemonCell", for: indexPath)
        cell.textLabel?.text = self.capitalize(text: pokemon[indexPath.row].name)
        return cell
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "PokemonSegue"{
            if let destination = segue.destination as? PokemonViewController{
                destination.pokemon = pokemon[tableView.indexPathForSelectedRow!.row]
            }
        }
    }
}

