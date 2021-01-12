//
//  LoginViewModel.swift
//  Style
//
//  Created by Vince Davis on 11/16/20.
//

import Foundation
import Combine

class LoginViewModel: ObservableObject {
    
    // Properties and Methods
    // ...
    private lazy var appleSignInCoordinator = AppleSignInCoordinator(loginVM: self)
        
    func attemptAppleSignIn() {
        appleSignInCoordinator.startSignInWithAppleFlow()
    }
    
}
