//
//  AddSceneView.swift
//  Style
//
//  Created by Vince Davis on 11/23/20.
//

import SwiftUI
import KingfisherSwiftUI

struct AddSceneView: View {
    @Binding var showAddScene: Bool
    @ObservedObject var viewModel: ProjectViewModel
    
    @State private var name: String = ""
    @State private var number: String = ""
    @State private var sceneImages: [String] = []
    
    //let allActors: [Actor]
    
    //let newScene: (MovieScene) -> Void
    
    @State var actorIDs: [String] = []
    @State var sceneIDs: [String] = []
    
    var body: some View {
        NavigationView {
            ZStack {
                SlantedBackgroundView()
                    .zIndex(1.0)
                
                Form {
                    Section(header: Text("Scene Info")) {
                        TextField("Scene #", text: $number)
                            .modifier(TextFieldStyle())
                            .keyboardType(.numberPad)
                            .frame(width: 100)
                        
                        TextField("Scene Name", text: $name)
                            .modifier(TextFieldStyle())
                    }
                    
                    Section(header: Text("Scene Images"), footer: Text("Tap + button to add scene Images")) {
                        UpdateMultipleImageView(isEditing: true, images: $sceneImages) { imageData in
                            self.viewModel.upload(data: imageData, to: "image/\(UUID().uuidString).jpg") { url in
                                guard let imageUrl = url else { return }
                                
                                self.sceneImages.append(imageUrl.absoluteString)
                            }
                        }
                    }
                    
                    Section(header: Text("Actors In Scene")) {
                        List {
                            ForEach(viewModel.actors) { actor in
                                HStack {
                                    KFImage(URL(string: actor.image))
                                        .resizable()
                                        .frame(width: 44, height: 44)
                                        .clipShape(Circle())
                                        .shadow(radius: 10)
                                        .overlay(Circle().stroke(Color.black, lineWidth: 3))
                                    VStack(alignment: .leading) {
                                        Text(actor.realName)
                                        Text(actor.screenName).font(.subheadline).foregroundColor(.gray)
                                    }
                                    Spacer()
                                    Image(systemName: (self.actorIDs.contains(actor.id ?? "")) ? "checkmark.rectangle" : "rectangle")
                                        .resizable()
                                        .frame(width: 30, height: 30, alignment: .center)

                                }
                                .onTapGesture {
                                    toggle(actor: actor)
                                }
                            }
                        }
                    }
                    
                    Section(header: Text("Scene Continuity")) {
                        List {
                            ForEach(viewModel.scenes) { scene in
                                HStack {
                                    ImageTextRowView(config: scene)
                                    
                                    Spacer()
                                    Image(systemName: (self.sceneIDs.contains(scene.id ?? "")) ? "checkmark.rectangle" : "rectangle")
                                        .resizable()
                                        .frame(width: 30, height: 30, alignment: .center)

                                }
                                .onTapGesture {
                                    toggle(scene: scene)
                                }
                            }
                        }
                    }
                }
                .zIndex(2.0)
            }
            
            .navigationBarTitle(Text("Add Scene"), displayMode: .inline)
            .navigationBarItems(leading: Button(action: {
                self.showAddScene = false
            }) {
                Text("Cancel").bold()
            }, trailing: Button(action: {
                addScene()
            }) {
                Text("Save").bold()
            })
        }
    }
}

extension AddSceneView {
    func addScene() {
        let scene = MovieScene(id: nil, projectId: viewModel.currentProject?.id ?? "", name: name, number: Int(number) ?? 0, actors: actorIDs, images: sceneImages, createdTime: nil)
        viewModel.add(object: scene) { id in
            for sceneId in sceneIDs {
                let continuity = SceneContinuity(id: nil,
                                                 projectId: viewModel.currentProject?.id ?? "",
                                                 scene1: id,
                                                 scene2: sceneId,
                                                 createdTime: nil)
                self.viewModel.add(object: continuity) { _ in }
            }
            
            self.showAddScene = false
        }
    }
    
    func toggle(actor: Actor) {
        if actorIDs.contains(actor.id ?? "") {
            self.actorIDs.removeAll(where: { $0 == actor.id ?? "" })
        }
        else {
            self.actorIDs.append(actor.id ?? "")
        }
    }
    
    func toggle(scene: MovieScene) {
        if sceneIDs.contains(scene.id ?? "") {
            self.sceneIDs.removeAll(where: { $0 == scene.id ?? "" })
        }
        else {
            self.sceneIDs.append(scene.id ?? "")
        }
    }
}

struct AddSceneView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            AddSceneView(showAddScene: .constant(true), viewModel: ProjectViewModel.preview())
        }
    }
}
