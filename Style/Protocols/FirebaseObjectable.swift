//
//  FirebaseObjectable.swift
//  Style
//
//  Created by Vince Davis on 1/11/21.
//

import Foundation

protocol FirebaseObjectable {
    //init?(dict:[String:AnyObject])
    var objectName: String {  get }
    var objectId: String? { get }
    var dict: [String: Any] { get }
    var successMessage: String { get }
}
