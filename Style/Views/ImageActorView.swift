//
//  ImageActorView.swift
//  Style
//
//  Created by Vince Davis on 12/31/20.
//

import SwiftUI
import KingfisherSwiftUI

struct ImageActorView: View {
    var actor: Actor
    var sceneActor: SceneActor
    
    var viewFont: Font = .caption
    
    @GestureState var scale: CGFloat = 1.0
    
    init(actor: Actor, sceneActor: SceneActor) {
        self.actor = actor
        self.sceneActor = sceneActor
        
        UIPageControl.appearance().currentPageIndicatorTintColor = #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1)
        UIPageControl.appearance().pageIndicatorTintColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        }
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                KFImage(URL(string: actor.image))
                    .resizable()
                    .frame(width: 44, height: 44)
                    .clipShape(Circle())
                    .shadow(radius: 10)
                    .overlay(Circle().stroke(Color.black, lineWidth: 3))
                
                VStack(alignment: .leading) {
                    Text(actor.realName).font(.headline).bold()
                    Text(actor.screenName).font(.footnote)
                }
                
                Spacer()
                
                Image(systemName: "ellipsis")
            }
            .frame(height: 60)
            .padding([.leading, .trailing])
            
            TabView {
                ForEach(sceneActor.images, id: \.self) { image in
                    KFImage(URL(string: image))
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: 500)
                        .frame(height: 400)
                        .gesture(MagnificationGesture()
                            .updating($scale, body: { (value, scale, trans) in
                                scale = value.magnitude
                            })
                        )
                        //.background(Color.gray)
                }
            }
            .tabViewStyle(PageTabViewStyle())
            
            Text(createText())
                .padding([.leading, .trailing])
            
            Text(getRelativeDate(for: sceneActor.createdTime?.dateValue() ?? Date()))
                .font(.footnote)
                .foregroundColor(.gray)
                .padding([.leading, .trailing])
        }
        .frame(maxWidth: 500)
        .padding(.bottom)
    }
}

extension ImageActorView {
    func createText() -> String {
        var text = ""
        
        if sceneActor.top.isNotEmpty {
            text += "👕 " + sceneActor.top + " "
        }

        if sceneActor.bottom.isNotEmpty {
            text += "👖 " + sceneActor.bottom + " "
        }

        if sceneActor.shoes.isNotEmpty {
            text += "👞 " + sceneActor.shoes + " "
        }

        if sceneActor.top.isNotEmpty {
            text += "💼 " + sceneActor.accessories + " "
        }

        if sceneActor.notes.isNotEmpty {
            text += "📝 " + sceneActor.notes + " "
        }
        
        return text
    }
    
    func getRelativeDate(for date: Date) -> String {
        // ask for the full relative date
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .full

        // get exampleDate relative to the current date
        let relativeDate = formatter.localizedString(for: date, relativeTo: Date())

        return relativeDate
    }
    
//    func getMaxHeight(for image: [Image]) -> Float {
//
//    }
}

struct ImageActorView_Previews: PreviewProvider {
    static var previews: some View {
        let actor = Actor(id: nil,
                          projectId: "",
                          realName: "Viola Davis",
                          screenName: "Maxine Waters",
                          image: "https://images.news.iu.edu/dams/vkhhgsmtri_actual.jpg",
                          clothesSize: 0,
                          images: [],
                          createdTime: nil)
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
        ImageActorView(actor: actor, sceneActor: sceneActor)
    }
}

struct ImageUploadView: View {
    //var actor: Actor
    //var sceneActor: SceneActor
    var image: String
    
    var viewFont: Font = .caption
    
    @GestureState var scale: CGFloat = 1.0
    
    var body: some View {
        VStack(alignment: .center) {
//            HStack {
//                KFImage(URL(string: actor.image))
//                    .resizable()
//                    .frame(width: 44, height: 44)
//                    .clipShape(Circle())
//                    .shadow(radius: 10)
//                    .overlay(Circle().stroke(Color.black, lineWidth: 3))
//
//                VStack(alignment: .leading) {
//                    Text(actor.realName).font(.headline).bold()
//                    Text(actor.screenName).font(.footnote)
//                }
//
//                Spacer()
//
//                Image(systemName: "ellipsis")
//            }
//            .frame(height: 60)
//            .padding()
            
            KFImage(URL(string: image))
                .resizable()
                .scaledToFit()
                .frame(maxWidth: 500)
                .gesture(MagnificationGesture()
                    .updating($scale, body: { (value, scale, trans) in
                        scale = value.magnitude
                    })
                )
                
//            Text(createText())
//                .padding(.leading)
//                .padding(.bottom)
//
//            Text(getRelativeDate(for: sceneActor.createdTime?.dateValue() ?? Date()))
//                .font(.footnote)
//                .foregroundColor(.gray)
//                .padding(.leading)
//                .padding(.bottom)
                
        }
        .frame(maxWidth: 500)
    }
}

extension ImageUploadView {
    func createText() -> String {
//        var text = ""
//        
//        if sceneActor.top.isNotEmpty {
//            text += "👕 " + sceneActor.top + " "
//        }
//
//        if sceneActor.bottom.isNotEmpty {
//            text += "👖 " + sceneActor.bottom + " "
//        }
//
//        if sceneActor.shoes.isNotEmpty {
//            text += "👞 " + sceneActor.shoes + " "
//        }
//
//        if sceneActor.top.isNotEmpty {
//            text += "💼 " + sceneActor.accessories + " "
//        }
//
//        if sceneActor.notes.isNotEmpty {
//            text += "📝 " + sceneActor.notes + " "
//        }
//        
//        return text
        return ""
    }
    
    func getRelativeDate(for date: Date) -> String {
        // ask for the full relative date
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .full

        // get exampleDate relative to the current date
        let relativeDate = formatter.localizedString(for: date, relativeTo: Date())

        return relativeDate
    }
}

//struct ImageUploadView_Previews: PreviewProvider {
//    static var previews: some View {
//        let actor = Actor(id: nil,
//                          projectId: "",
//                          realName: "Viola Davis",
//                          screenName: "Maxine Waters",
//                          image: "https://images.news.iu.edu/dams/vkhhgsmtri_actual.jpg",
//                          clothesSize: 0,
//                          images: [],
//                          createdTime: nil)
//        let sceneActor = SceneActor(id: nil,
//                                    sceneActorId: "",
//                                    name: "Look for Scene # 1",
//                                    top: "Vera Wang",
//                                    bottom: "Versace",
//                                    shoes: "Prada",
//                                    accessories: "Diamond hoops",
//                                    notes: "This is a good look for Viola Davis",
//                                    beforeLook: false,
//                                    image: "https://static.gofugyourself.com/uploads/2013/10/185512559_10-820x1292.jpg",
//                                    createdTime: nil)
//        ImageActorView(actor: actor, sceneActor: sceneActor)
//    }
//}
