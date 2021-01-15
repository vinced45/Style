//
//  FBLoginButton.swift
//  Style
//
//  Created by Vince Davis on 11/15/20.
//

import UIKit
import SwiftUI
import Foundation
import FBSDKLoginKit
import Firebase

struct FacebookLoginButton: UIViewRepresentable {
    let button = FBLoginButton()
    var result: (LoginManagerLoginResult?) -> Void
    
    func makeUIView(context: Context) -> FBLoginButton {
        return button
    }

    func updateUIView(_ uiView: FBLoginButton, context: Context) { }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(button: button, result: result)
    }

    class Coordinator: NSObject, LoginButtonDelegate {
        var result: (LoginManagerLoginResult?) -> Void
        
        init(button: FBLoginButton, result: @escaping (LoginManagerLoginResult?) -> Void) {
            self.result = result
            super.init()
            button.delegate = self
        }
        
        func loginButton(_ loginButton: FBLoginButton, didCompleteWith result: LoginManagerLoginResult?, error: Error?) {
            self.result(result)
            //print("fb result \(result)")
        }
        
        func loginButtonDidLogOut(_ loginButton: FBLoginButton) {
            print("logged out of FB")
        }
    }
}
