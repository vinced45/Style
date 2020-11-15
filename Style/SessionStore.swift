//
//  SessionStore.swift
//  Style
//
//  Created by Vince Davis on 11/14/20.
//

import SwiftUI
import Firebase
import Combine

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
    
    func signOut() {
        do {
            try Auth.auth().signOut()
            self.session = nil
        } catch {
            print("error signing out")
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
    
    init(uid: String, email: String?) {
        self.uid = uid
        self.email = email
    }
}
