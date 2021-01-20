//
//  SceneImageListView.swift
//  Style
//
//  Created by Vince Davis on 1/20/21.
//

import SwiftUI

struct SceneImageListView: View {
    var images: [String]
    
    let oneColumn = [
        GridItem(.flexible(minimum: 40)),
    ]
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: oneColumn, alignment: .center) {
                ForEach(images, id: \.self) { image in
                    ImageUploadView(image: image)
                }
            }
        }
        .navigationTitle("Scene Images")
        
    }
}

//struct SceneImageListView_Previews: PreviewProvider {
//    static var previews: some View {
//        SceneImageListView()
//    }
//}
