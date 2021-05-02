//
//  StackedImageView.swift
//  Style
//
//  Created by Vince Davis on 1/20/21.
//

import SwiftUI
import Kingfisher

struct StackedImageView: View {
    
    var images: [String]
    @State var mainImage: String = ""
    @State var backImage: String = ""
    
    let offset: CGFloat = 10.0
    
    var body: some View {
        ZStack(alignment: .center) {
            GeometryReader { geo in
                let width = geo.size.width
                let height = geo.size.height
                
                let imageOffset: CGFloat = images.count > 1 ? offset : 0
                
                KFImage(URL(string: mainImage))
                    .resizable()
                    .aspectRatio(1, contentMode: .fit)
                    .border(Color.black, width: 2)
                    .frame(width: width - imageOffset, height: height - imageOffset)
                    .offset(x: 0, y: imageOffset)
                    .zIndex(2)
                
                if images.count > 1 {
                    Text("+\(images.count)")
                        .font(.title)
                        .zIndex(3)
                        .frame(width: width - imageOffset, height: height - imageOffset)
                        .foregroundColor(Color.white)
                        .background(Color.black.opacity(0.4))
                        .offset(x: 0, y: imageOffset)
                        
                    KFImage(URL(string: backImage))
                        .resizable()
                        .aspectRatio(1, contentMode: .fit)
                        .border(Color.black, width: 2)
                        .frame(width: width - imageOffset, height: height - imageOffset)
                        .zIndex(1)
                        .offset(x: imageOffset, y: 0.0)
                }
            }
        }
        .onAppear {
            if let imageurl = images.first {
                mainImage = imageurl
            }
            
            if let imageUrl = images.last, images.count > 1 {
                backImage = imageUrl
            }
        }
    }
}

struct StackedImageView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            StackedImageView(images: ["https://www.logocentral.info/wp-content/uploads/2020/04/Tesla-Logo-640X590.jpg", "https://storage.googleapis.com/webdesignledger.pub.network/WDL/12f213e1-t1.jpg", "https://storage.googleapis.com/webdesignledger.pub.network/WDL/12f213e1-t1.jpg"])
                .previewLayout(.sizeThatFits)
                .frame(width: 80, height: 80)
            StackedImageView(images: ["https://www.logocentral.info/wp-content/uploads/2020/04/Tesla-Logo-640X590.jpg"])
                .previewLayout(.sizeThatFits)
                .frame(width: 80, height: 80)
        }
    }
}
