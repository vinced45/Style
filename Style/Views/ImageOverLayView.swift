//
//  ImageOverLayView.swift
//  Style
//
//  Created by Vince Davis on 12/31/20.
//

import SwiftUI
import Kingfisher
struct ImageOverLayView: View {
    var sceneActor: SceneActor
    @State var showText: Bool = false
    
    var body: some View {
        
        KFImage(URL(string: sceneActor.images.first ?? ""))
            .resizable()
            .scaledToFit()
            .overlay(Rectangle().fill(Color.black.opacity(showText ? 0.8 : 0.0)))
            .overlay(
                VStack(alignment: .leading) {
                    if showText {
                        Text(sceneActor.name)
                        .foregroundColor(.gray)
                        .font(.title3)
                    }
                }
                .padding()
            , alignment: .topLeading)
            .overlay(
                VStack(alignment: .leading) {
                    if showText {
                        if sceneActor.top.isNotEmpty {
                            Text("👕 " + sceneActor.top)
                                .foregroundColor(.gray)
                                .font(.title3)
                                .padding(.bottom)
                        }
                        
                        if sceneActor.bottom.isNotEmpty {
                            Text("👖 " + sceneActor.bottom)
                                .foregroundColor(.gray)
                                .font(.title3)
                                .padding(.bottom)
                        }
                        
                        if sceneActor.shoes.isNotEmpty {                            Text("👞 " + sceneActor.shoes)
                                .foregroundColor(.gray)
                                .font(.title3)
                                .padding(.bottom)
                        }
                        
                        if sceneActor.top.isNotEmpty {
                            Text("💼 " + sceneActor.accessories)
                                .foregroundColor(.gray)
                                .font(.title3)
                                .padding(.bottom)
                        }
                        
                        if sceneActor.notes.isNotEmpty {
                            Text("📝 " + sceneActor.notes)
                                .foregroundColor(.gray)
                                .font(.title3)
                                .padding(.bottom)
                        }
                        
                    }
                }
                .padding()
            , alignment: .bottomLeading)
            .onTapGesture {
                withAnimation {
                    showText.toggle()
                }
            }
    }
}

struct ImageOverLayView_Previews: PreviewProvider {
    static var previews: some View {
        let sceneActor = SceneActor(id: nil,
                                    sceneActorId: "",
                                    name: "Look for Scene # 1",
                                    top: "Vera Wang",
                                    bottom: "Versace",
                                    shoes: "Prada",
                                    accessories: "Diamond hoops",
                                    notes: "This is a good look for Viola Davis",
                                    beforeLook: false,
                                    images: ["https://static.gofugyourself.com/uploads/2013/10/185512559_10-820x1292.jpg"],
                                    createdTime: nil)
        ImageOverLayView(sceneActor: sceneActor)
    }
}

extension String {
    var isNotEmpty: Bool {
        return !isEmpty
    }
}
