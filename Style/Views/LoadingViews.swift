//
//  LoadingViews.swift
//  Style
//
//  Created by Vince Davis on 1/11/21.
//

import SwiftUI

struct LoadingCircleView: View {
 
    @State private var isLoading = false
 
    var body: some View {
        ZStack {
 
            Circle()
                .stroke(Color(.systemGray5), lineWidth: 14)
                .frame(width: 80, height: 80)
 
            Circle()
                .trim(from: 0, to: 0.2)
                .stroke(Color("bg1"), lineWidth: 7)
                .frame(width: 80, height: 80)
                .rotationEffect(Angle(degrees: isLoading ? 360 : 0))
                .animation(Animation.linear(duration: 1).repeatForever(autoreverses: false))
                .onAppear() {
                    self.isLoading = true
            }
        }
    }
}

struct LoadingCircleView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            LoadingCircleView()
                .padding(.all)
                .previewLayout(.sizeThatFits)
        }
    }
}

struct LoadingLineView: View {
 
    @State private var isLoading = false
 
    var body: some View {
        ZStack {
 
            Text("Loading")
                .font(.system(.body, design: .rounded))
                .bold()
                .offset(x: 0, y: -25)
 
            RoundedRectangle(cornerRadius: 3)
                .stroke(Color(.systemGray5), lineWidth: 3)
                .frame(width: 250, height: 3)
 
            RoundedRectangle(cornerRadius: 3)
                .stroke(Color("bg1"), lineWidth: 3)
                .frame(width: 30, height: 3)
                .offset(x: isLoading ? 110 : -110, y: 0)
                .animation(Animation.linear(duration: 1).repeatForever(autoreverses: false))
        }
        .onAppear() {
            self.isLoading = true
        }
    }
}

struct LoadingLineView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            LoadingLineView()
                .padding(.all)
                .previewLayout(.sizeThatFits)
        }
    }
}
