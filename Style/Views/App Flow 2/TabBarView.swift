//
//  TabBarView.swift
//  Scene Me
//
//  Created by Vince Davis on 5/14/21.
//

import SwiftUI

struct TabBarView: View {
    @Binding var tabSelection: Int
    
    @Binding var galleryView: GalleryView
    
    var body: some View {
        TabView(selection: $tabSelection) {
            NavigationView {
                galleryView
            }
            .navigationViewStyle(StackNavigationViewStyle())
            .onTapGesture {
                tabSelection = 0
            }
            .tabItem {
                Label("Gallery", systemImage: "photo.on.rectangle.angled")
            }
            .tag(0)
                
            ActorView()
                .onTapGesture {
                    tabSelection = 1
                }
                .tabItem {
                    Label("Actors", systemImage: "person.circle")
                }
                .tag(1)
            
            SceneView()
                .onTapGesture {
                    tabSelection = 2
                }
                .tabItem {
                    Label("Scenes", systemImage: "film")
                }
                .tag(2)
            
            NoteListView()
                .onTapGesture {
                    tabSelection = 3
                }
                .tabItem {
                    Label("Notes", systemImage: "note.text")
                }
                .tag(3)
        }
        
    }
}

struct TabBarView_Previews: PreviewProvider {
    static var previews: some View {
        TabBarView(tabSelection: .constant(0), galleryView: .constant(GalleryView()))
    }
}
