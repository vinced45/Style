//
//  ContentView.swift
//  Style
//
//  Created by Vince Davis on 11/14/20.
//

import SwiftUI

struct ContentView: View {
   
    @EnvironmentObject var session: SessionStore
    
    func getUser() {
        session.listen()
    }
    
    var body: some View {
        Group {
            if (session.session != nil) {
                Text("Welcome back user")
                Button(action: session.signOut) {
                    Text("Sign Out")
                }
            } else {
                AuthView()
            }
        }.onAppear(perform: { getUser() })
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
