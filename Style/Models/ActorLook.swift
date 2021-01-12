//
//  ActorLook.swift
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

struct ActorLook: Identifiable, Codable {
    @DocumentID var id: String?
    var actorId: String
    var image: String
    var text: String
    var completed: Bool
    var creatorId: String
    var lastUpdated: Date
    
    @ServerTimestamp var createdTime: Timestamp?
    
    enum CodingKeys: String, CodingKey {
        case id
        case actorId
        case image
        case text
        case completed
        case creatorId
        case lastUpdated
    }
}

/// Protocols
extension ActorLook: FirebaseObjectable {
    var objectName: String {
        return "actorLooks"
    }
    
    var objectId: String? {
        return id
    }
    
    var dict: [String: Any] {
        return [
            "actorId": actorId,
            "image": image,
            "text": text,
            "completed": completed,
            "creatorId": creatorId,
            "lastUpdated": lastUpdated
        ]
    }
    
    var successMessage: String {
        return "Actor Look added"
    }
}

/// Methods
extension ActorLook {

}

/// Preview Data
extension ActorLook {
    static func preview() -> ActorLook {
        return ActorLook(id: "12345",
                     actorId: "12345",
                     image: "https://static.gofugyourself.com/uploads/2013/10/185512559_10-820x1292.jpg",
                     text: "Look for Viola Davis",
                     completed: false,
                     creatorId: "12345",
                     lastUpdated: Date())
    }
}
