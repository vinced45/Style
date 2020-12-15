//
//  GoogleLoginButton.swift
//  Style
//
//  Created by Vince Davis on 11/16/20.
//

//import UIKit
//import SwiftUI
//import Foundation
//import GoogleSignIn
//import Firebase
//
//struct GoogleLoginButton: UIViewRepresentable {
//    let button = GIDSignInButton()
//    var result: (AuthCredential?) -> Void
//    
//    func makeUIView(context: Context) -> GIDSignInButton {
//        return button
//    }
//
//    func updateUIView(_ uiView: GIDSignInButton, context: Context) { }
//    
//    func makeCoordinator() -> Coordinator {
//        Coordinator(button: button, result: result)
//    }
//
//    class Coordinator: NSObject, GIDSignInDelegate {
//        var result: (AuthCredential?) -> Void
//        
//        init(button: GIDSignInButton, result: @escaping (AuthCredential?) -> Void) {
//            self.result = result
//            super.init()
//            GIDSignIn.sharedInstance().clientID = FirebaseApp.app()?.options.clientID
//            GIDSignIn.sharedInstance().delegate = self
//        }
//        
//        func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
//            if let error = error {
//                print(error.localizedDescription)
//                return
//            }
//
//              guard let authentication = user.authentication else { return }
//              let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken,
//                                                                accessToken: authentication.accessToken)
//            result(credential)
//        }
//        
//        func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
//            // Perform any operations when the user disconnects from app here.
//            // ...
//        }
//    }
//}
