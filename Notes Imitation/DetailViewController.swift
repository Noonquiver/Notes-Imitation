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
    var index: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = selectedNote.title
        textView.text = selectedNote.content
        
        let delete = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(deleteNote))
        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        setToolbarItems([delete, spacer], animated: true)
        navigationController?.isToolbarHidden = false
    }
    
    @objc func deleteNote() {
        if let tableViewController = storyboard?.instantiateViewController(withIdentifier: "TableViewController") {
            ViewController.notes.remove(at: index)
            ViewController.encodeNotes()
            navigationController?.pushViewController(tableViewController, animated: true)
        }
    }
}
