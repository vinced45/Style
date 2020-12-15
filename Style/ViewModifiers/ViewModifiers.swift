//
//  ViewModifiers.swift
//  Style
//
//  Created by Vince Davis on 11/23/20.
//

import SwiftUI

struct ButtonStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .frame(minWidth: 0, maxWidth: .infinity)
            .frame(height: 50)
            .foregroundColor(.white)
            .font(.system(size: 14, weight: .bold))
            .background(LinearGradient(gradient: Gradient(colors: [Color("bg1"), Color("bg2")]), startPoint: .leading, endPoint: .trailing))
            .cornerRadius(5)
    }
}

struct ButtonStyle_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            Button("Add Actor") {}
                .previewLayout(.fixed(width: 300, height: /*@START_MENU_TOKEN@*/100.0/*@END_MENU_TOKEN@*/))
                .modifier(ButtonStyle())
            Button("Add Actor") {}
                .preferredColorScheme(.dark)
                .previewLayout(.fixed(width: 300, height: /*@START_MENU_TOKEN@*/100.0/*@END_MENU_TOKEN@*/))
                .modifier(ButtonStyle())
        }
            
    }
}

struct TextFieldStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.system(size: 14))
            .padding(12)
            .background(RoundedRectangle(cornerRadius: 5).strokeBorder(Color("bg1"), lineWidth: 1))
    }
}

struct ProfileImageStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .frame(width: 100, height: 100, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
            .clipShape(Circle())
            .shadow(radius: 10)
            .overlay(Circle().stroke(Color.black, lineWidth: 3))
    }
}

extension Image {
    func emptyStyle() -> some View {
        self
            .resizable()
            .frame(width: 100, height: 100, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
            .colorMultiply(.red)
    }
}
