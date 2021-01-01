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
//            Form {
//                ForEach(viewModel.sceneActors) { sceneActor in
//                    Section(header: Text(sceneActor.name)) {
//                        HStack {
//                            Spacer()
//                            KFImage(URL(string: sceneActor.image))
//                                .resizable()
//                                .scaledToFit()
//                                .frame(height: 250)
//                                //.cornerRadius(15)
//                                //.aspectRatio(1, contentMode: .fit)
//                            Spacer()
//                        }
//                        
//                        NavigationLink(destination: Text("")) {
//                            HStack(alignment: .top) {
//                                Text("Top").bold()
//                                Spacer()
//                                Text(sceneActor.top)
//                            }
//                        }
//                        NavigationLink(destination: Text("")) {
//                            HStack(alignment: .top) {
//                                Text("Bottom").bold()
//                                Spacer()
//                                Text(sceneActor.bottom)
//                            }
//                        }
//                        NavigationLink(destination: Text("")) {
//                            HStack(alignment: .top) {
//                                Text("Shoes").bold()
//                                Spacer()
//                                Text(sceneActor.shoes)
//                            }
//                        }
//                        NavigationLink(destination: Text("")) {
//                            HStack(alignment: .top) {
//                                Text("Accessories").bold()
//                                Spacer()
//                                Text(sceneActor.accessories)
//                            }
//                        }
//                        NavigationLink(destination: Text("")) {
//                            HStack(alignment: .top) {
//                                Text("Notes").bold()
//                                Spacer()
//                                Text(sceneActor.notes)
//                            }
//                        }
//                        
//                    }
//                }
//                
//                Section {
//                    HStack {
//                        Button(action: {
//                            activeSheet = .addLook
//                            showSheet.toggle()
//                        }) {
//                            HStack(spacing: 10) {
//                                Image(systemName: "camera.fill")
//                                Text("Add Looks to Actor")
//                            }
//                        }
//                            .modifier(ButtonStyle())
//                            .padding(10)
//                        
//                        Button(action: {
//                            print("Edit button was tapped")
//                        }) {
//                            HStack(spacing: 10) {
//                                Image(systemName: "square.and.arrow.up.fill")
//                                Text("Share")
//                            }
//                        }
//                            .modifier(ButtonStyle())
//                            .padding(10)
//                    }
//                }
//            }
//        
//        
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
