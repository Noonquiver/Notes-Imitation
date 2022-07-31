//
//  ViewController.swift
//  Notes Imitation
//
//  Created by Camilo Hernández Guerrero on 30/07/22.
//

import UIKit

class ViewController: UITableViewController {
    var notes = [Note]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        notes.append(Note(title: "a", content: "b"))
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        notes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Note", for: indexPath)
        var configuration = cell.defaultContentConfiguration()
        configuration.text = notes[indexPath.row].title
        cell.contentConfiguration = configuration
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let detailViewController = storyboard?.instantiateViewController(withIdentifier: "DetailViewController") as? DetailViewController {
            navigationController?.pushViewController(detailViewController, animated: true)
        }
    }
}
