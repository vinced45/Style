//
//  SessionStore.swift
//  Style
//
//  Created by Vince Davis on 11/14/20.
//

import SwiftUI
import Firebase
import Combine
import FBSDKLoginKit

class SessionStore: ObservableObject {
    var didChange = PassthroughSubject<SessionStore, Never>()
    @Published var session: User? {
        didSet {
            self.didChange.send(self)
        }
    }
    
    var handle: AuthStateDidChangeListenerHandle?
    
    func listen() {
        handle = Auth.auth().addStateDidChangeListener({ auth, user in
            guard let user = user else {
                self.session = nil
                return
            }
            self.session = User(uid: user.uid, email: user.email)
        })
    }
    
    func signUp(email: String, password: String, handler: @escaping AuthDataResultCallback) {
        Auth.auth().createUser(withEmail: email, password: password, completion: handler)
    }
    
    func signIn(email: String, password: String, handler: @escaping AuthDataResultCallback) {
        Auth.auth().signIn(withEmail: email, password: password, completion: handler)
    }
    
    func fbSignIn() {
        guard let token = AccessToken.current?.tokenString else { return }
        let credential = FacebookAuthProvider.credential(withAccessToken: token)
        Auth.auth().signIn(with: credential) { (authResult, error) in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            print("FB singed in")
        }
    }
    
    func googleSignIn(with credential: AuthCredential) {
        Auth.auth().signIn(with: credential) { (authResult, error) in
          if let error = error {
            print(error.localizedDescription)
          }
            print("Google Signin")
        }
    }
    
    func signOut() {
        do {
            try Auth.auth().signOut()
            self.session = nil
        } catch {
            print("error signing out")
        }
    }
    
    func getUserDetails(completion: @escaping (User?) -> Void) {
        guard let userInfo = Auth.auth().currentUser?.providerData.first else { return completion(nil) }
        
        return completion(User(userInfo: userInfo))
    }
    
    func updateUserDetails(for user: [String: String], completion: @escaping (Bool) -> Void) {
        
        let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
        changeRequest?.setValue(user["firstName"], forKey: "firstName")
        changeRequest?.setValue(user["lastName"], forKey: "lastName")
        changeRequest?.setValue(user["title"], forKey: "title")
        changeRequest?.setValue(user["phone"], forKey: "phone")
        changeRequest?.photoURL = URL(string: user["image"] ?? "")
        //changeRequest?.displayName = (user.firstName ?? "") +  " " + (user.lastName ?? "")
        changeRequest?.commitChanges { (error) in
            if let _ = error {
                return completion(false)
            } else {
                completion(true)
            }
        }
    }
    
    func unbind() {
        guard let handle = handle else { return }
        
        Auth.auth().removeStateDidChangeListener(handle)
    }
    
    deinit {
        unbind()
    }
}

struct User {
    var uid: String
    var email: String?
    var firstName: String?
    var lastName: String?
    var phoneNumber: String?
    var title: String?
    var imageUrl: String?
    
    init(uid: String, email: String?) {
        self.uid = uid
        self.email = email
    }
    
    init(userInfo: UserInfo) {
        self.uid = userInfo.uid
        self.email = userInfo.email
    }
}
