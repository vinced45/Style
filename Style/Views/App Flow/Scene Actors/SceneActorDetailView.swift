//
//  SceneActorDetailView.swift
//  Style
//
//  Created by Vince Davis on 12/7/20.
//

import SwiftUI
import KingfisherSwiftUI

enum SceneActorDetailViewActiveSheet {
    case addLook
    //case share
}

struct SceneActorDetailView: View {
    @ObservedObject var viewModel: ProjectViewModel
    var currentScene: MovieScene
    var currentActor: Actor
    
    @State private var textStyle = UIFont.TextStyle.body
    
    @State var showSheet: Bool = false
    @State private var activeSheet: SceneActorDetailViewActiveSheet = .addLook
    
    let columns = [
        GridItem(.flexible(minimum: 40)),
    ]
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, alignment: .center) {
                ForEach(viewModel.sceneActors) { sceneActor in
                    ImageActorView(actor: currentActor, sceneActor: sceneActor)
                }
            }
        }
            .navigationBarTitle("\(currentScene.name) - \(currentActor.screenName)", displayMode: .inline)
            .navigationBarItems(trailing: Button(action: {
                activeSheet = .addLook
                showSheet.toggle()
            }) {
                Image(systemName: "camera.fill")
            })
            .onAppear {
                viewModel.currentActor = currentActor
                viewModel.currentScene = currentScene
                viewModel.fetchSceneActors(for: "\(currentScene.id ?? "")-\(currentActor.id ?? "")")
            }
            .onReceive(viewModel.didChange) { _ in
                viewModel.fetchSceneActors(for: "\(currentScene.id ?? "")-\(currentActor.id ?? "")")
            }
            .sheet(isPresented: $showSheet, content: {
                switch activeSheet {
                case .addLook: AddSceneActorView(showSheet: $showSheet, viewModel: viewModel)
                //case .share:
                }
                
            })
    }
}

//struct SceneActorDetailView_Previews: PreviewProvider {
//    static var previews: some View {
//        SceneActorDetailView()
//    }
//}

//@State var gridLayout: [GridItem] = [ GridItem(), GridItem() ]
//ScrollView {
//                LazyVGrid(columns: gridLayout, alignment: .center, spacing: 10) {
//                    ForEach(photos.indices) { index in
//                        Image(photos[index])
//                            .resizable()
//                            .scaledToFill()
//                            .frame(minWidth: 0, maxWidth: .infinity)
//                            .frame(height: 200)
//                            .cornerRadius(10)
//                            .shadow(color: Color.primary.opacity(0.3), radius: 1)
//
//                    }
//                }
//                .padding(.all, 10)
//                .animation(.interactiveSpring())
