//
//  SideBarView.swift
//  Scene Me
//
//  Created by Vince Davis on 5/17/21.
//

import SwiftUI

struct SideBarView: View {
    @Binding var selection: Int
    
    @Binding var galleryView: GalleryView
    
    @State var isGalleryActive = true
    @State var isActorsActive = false
    @State var isScenesActive = false
    @State var isNotesActive = false
    
    var body: some View {
        List {
            NavigationLink(
                destination: galleryView.onAppear { selection = 0 },
                isActive: $isGalleryActive,
                label: {
                    Label("Gallery", systemImage: "photo.on.rectangle.angled")
                })
            
            NavigationLink(
                destination: ActorView().onAppear { selection = 1 },
                isActive: $isActorsActive,
                label: {
                    Label("Actors", systemImage: "person.circle")
                })
            
            NavigationLink(
                destination: SceneView().onAppear { selection = 2 },
                isActive: $isScenesActive,
                label: {
                    Label("Scenes", systemImage: "film")
                })
            
            NavigationLink(
                destination: NoteListView().onAppear { selection = 3 },
                isActive: $isNotesActive,
                label: {
                    Label("Notes", systemImage: "note.text")
                })
        }
        .listStyle(SidebarListStyle())
        .onChange(of: selection, perform: { value in
            switch value {
            case 0:
                isGalleryActive = true
                isActorsActive = false
                isScenesActive = false
                isNotesActive = false
            case 1:
                isGalleryActive = false
                isActorsActive = true
                isScenesActive = false
                isNotesActive = false
            case 2:
                isGalleryActive = false
                isActorsActive = false
                isScenesActive = true
                isNotesActive = false
            default:
                isGalleryActive = false
                isActorsActive = false
                isScenesActive = false
                isNotesActive = true
            }
        })
        .navigationTitle(Text("Scene Me"))
    }
}

struct SideBarView_Previews: PreviewProvider {
    static var previews: some View {
        SideBarView(selection: .constant(1), galleryView: .constant(GalleryView()))
    }
}
