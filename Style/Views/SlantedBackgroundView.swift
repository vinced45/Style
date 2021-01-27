//
//  SlantedBackgroundView.swift
//  Scene Me
//
//  Created by Vince Davis on 1/27/21.
//

import SwiftUI

struct SlantedBackgroundView: View {
    var body: some View {
        SlantedRectangle()
            .fill(Color("darkGray"))
            .frame(height: 450)
            
    }
}

struct SlantedBackgroundView_Previews: PreviewProvider {
    static var previews: some View {
        SlantedBackgroundView()
    }
}

struct SlantedRectangle: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()

        path.move(to: CGPoint(x: rect.minX, y: rect.midY - 50))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.midY + 50))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))

        return path
    }
}
