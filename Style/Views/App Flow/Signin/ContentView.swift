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
    
    init() {
        UITableView.appearance().backgroundColor = .clear
        UITableViewCell.appearance().backgroundColor = UIColor.init(red: 255, green: 255, blue: 255, alpha: 0.7)
        
        UINavigationBar.appearance().tintColor = UIColor(named: "darkPink")
        UINavigationBar.appearance().barTintColor = UIColor(named: "darkBlue")
        UINavigationBar.appearance().isTranslucent = false

        let unifiedDictionary: [NSAttributedString.Key: Any] = [NSAttributedString.Key.foregroundColor: UIColor(named: "darkPink") ?? UIColor.white]
        
        UINavigationBar.appearance().titleTextAttributes = unifiedDictionary
        UINavigationBar.appearance().largeTitleTextAttributes = unifiedDictionary

//        UIToolbar.appearance().tintColor = UIColor(named: "darkPink")
//        UIToolbar.appearance().barTintColor = UIColor(named: "darkBlue")
//        UIToolbar.appearance().isTranslucent = false
    }
    
    var body: some View {
        Group {
            if (session.session != nil) {
                ProjectListView(viewModel: ProjectViewModel())
            } else {
                AuthView()
            }
        }.onAppear(perform: { getUser() })
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environmentObject(SessionStore())
    }
}
