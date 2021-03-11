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
    
    let sizeChartTapped: () -> Void
    
    let deptTapped: (Int) -> Void
    
    @State var deptId: Int = 0
    
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
                        .bold()
                    Text(actor.realName)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                    //Text("Show ").font(.subheadline).foregroundColor(.gray)
                    Button("Show Charts >", action: { sizeChartTapped() })
                    Menu {
                        Button(action: {
                            deptTapped(0)
                            deptId = 0
                        }) {
                            HStack {
                                Text("All")
                                
                                Spacer()
                                
                                if deptId == 0 {
                                    Image(systemName: "checkmark")
                                }
                            }
                        }
                        
                        Button(action: {
                            deptTapped(1)
                            deptId = 1
                        }) {
                            HStack {
                                Text("Wardrobe")
                                
                                Spacer()
                                
                                if deptId == 1 {
                                    Image(systemName: "checkmark")
                                }
                            }
                        }
                        
                        Button(action: {
                            deptTapped(2)
                            deptId = 2
                        }) {
                            HStack {
                                Text("Hair")
                                
                                Spacer()
                                
                                if deptId == 2 {
                                    Image(systemName: "checkmark")
                                }
                            }
                        }
                        
                        Button(action: {
                            deptTapped(3)
                            deptId = 3
                        }) {
                            HStack {
                                Text("Make Up")
                                
                                Spacer()
                                
                                if deptId == 3 {
                                    Image(systemName: "checkmark")
                                }
                            }
                        }
                        
                        Button(action: {
                            deptTapped(4)
                            deptId = 4
                        }) {
                            HStack {
                                Text("Props")
                                
                                Spacer()
                                
                                if deptId == 4 {
                                    Image(systemName: "checkmark")
                                }
                            }
                        }
                    } label: {
                        Label("Filter", systemImage: "slider.horizontal.3")
                    }
                }
            }
            
            Spacer()
        }
    }
}

struct ActorProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ActorProfileView(actor: Actor.preview()) {
            
        } deptTapped: { deptId in
            
        }
            .padding(.all)
            .previewLayout(.sizeThatFits)
    }
}
