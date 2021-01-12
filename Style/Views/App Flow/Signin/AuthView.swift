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
    
    @ObservedObject var loginViewModel: LoginViewModel
    
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
        NavigationView {
        ZStack {
//            PlayerView()
//                .overlay(Color.pink.opacity(0.2))
//                .blur(radius: 1)
//                .edgesIgnoringSafeArea(.all)
            VStack {
                Text("Sign in View")
                    .font(.system(size: 32, weight: .heavy))
                
                Text("Sign in to contine")
                    .font(.system(size: 18, weight: .medium))
                    .foregroundColor(Color("Gray"))
                
                VStack(spacing: 18) {
                    TextField("Email Address", text: $email)
                        .font(.system(size: 14))
                        .padding(12)
                        .background(RoundedRectangle(cornerRadius: 5).strokeBorder(Color("bg1"), lineWidth: 1))
                    SecureField("Password", text: $password)
                        .font(.system(size: 14))
                        .padding(12)
                        .background(RoundedRectangle(cornerRadius: 5).strokeBorder(Color("bg1"), lineWidth: 1))
                }
                .padding(.vertical, 30)
                
                Button("Sign In", action: signIn)
                    .frame(minWidth: 0, maxWidth: .infinity)
                    .frame(height: 50)
                    .foregroundColor(.white)
                    .font(.system(size: 14, weight: .bold))
                    .background(LinearGradient(gradient: Gradient(colors: [Color("bg1"), Color("bg2")]), startPoint: .leading, endPoint: .trailing))
                    .cornerRadius(5)
                
                Text("OR")
                    .font(.system(size: 24, weight: .regular))
                    .padding()
                
                FacebookLoginButton { result in
                    session.fbSignIn()
                }.frame(maxHeight: 50)
                
    //            GoogleLoginButton { credential in
    //                guard let auth = credential else { return }
    //                session.googleSignIn(with: auth)
    //            }.frame(maxHeight: 28)
                AppleSignInButton()
                    .onTapGesture {
                            self.loginViewModel.attemptAppleSignIn()
                    }.frame(maxHeight: 50)
                
                if (error != ""){
                    Text(error)
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(.red)
                        .padding()
                }
                
                Spacer()
                
                NavigationLink(destination: SignUpView()) {
                    HStack {
                        Text("I'm a new User")
                            .font(.system(size: 14, weight: .light))
                            .foregroundColor(.primary)

                        Text("Create an account")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(Color("bg2"))
                    }
                    .padding(20)
                }
                
//                Button(action: {
//                    //self.showSheetView = false
//                    session.signOut()
//                }) {
//                    HStack {
//                        Text("I'm a new User")
//                            .font(.system(size: 14, weight: .light))
//                            .foregroundColor(.primary)
//                        
//                        Text("Create an account")
//                            .font(.system(size: 14, weight: .semibold))
//                            .foregroundColor(Color("bg2"))
//                    }
//                    
//                    }
//                    .padding(10)
            }
            .padding(.horizontal, 32)
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
                .font(.system(size: 32, weight: .heavy))
            
            Text("Sign up to get started")
                .font(.system(size: 18, weight: .medium))
                .foregroundColor(Color("Gray"))
            
            VStack(spacing: 18) {
                TextField("Email Address", text: $email)
                    .font(.system(size: 14))
                    .padding(12)
                    .background(RoundedRectangle(cornerRadius: 5).strokeBorder(Color("bg1"), lineWidth: 1))
                
                SecureField("Password", text: $password)
                    .font(.system(size: 14))
                    .padding(12)
                    .background(RoundedRectangle(cornerRadius: 5).strokeBorder(Color("bg1"), lineWidth: 1))
            }
            .padding(.vertical, 64)
            
            Button(action: signUp) {
                Text("Create Account")
                    .frame(minWidth: 0, maxWidth: .infinity)
                    .frame(height: 50)
                    .foregroundColor(.white)
                    .font(.system(size: 14, weight: .bold))
                    .background(LinearGradient(gradient: Gradient(colors: [Color("bg1"), Color("bg2")]), startPoint: .leading, endPoint: .trailing))
                    .cornerRadius(5)
            }
            
            if (error != "") {
                Text(error)
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.red)
                    .padding()
            }
            
            Spacer()
        }
        .padding(.horizontal, 32)
    }
}

struct AuthView: View {
    var body: some View {
        SignInView(loginViewModel: LoginViewModel())
        //SignUpView()
    }
}

struct AuthView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            AuthView().environmentObject(SessionStore())
            AuthView().preferredColorScheme(.dark).environmentObject(SessionStore())
        }
    }
}
