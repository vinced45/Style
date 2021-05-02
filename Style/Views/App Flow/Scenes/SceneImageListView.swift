//
//  SceneImageListView.swift
//  Style
//
//  Created by Vince Davis on 1/20/21.
//

import SwiftUI

struct SceneImageListView: View {
    var images: [String]
    @State var index: Int = 0
    
    let oneColumn = [
        GridItem(.flexible(minimum: 40)),
    ]
    
    var body: some View {
        ZStack {
            SlantedBackgroundView()
                .zIndex(1.0)
            
            ScrollViewReader { scrollProxy in
                ScrollView {
                    LazyVGrid(columns: oneColumn, alignment: .center) {
                        ForEach(images, id: \.self) { image in
                            ImageUploadView(image: image)
                        }
                    }
                }
                .onChange(of: self.index) { _ in
                    withAnimation {
                        scrollProxy.scrollTo(index)
                    }
                }
            }
            .zIndex(2.0)
        }
        .onAppear {
            //DispatchQueue.main.asy
            print(images.count)
        }
        .navigationTitle("Images")
        
    }
}

//struct SceneImageListView_Previews: PreviewProvider {
//    static var previews: some View {
//        SceneImageListView()
//    }
//}

struct SceneImageListView2: View {
    @Binding var images: [String]
    
    let oneColumn = [
        GridItem(.flexible(minimum: 40)),
    ]
    
    var body: some View {
        ZStack {
            SlantedBackgroundView()
                .zIndex(1.0)
            
            ScrollView {
                LazyVGrid(columns: oneColumn, alignment: .center) {
                    ForEach(images, id: \.self) { image in
                        ImageUploadView(image: image)
                    }
                }
            }
            .zIndex(2.0)
        }
        .navigationTitle("Images")
        
    }
}
