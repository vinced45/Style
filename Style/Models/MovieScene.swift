//
//  MovieScene.swift
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

struct MovieScene: Identifiable, Codable {
    @DocumentID var id: String?
    var projectId: String
    var name: String
    var number: Int
    var actors: [String]
    var images: [String]
    
    @ServerTimestamp var createdTime: Timestamp?
    
    enum CodingKeys: String, CodingKey {
        case id
        case projectId
        case name
        case number
        case actors
        case images
    }
}

/// Protocols
extension MovieScene: FirebaseObjectable {
    var objectName: String {
        return "scenes"
    }
    
    var objectId: String? {
        return id
    }
    
    var dict: [String: Any] {
        return [
            "projectId": projectId,
            "name": name,
            "number": number,
            "actors": actors,
            "images": images
        ]
    }
    
    var successMessage: String {
        return "Scene added"
    }
}

/// Methods
extension MovieScene {
    
}

/// Preview
extension MovieScene {
    static func preview() -> MovieScene {
        return MovieScene(id: nil,
                          projectId: "12345",
                          name: "Dining Room",
                          number: 2,
                          actors: ["12345"],
                          images: [],
                          createdTime: nil)
    }
}
