//
//  Note.swift
//  Notes Imitation
//
//  Created by Camilo Hernández Guerrero on 30/07/22.
//

class Note: Codable {
    var title: String
    var content: String
    
    init(title: String, content: String) {
        self.title = title
        self.content = content
    }
}
