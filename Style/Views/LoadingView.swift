//
//  LoadingView.swift
//  Scene Me
//
//  Created by Vince Davis on 2/1/21.
//

import SwiftUI

struct LoadingView: View {
    var text: String
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.2)
            
            ProgressView(text)
                .scaleEffect(3, anchor: .center)
                .progressViewStyle(CircularProgressViewStyle(tint: .white))
        }
    }
}

struct LoadingView_Previews: PreviewProvider {
    static var previews: some View {
        LoadingView(text: "Loading")
    }
}
