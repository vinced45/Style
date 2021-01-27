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
        .onAppear {
            //DispatchQueue.main.asy
            index = 5
        }
        .navigationTitle("Scene Images")
        
    }
}

//struct SceneImageListView_Previews: PreviewProvider {
//    static var previews: some View {
//        SceneImageListView()
//    }
//}
