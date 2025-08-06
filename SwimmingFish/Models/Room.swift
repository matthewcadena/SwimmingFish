//
//  Room.swift
//  Swimming Fish
//
//  Created by Matt Cadena on 7/27/25.
//

import Foundation
import FirebaseFirestore

struct Room: Codable, Identifiable {
    @DocumentID var id: String?
    var nemoMessage: String
    var squishMessage: String
}
