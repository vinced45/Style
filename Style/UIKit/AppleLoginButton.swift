//
//  AppleLoginButton.swift
//  Style
//
//  Created by Vince Davis on 11/16/20.
//

import UIKit
import SwiftUI
import AuthenticationServices
import CryptoKit
import Firebase

struct AppleSignInButton: UIViewRepresentable {
    func makeUIView(context: Context) -> ASAuthorizationAppleIDButton {
        return ASAuthorizationAppleIDButton(
                authorizationButtonType: .signUp,
                authorizationButtonStyle: .white)
    }
 
    func updateUIView(_ uiView: ASAuthorizationAppleIDButton, context: Context) {}
}

class AppleSignInCoordinator: NSObject, ASAuthorizationControllerDelegate {
    // Backend Service Variable
    //var loginService: LoginService
    var loginViewModel: LoginViewModel
    
    // Unhashed nonce.
    fileprivate var currentNonce: String?
    
    init(/*loginService: LoginService = LoginAPI(),*/ loginVM: LoginViewModel) {
        self.loginViewModel = loginVM
        //self.loginService = loginService
    }
    
    // Shows Sign in with Apple UI
    func handleAuthorizationAppleIDButtonPress() {
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.performRequests()
    }
    
    // Delegate methods
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        switch authorization.credential {
        case let appleIDCredential as ASAuthorizationAppleIDCredential:
            
            // Get user details
            let userIdentifier = appleIDCredential.user
            let fullName = appleIDCredential.fullName
            let email = appleIDCredential.email ?? ""
            let name = (fullName?.givenName ?? "") + (" ") + (fullName?.familyName ?? "")
            
            // Save user details or fetch them
            // Sign in with Apple only gives full name and email once
            // Below is a sample code of how it can be done
            //KeychainManager.saveOrRetrieve(name, email)
            
            // Example: Make network request to backend
            // OR, perform any other operation as per your app's use case
            //loginService.callAppleAuthCallback()
        
            guard let nonce = currentNonce else {
                    fatalError("Invalid state: A login callback was received, but no login request was sent.")
            }
            
            guard let appleIDToken = appleIDCredential.identityToken else {
                    print("Unable to fetch identity token")
                    return
            }
            
            guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
                    print("Unable to serialize token string from data: \(appleIDToken.debugDescription)")
                    return
            }
                  // Initialize a Firebase credential.
            let credential = OAuthProvider.credential(withProviderID: "apple.com",
                                                      idToken: idTokenString,
                                                            rawNonce: nonce)
                  // Sign in with Firebase.
            Auth.auth().signIn(with: credential) { (authResult, error) in
//                if let error = error {
//                      // Error. If error.code == .MissingOrInvalidNonce, make sure
//                      // you're sending the SHA256-hashed nonce as a hex string with
//                      // your request to Apple.
//                      print(error.localizedDescription)
//                      return
//                }
                    // User is signed in to Firebase with Apple.
                    // ...
            }
            
        default:
            break
        }
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        print(error.localizedDescription)
    }
    
    // Adapted from https://auth0.com/docs/api-auth/tutorials/nonce#generate-a-cryptographically-random-nonce
    private func randomNonceString(length: Int = 32) -> String {
      precondition(length > 0)
      let charset: Array<Character> =
          Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
      var result = ""
      var remainingLength = length

      while remainingLength > 0 {
        let randoms: [UInt8] = (0 ..< 16).map { _ in
          var random: UInt8 = 0
          let errorCode = SecRandomCopyBytes(kSecRandomDefault, 1, &random)
          if errorCode != errSecSuccess {
            fatalError("Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)")
          }
          return random
        }

        randoms.forEach { random in
          if remainingLength == 0 {
            return
          }

          if random < charset.count {
            result.append(charset[Int(random)])
            remainingLength -= 1
          }
        }
      }

      return result
    }
    
    func startSignInWithAppleFlow() {
        let nonce = randomNonceString()
        currentNonce = nonce
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        request.nonce = sha256(nonce)

        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        //authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }

    private func sha256(_ input: String) -> String {
        let inputData = Data(input.utf8)
        let hashedData = SHA256.hash(data: inputData)
        let hashString = hashedData.compactMap {
            return String(format: "%02x", $0)
        }.joined()

        return hashString
    }
}
