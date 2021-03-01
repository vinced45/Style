//
//  ActorProfileView.swift
//  Style
//
//  Created by Vince Davis on 1/11/21.
//

import SwiftUI
import KingfisherSwiftUI

struct ActorProfileView: View {
    var actor: Actor
    
    let sizeChartTapped: () -> Void?
    
    var body: some View {
        HStack {
            KFImage(URL(string: actor.image))
                .resizable()
                .frame(width: 88, height: 88)
                .clipShape(Circle())
                .shadow(radius: 10)
                .overlay(Circle().stroke(Color.black, lineWidth: 3))
            
            VStack {
                VStack(alignment: .leading) {
                    Text(actor.screenName)
                    Text(actor.realName).font(.subheadline).foregroundColor(.gray)
                    //Text("Show ").font(.subheadline).foregroundColor(.gray)
                    Button("Show Charts >", action: { sizeChartTapped() })
                }
            }
            
            Spacer()
        }
    }
}

struct ActorProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ActorProfileView(actor: Actor.preview()) {}
            .padding(.all)
            .previewLayout(.sizeThatFits)
    }
}
