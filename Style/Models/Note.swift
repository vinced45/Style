//
//  Note.swift
//  Style
//
//  Created by Vince Davis on 1/11/21.
//

import Foundation
import SwiftUI
import Combine
import FirebaseFirestore
import FirebaseFirestoreSwift
import FirebaseStorage

struct Note: Identifiable, Codable {
    @DocumentID var id: String?
    var actorId: String
    var text: String
    var creatorId: String
    var lastUpdated: Date
    
    @ServerTimestamp var createdTime: Timestamp?
    
    enum CodingKeys: String, CodingKey {
        case id
        case actorId
        case text
        case creatorId
        case lastUpdated
    }
}

/// Protocols
extension Note: FirebaseObjectable {
    var objectName: String {
        return "notes"
    }
    
    var objectId: String? {
        return id
    }
    
    var dict: [String: Any] {
        return [
            "actorId": actorId,
            "text": text,
            "creatorId": creatorId,
            "lastUpdated": lastUpdated
        ]
    }
    
    var successMessage: String {
        return "Note Added"
    }
}

/// Methods
extension Note {
    
}

/// Preview
extension Note {
    static func preview() -> Note {
        return Note(id: nil,
                    actorId: "12345",
                    text: "This is an example of my long note that could be a little longer.",
                    creatorId: "12345",
                    lastUpdated: Date(),
                    createdTime: nil)
    }
}
