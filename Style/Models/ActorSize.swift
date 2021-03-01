//
//  ActorSize.swift
//  Scene Me
//
//  Created by Vince Davis on 2/17/21.
//

import Foundation
import SwiftUI
import Combine
import FirebaseFirestore
import FirebaseFirestoreSwift
import FirebaseStorage

struct ActorSize: Identifiable, Codable {
    @DocumentID var id: String?
    var actorId: String
    var height: String
    var weight: String
    var hairColor: String
    var eyeColor: String
    var shoeSize: String
    var suitSize: String
    var shirtSize: String
    var pantsSize: String
    var skirtSize: String
    var dressSize: String
    var head: String
    var headNotes: String
    var neck: String
    var neckNotes: String
    var shoulderWidth: String
    var shoulderWidthNotes: String
    var bust: String
    var bustNotes: String
    var chest: String
    var chestNotes: String
    var upperArm: String
    var upperArmNotes: String
    var lowerArm: String
    var lowerArmNotes: String
    var neckToWaistFront: String
    var neckToWaistFrontNotes: String
    var neckToWaistBack: String
    var neckToWaistBackNotes: String
    var underArmSeam: String
    var underArmSeamNotes: String
    var neckToFloor: String
    var neckToFloorNotes: String
    var waist: String
    var waistNotes: String
    var hips: String
    var hipsNotes: String
    var waistKneecap: String
    var waistKneecapNotes: String
    var kneeToFloor: String
    var kneeToFloorNotes: String
    var legOuterSeam: String
    var legOuterSeamNotes: String
    var inseam: String
    var inseamNotes: String
    var other: String
    var otherNotes: String
    
    @ServerTimestamp var createdTime: Timestamp?
    
    enum CodingKeys: String, CodingKey {
        case id
        case actorId
        case height
        case weight
        case hairColor
        case eyeColor
        case shoeSize
        case suitSize
        case shirtSize
        case pantsSize
        case skirtSize
        case dressSize
        case head
        case headNotes
        case neck
        case neckNotes
        case shoulderWidth
        case shoulderWidthNotes
        case bust
        case bustNotes
        case chest
        case chestNotes
        case upperArm
        case upperArmNotes
        case lowerArm
        case lowerArmNotes
        case neckToWaistFront
        case neckToWaistFrontNotes
        case neckToWaistBack
        case neckToWaistBackNotes
        case underArmSeam
        case underArmSeamNotes
        case neckToFloor
        case neckToFloorNotes
        case waist
        case waistNotes
        case hips
        case hipsNotes
        case waistKneecap
        case waistKneecapNotes
        case kneeToFloor
        case kneeToFloorNotes
        case legOuterSeam
        case legOuterSeamNotes
        case inseam
        case inseamNotes
        case other
        case otherNotes
    }
}

extension ActorSize: FirebaseObjectable {
    var objectName: String {
        return "actorSizes"
    }
    
    var objectId: String? {
        return id
    }
    
    var dict: [String: Any] {
        return [
            "actorId": actorId,
            "height": height,
            "weight": weight,
            "hairColor": hairColor,
            "eyeColor": eyeColor,
            "shoeSize": shoeSize,
            "suitSize": suitSize,
            "shirtSize": shirtSize,
            "pantsSize": pantsSize,
            "skirtSize": skirtSize,
            "dressSize": dressSize,
            "head": head,
            "headNotes": headNotes,
            "neck": neck,
            "neckNotes": neckNotes,
            "shoulderWidth": shoulderWidth,
            "shoulderWidthNotes": shoulderWidthNotes,
            "bust": bust,
            "bustNotes": bustNotes,
            "chest": chest,
            "chestNotes": chestNotes,
            "upperArm": upperArm,
            "upperArmNotes": upperArmNotes,
            "lowerArm": lowerArm,
            "lowerArmNotes": lowerArmNotes,
            "neckToWaistFront": neckToWaistFront,
            "neckToWaistFrontNotes": neckToWaistFrontNotes,
            "neckToWaistBack": neckToWaistBack,
            "neckToWaistBackNotes": neckToWaistBackNotes,
            "underArmSeam": underArmSeam,
            "underArmSeamNotes": underArmSeamNotes,
            "neckToFloor": neckToFloor,
            "neckToFloorNotes": neckToFloorNotes,
            "waist": waist,
            "waistNotes": waistNotes,
            "hips": hips,
            "hipsNotes": hipsNotes,
            "waistKneecap": waistKneecap,
            "waistKneecapNotes": waistKneecapNotes,
            "kneeToFloor": kneeToFloor,
            "kneeToFloorNotes": kneeToFloorNotes,
            "legOuterSeam": legOuterSeam,
            "legOuterSeamNotes": legOuterSeamNotes,
            "inseam": inseam,
            "inseamNotes": inseamNotes,
            "other": other,
            "otherNotes": otherNotes
        ]
    }
    
    var successMessage: String {
        return "Actor Sizes Added"
    }
}

/// Preview Data
extension ActorSize {
    static func preview() -> ActorSize {
        return ActorSize(id: nil,
                         actorId: "",
                         height: "",
                         weight: "",
                         hairColor: "",
                         eyeColor: "",
                         shoeSize: "",
                         suitSize: "",
                         shirtSize: "",
                         pantsSize: "",
                         skirtSize: "",
                         dressSize: "",
                         head: "",
                         headNotes: "",
                         neck: "",
                         neckNotes: "",
                         shoulderWidth: "",
                         shoulderWidthNotes: "",
                         bust: "",
                         bustNotes: "",
                         chest: "",
                         chestNotes: "",
                         upperArm: "",
                         upperArmNotes: "",
                         lowerArm: "",
                         lowerArmNotes: "",
                         neckToWaistFront: "",
                         neckToWaistFrontNotes: "",
                         neckToWaistBack: "",
                         neckToWaistBackNotes: "",
                         underArmSeam: "",
                         underArmSeamNotes: "",
                         neckToFloor: "",
                         neckToFloorNotes: "",
                         waist: "",
                         waistNotes: "",
                         hips: "",
                         hipsNotes: "",
                         waistKneecap: "",
                         waistKneecapNotes: "",
                         kneeToFloor: "",
                         kneeToFloorNotes: "",
                         legOuterSeam: "",
                         legOuterSeamNotes: "",
                         inseam: "",
                         inseamNotes: "",
                         other: "",
                         otherNotes: "",
                         createdTime: nil)
    }
}
