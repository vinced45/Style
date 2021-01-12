//
//  Actor.swift
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

struct Actor: Identifiable, Codable {
    @DocumentID var id: String?
    var projectId: String
    var realName: String
    var screenName: String
    var image: String
    var clothesSize: Int
    var images: [String]
    
    @ServerTimestamp var createdTime: Timestamp?
    
    enum CodingKeys: String, CodingKey {
        case id
        case projectId
        case realName
        case screenName
        case image
        case clothesSize
        case images
    }
}

extension Actor: FirebaseObjectable {
    var objectName: String {
        return "actors"
    }
    
    var objectId: String? {
        return id
    }
    
    var dict: [String: Any] {
        return [
            "projectId": projectId,
            "realName": realName,
            "screenName": screenName,
            "image": image,
            "clothesSize": clothesSize,
            "images": images
        ]
    }
    
    var successMessage: String {
        return "Actor added"
    }
}

/// Methods
extension Actor {
    var clothesText: String {
        switch self.clothesSize {
        case 0: return "Small"
        case 1: return "Medium"
        case 2: return "Large"
        default: return "Extra Large"
        }
    }

}

/// Preview Data
extension Actor {
    static func preview() -> Actor {
        return Actor(id: "12345",
                     projectId: "12345",
                     realName: "Taye Diggs",
                     screenName: "Devin Harris",
                     image: "https://www.theatricalindex.com/media/cimage/persons/taye-diggs/headshot_headshot.jpg",
                     clothesSize: 32,
                     images: [])
    }
}
