//
//  SceneActor.swift
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

struct SceneActor: Identifiable, Codable {
    @DocumentID var id: String?
    var sceneActorId: String
    var name: String
    var top: String
    var bottom: String
    var shoes: String
    var accessories: String
    var notes: String
    var beforeLook: Bool
    var images: [String]
    
    @ServerTimestamp var createdTime: Timestamp?
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case sceneActorId
        case top
        case bottom
        case shoes
        case accessories
        case notes
        case beforeLook
        case images
    }
}

/// Protocols
extension SceneActor: FirebaseObjectable {
    var objectName: String {
        return "sceneActors"
    }
    
    var objectId: String? {
        return id
    }
    
    var successMessage: String {
        return "Scene Image added"
    }
    
    var dict: [String: Any] {
        return [
            "sceneActorId": sceneActorId,
            "name": name,
            "top": top,
            "bottom": bottom,
            "shoes": shoes,
            "accessories": accessories,
            "notes": notes,
            "beforeLook": beforeLook,
            "images": images
        ]
    }
}

/// Methods
extension SceneActor {
    
}

/// Preview
//extension SceneActor {
//    static func preview() -> SceneActor {
//        return SceneActor(from: <#Decoder#>)
//    }
//}
