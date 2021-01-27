//
//  SceneDetailView.swift
//  Style
//
//  Created by Vince Davis on 12/7/20.
//

import SwiftUI
import KingfisherSwiftUI

struct SceneDetailView: View {
    @ObservedObject var viewModel: ProjectViewModel
    @State var currentScene: MovieScene
    
    @State var sceneTime: String = "Day"
    @State var sceneType: String = "Internal"
    
    @State var sceneActors: [Actor] = []
    @State var sceneImages: [String] = []
    @State var showAddActor: Bool = false
    
    enum SheetType {
        case updateActors
    }
    
    @ObservedObject var sheet = SheetState<SceneDetailView.SheetType>()
    
    let imageColumns = [
        GridItem(.flexible(minimum: 40)),
        GridItem(.flexible(minimum: 40)),
        GridItem(.flexible(minimum: 40)),
    ]
    
    var body: some View {
        Form {
            Section(header: Text("Scene Images"), footer: Text("Tap + button to add scene Images")) {
                UpdateMultipleImageView(isEditing: true, images: $sceneImages) { imageData in
                    self.viewModel.upload(data: imageData, to: "image/\(UUID().uuidString).jpg") { url in
                        guard let imageUrl = url else { return }
                        
                        self.sceneImages.append(imageUrl.absoluteString)
                        viewModel.update(object: currentScene, with: ["images": sceneImages])
                    }
                }
                
                NavigationLink(destination: SceneImageListView(images: sceneImages, index: 4)) {
                    Text("List Images")
                }
            }
            
            Section(header: Text("Actors")) {
                ForEach(sceneActors) { actor in
                    NavigationLink(destination: SceneActorDetailView(viewModel: viewModel, currentScene: currentScene, currentActor: actor)) {
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
                        }
                        .frame(height: 60)
                    }
                }
                .onDelete(perform: deleteActor)
                
                Button("Add Actor") {
                    sheet.state = .updateActors
                }
            }
            Section(header: Text("Scene Details")) {
                HStack {
                    Text("Time of Day")
                    Spacer(minLength: 100)
                    Picker("", selection: $sceneTime) {
                                        Text("Day").tag(0)
                                        Text("Night").tag(1)
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }
                
                HStack {
                    Text("Type")
                    Spacer(minLength: 100)
                    Picker("", selection: $sceneType) {
                                        Text("Internal").tag(0)
                                        Text("External").tag(1)
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }
            }
        }
        .navigationTitle("\(currentScene.number) - \(currentScene.name)")
        .onAppear {
            sceneActors = viewModel.getActors(for: currentScene)
            sceneImages = currentScene.images
        }
        .sheet(isPresented: $sheet.isShowing,
               onDismiss: {
            sceneActors = viewModel.getActors(for: currentScene)
               }, content: {
            UpdateSceneActorListView(showAddScene: $sheet.isShowing,
                                     movieScene: $currentScene,
                                     viewModel: viewModel)
        })
    }
}

extension SceneDetailView {
    private func deleteActor(offsets: IndexSet) {
        sceneActors.remove(atOffsets: offsets)
        self.currentScene.actors.remove(atOffsets: offsets)
        viewModel.update(object: currentScene, with: ["actors": currentScene.actors])
    }
}

struct SceneDetailView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            SceneDetailView(viewModel: ProjectViewModel.preview(), currentScene: MovieScene.preview())
        }
    }
}
