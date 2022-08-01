//
//  DetailViewController.swift
//  Notes Imitation
//
//  Created by Camilo Hernández Guerrero on 30/07/22.
//

import UIKit

class DetailViewController: UIViewController {
    @IBOutlet var textView: UITextView!
    
    var selectedNote: Note!
    var index: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = selectedNote.title
        textView.text = selectedNote.content
        
        let delete = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(deleteNote))
        let editName = UIBarButtonItem(title: "Edit name", style: .plain, target: self, action: #selector(editName))
        let share = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareNote))
        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        setToolbarItems([delete, spacer, editName, spacer, share], animated: true)
        navigationController?.isToolbarHidden = false
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        selectedNote.content = textView.text
        ViewController.encodeNotes()
    }
    
    @objc func deleteNote() {
        var index = index ?? -1
        
        if index == -1 {
            index = findNoteIndex()
        }
        
        ViewController.notes.remove(at: index)
        ViewController.encodeNotes()
        
        navigationController?.popToRootViewController(animated: true)
    }
    
    @objc func editName() {
        let alertController = UIAlertController(title: "Edit note name", message: nil, preferredStyle: .alert)
        alertController.addTextField()
        
        let submitNoteName = UIAlertAction(title: "Submit", style: .default) {
            [weak self, weak alertController] _ in
            guard let name = alertController?.textFields?[0].text else { return }
            
            if !name.elementsEqual("") {
                self?.selectedNote.title = name
                self?.title = name
            }
            
            ViewController.encodeNotes()
        }
        
        alertController.addAction(submitNoteName)
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(alertController, animated: true)
    }
    
    @objc func shareNote () {
        selectedNote.content = textView.text
        
        let activityViewController = UIActivityViewController(activityItems: [selectedNote.content], applicationActivities: [])
        activityViewController.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(activityViewController, animated: true)
    }
    
    func findNoteIndex() -> Int {
        var index = -1
        
        for (i, note) in ViewController.notes.enumerated() {
            if note == selectedNote {
                index = i
                break
            }
        }
        
        return index
    }
}
