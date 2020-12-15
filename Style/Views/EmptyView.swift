//
//  EmptyView.swift
//  Style
//
//  Created by Vince Davis on 12/7/20.
//

import SwiftUI

struct EmptyView: View {
    var image: String
    var title: String
    var message: String
    
    var body: some View {
        VStack {
            Image(systemName: image)
                .emptyStyle()
            Text(title)
                .font(.system(size: 20, weight: .bold))
            Text(message)
                .font(.system(size: 14, weight: .regular))
        }
    }
}

struct EmptyView_Previews: PreviewProvider {
    static var previews: some View {
        EmptyView(image: "film", title: "No Scenes", message: "Tap + to add some.")
            .previewLayout(.sizeThatFits)
    }
}
