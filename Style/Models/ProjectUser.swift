//
//  ProjectUser.swift
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

struct ProjectUser: Identifiable, Codable, Hashable {
    @DocumentID var id: String?
    var uid: String
    var firstName: String
    var lastName: String
    var phone: String
    var title: String
    var image: String
    var msgToken: [String]
    
    @ServerTimestamp var createdTime: Timestamp?
    
    enum CodingKeys: String, CodingKey {
        case id
        case uid
        case firstName
        case lastName
        case phone
        case title
        case image
        case msgToken
    }
}

/// Protocols
extension ProjectUser: FirebaseObjectable {
    var objectName: String {
        return "users"
    }
    
    var objectId: String? {
        return id
    }
    
    var dict: [String: Any] {
        return [
            "uid": uid,
            "firstName": firstName,
            "lastName": lastName,
            "phone": phone,
            "title": title,
            "image": image,
            "msgToken": msgToken
        ]
    }
    
    var successMessage: String {
        return "Project added"
    }
}

/// Methods
extension ProjectUser {
    
}

/// Preview
extension ProjectUser {
    static func preview() -> ProjectUser {
        return ProjectUser(id: nil,
                           uid: "12345",
                           firstName: "Taye",
                           lastName: "Diggs",
                           phone: "8472128597",
                           title: "Software Engineer",
                           image: "",
                           msgToken: [],
                           createdTime: nil)
    }
}
