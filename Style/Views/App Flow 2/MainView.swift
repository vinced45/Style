//
//  MainView.swift
//  Scene Me
//
//  Created by Vince Davis on 5/17/21.
//

import SwiftUI

struct MainView: View {
    
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    @State var selection: Int = 0
    
    @State var galleryView: GalleryView = GalleryView()
    
    var body: some View {
        if horizontalSizeClass == .compact {
            TabBarView(tabSelection: $selection, galleryView: $galleryView)
        } else {
            NavigationView {
                SideBarView(selection: $selection, galleryView: $galleryView)
                
                galleryView
            }
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
