//
//  ProjectUpdateView.swift
//  Style
//
//  Created by Vince Davis on 11/23/20.
//

import SwiftUI

struct ProjectUpdateView: View {
    @State private var name: String = ""
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("Enter your project name", text: $name)
                        .modifier(TextFieldStyle())
                }
                
            }
            VStack(spacing: 20) {
                Spacer(minLength: 100)

                
                
                Spacer()
                
//                NavigationLink(
//                    destination: ActorUpdateView(actors: []),
//                    label: {
//                        Text("Next")
//                            .modifier(ButtonStyle())
//                    })
            }
            .padding(12)
            .navigationBarTitle("Update Project")
        }
    }
}

struct ProjectUpdateView_Previews: PreviewProvider {
    static var previews: some View {
        ProjectUpdateView()
    }
}
