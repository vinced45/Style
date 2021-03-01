//
//  Project.swift
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

struct Project: Identifiable, Codable {
    @DocumentID var id: String?
    var name: String
    var image: String
    var admins: [String]
    var readOnlyUsers: [String]
    var creatorId: String
    var dateCreated: Date
    var lastUser: String
    var lastUpdated: Date
    
    @ServerTimestamp var createdTime: Timestamp?
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case image
        case admins
        case readOnlyUsers
        case creatorId
        case dateCreated
        case lastUser
        case lastUpdated
    }
}

/// Protocols
extension Project: FirebaseObjectable {
    var objectName: String {
        return "projects"
    }
    
    var objectId: String? {
        return id
    }
    
    var dict: [String: Any] {
        return [
                "name": name,
                "image": image,
                "admins": admins,
                "readOnlyUsers": readOnlyUsers,
                "creatorId": creatorId,
                "dateCreated": dateCreated,
                "lastUser": lastUser,
                "lastUpdated": lastUpdated
        ]
    }
    
    var successMessage: String {
        return "Project added"
    }
}

/// Methods
extension Project {
    
}

/// Preview
extension Project {
    static func preview() -> Project {
        return Project(id: "asdasda",
                       name: "BET Movie",
                       image: "https://i0.wp.com/blackyouthproject.com/wp-content/uploads/2018/11/Screenshot_20181127-120025_Gallery.jpg?fit=1439%2C795",
                       admins: [],
                       readOnlyUsers: [],
                       creatorId: "",
                       dateCreated: Date(),
                       lastUser: "",
                       lastUpdated: Date()
                       )
    }
}
