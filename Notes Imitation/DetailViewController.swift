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
        
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
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
    
    @objc func adjustForKeyboard(notification: Notification) {
        guard let keyboardValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        let keyboardScreenEndFrame = keyboardValue.cgRectValue
        let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, to: view.window)
        
        if notification.name == UIResponder.keyboardWillHideNotification {
            textView.contentInset = .zero
        } else {
            textView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height - view.safeAreaInsets.bottom, right: 0)
        }
        
        textView.scrollIndicatorInsets = textView.contentInset
        textView.scrollRangeToVisible(textView.selectedRange)
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
