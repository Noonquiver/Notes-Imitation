//
//  ViewController.swift
//  Notes Imitation
//
//  Created by Camilo Hernández Guerrero on 30/07/22.
//

import UIKit

class ViewController: UITableViewController {
    static var notes = [Note]()
    static var untitledNotes = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let JSONDecoder = JSONDecoder()
        let defaults = UserDefaults.standard
        guard let savedData = defaults.object(forKey: "notes") as? Data else { return }
                
        if let savedNotes = try? JSONDecoder.decode([Note].self, from: savedData) {
            ViewController.notes = savedNotes
            ViewController.untitledNotes = defaults.integer(forKey: "untitledNotes")
        }
        
        tableView.reloadData()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(createNote))
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        ViewController.notes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Note", for: indexPath)
        var configuration = cell.defaultContentConfiguration()
        configuration.text = ViewController.notes[indexPath.row].title
        cell.contentConfiguration = configuration
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let detailViewController = storyboard?.instantiateViewController(withIdentifier: "DetailViewController") as? DetailViewController {
            detailViewController.selectedNote = ViewController.notes[indexPath.row]
            detailViewController.index = indexPath.row
            navigationController?.pushViewController(detailViewController, animated: true)
        }
    }
    
    @objc func createNote() {
        let note = Note()
        
        if ViewController.notes.contains(where: {
            noteInNotes in
            noteInNotes.title.contains("Untitled")
        }) {
            note.title += "\(ViewController.untitledNotes)"
        }
        
        ViewController.untitledNotes += 1
        ViewController.notes.append(note)
        
        ViewController.encodeNotes()
        
        tableView.reloadData()
    }
    
    static func encodeNotes() {
        let JSONEncoder = JSONEncoder()
        let defaults = UserDefaults.standard
        
        if let savedData = try? JSONEncoder.encode(notes) {
            defaults.set(savedData, forKey: "notes")
            defaults.set(untitledNotes, forKey: "untitledNotes")
        }
    }
}
