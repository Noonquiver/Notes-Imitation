//
//  ViewController.swift
//  Notes Imitation
//
//  Created by Camilo Hernández Guerrero on 30/07/22.
//

import UIKit

class ViewController: UITableViewController {
    static var notes = [Note]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let JSONDecoder = JSONDecoder()
        let defaults = UserDefaults.standard
        guard let savedData = defaults.object(forKey: "notes") as? Data else { return }
                
        if let savedNotes = try? JSONDecoder.decode([Note].self, from: savedData) {
            ViewController.notes = savedNotes
        }
        
        tableView.reloadData()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Compose", style: .plain, target: self, action: #selector(composeNote))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
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
        instantiateNoteView(note: ViewController.notes[indexPath.row], index: indexPath.row)
    }
    
    @objc func composeNote() {
        let note = Note()
        let alertController = UIAlertController(title: "Name your note", message: nil, preferredStyle: .alert)
        alertController.addTextField()
        
        let submitNoteName = UIAlertAction(title: "Submit", style: .default) {
            [weak self, weak alertController] _ in
            guard let name = alertController?.textFields?[0].text else { return }
            
            if !name.elementsEqual("") {
                note.title = name
            }
            
            ViewController.notes.append(note)
            ViewController.encodeNotes()
            self?.instantiateNoteView(note: note)
        }
        
        alertController.addAction(submitNoteName)
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(alertController, animated: true)
    }
    
    static func encodeNotes() {
        let JSONEncoder = JSONEncoder()
        
        if let savedData = try? JSONEncoder.encode(notes) {
            UserDefaults.standard.set(savedData, forKey: "notes")
        }
    }
    
    func instantiateNoteView(note: Note) {
        if let detailViewController = storyboard?.instantiateViewController(withIdentifier: "DetailViewController") as? DetailViewController {
            detailViewController.selectedNote = note
            navigationController?.pushViewController(detailViewController, animated: true)
        }
    }
    
    func instantiateNoteView(note: Note, index: Int) {
        if let detailViewController = storyboard?.instantiateViewController(withIdentifier: "DetailViewController") as? DetailViewController {
            detailViewController.selectedNote = note
            detailViewController.index = index
            navigationController?.pushViewController(detailViewController, animated: true)
        }
    }
}
