//
//  AuthView.swift
//  Style
//
//  Created by Vince Davis on 11/14/20.
//

import SwiftUI

struct SignInView: View {
    
    @State var email: String = ""
    @State var password: String = ""
    @State var error: String = ""
    
    @EnvironmentObject var session: SessionStore
    
    func signIn() {
        session.signIn(email: email, password: password) { result, error in
            if let error = error {
                self.error = error.localizedDescription
            } else {
                self.email = ""
                self.password = ""
            }
        }
    }
    var body: some View {
        VStack {
            Text("Sign in View")
            Text("Sign in to contine")
            
            VStack(spacing: 18) {
                TextField("Email Address", text: $email)
                SecureField("Password", text: $password)
            }
            
            Button("Sign In", action: signIn)
            
            if (error != ""){
                Text(error)
            }
            
            Spacer()
            
            NavigationLink(destination: SignUpView()) {
                HStack {
                    Text("I'm a new User")
                    Text("Create an account")
                }
            }
        }
    }
}

struct SignUpView: View {
    @State var email: String = ""
    @State var password: String = ""
    @State var error: String = ""
    
    @EnvironmentObject var session: SessionStore
    
    func signUp() {
        session.signUp(email: email, password: password) { result, error in
            if let error = error {
                self.error = error.localizedDescription
            } else {
                self.email = ""
                self.password = ""
            }
        }
    }
    
    var body: some View {
        VStack {
            Text("Create Account")
            Text("Sign up to get started")
            
            VStack(spacing: 18) {
                TextField("Email Address", text: $email)
                SecureField("Passwordt", text: $password)
            }
            
            Button(action: signUp) {
                Text("Create Account")
            }
            
            if (error != "") {
                Text(error)
            }
            
            Spacer()
        }
    }
}

struct AuthView: View {
    var body: some View {
        SignInView()
    }
}

struct AuthView_Previews: PreviewProvider {
    static var previews: some View {
        AuthView().environmentObject(SessionStore())
    }
}
