//
//  Note.swift
//  Notes Imitation
//
//  Created by Camilo Hernández Guerrero on 30/07/22.
//
import UIKit

class Note: Codable, Equatable {
    var title: String = "Untitled"
    var content: String = ""
    
    static func == (lhs: Note, rhs: Note) -> Bool {
        if lhs.title.elementsEqual(rhs.title) && lhs.content.elementsEqual(rhs.content) {
            return true
        }
        
        return false
    }
}
