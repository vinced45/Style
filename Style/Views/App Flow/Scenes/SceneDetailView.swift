//
//  SceneDetailView.swift
//  Style
//
//  Created by Vince Davis on 12/7/20.
//

import SwiftUI
import Kingfisher
import AlertToast

struct SceneDetailView: View {
    @ObservedObject var viewModel: ProjectViewModel
    @State var currentScene: MovieScene
    
    @Environment(\.presentationMode) var presentationMode
    
    @State var sceneTime: String = "Day"
    @State var sceneType: String = "Internal"
    
    @State var sceneActors: [Actor] = []
    @State var sceneContinuities: [MovieScene] = []
    @State var sceneImages: [String] = []
    @State var showAddActor: Bool = false
    
    @State var isImagesExpanded = true
    @State var isActorsExpanded = true
    @State var isContinuityExpanded = true
    @State var isDetailsExpanded = true
    
    @State var showToast: Bool = false
    
    @State var showAction: Bool = false
    
    @State var showAlert: Bool = false
    
    @State private var currentImage: String = ""
    
    enum SheetType {
        case updateActors
        case editScene
    }
    
    @ObservedObject var sheet = SheetState<SceneDetailView.SheetType>()
    
    let imageColumns = [
        GridItem(.flexible(minimum: 40)),
        GridItem(.flexible(minimum: 40)),
        GridItem(.flexible(minimum: 40)),
    ]
    
//    init(viewModel: ProjectViewModel, currentScene: MovieScene) {
//        self.viewModel = viewModel
//        self.currentScene = currentScene
//
//        sceneImages = currentScene.images
//    }
    
    var body: some View {
        ZStack {
            SlantedBackgroundView()
                .zIndex(1.0)
            
            List {
                Section {
                    DisclosureGroup(isExpanded: $isImagesExpanded) {
                        UpdateMultipleImageView(isEditing: true, images: $sceneImages, imageTapped: { imageUrl in
                            currentImage = imageUrl
                            showAction = true
                        }, imageData: { imageData in
                            showToast = true
                            self.viewModel.upload(data: imageData, to: "image/\(UUID().uuidString).jpg") { url in
                                guard let imageUrl = url else { return }
                                
                                self.sceneImages.append(imageUrl.absoluteString)
                                currentScene.images.append(imageUrl.absoluteString)
                                showToast = false
                                viewModel.update(object: currentScene, with: ["images": sceneImages])
                            }
                        })
                        .toast(isPresenting: $showToast) {
                            //AlertToast(type: .regular, title: "Uploading Image")
                            AlertToast(type: .loading, title: "Please Wait", subTitle: "Uploading Images")
                            //Choose .hud to toast alert from the top of the screen
                            //AlertToast(displayMode: .hud, type: .regular, title: "Uploading Image")
                        }
                    } label: {
                        Text("Scene Images")
                            .font(.headline)
                            .onTapGesture {
                                isImagesExpanded.toggle()
                            }
                    }
                    
                    NavigationLink(destination: SceneImageListView2(images: sceneImages)) {
                        Text("List Images")
                    }
                }
                
                Section {
                    DisclosureGroup(isExpanded: $isActorsExpanded) {
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
                    } label: {
                        Text("Actors (\(sceneActors.count))")
                            .font(.headline)
                    }
                    
                    Button("Add Actor") {
                        sheet.state = .updateActors
                    }
                }
                
                Section {
                    DisclosureGroup(isExpanded: $isContinuityExpanded) {
                        ForEach(sceneContinuities) { scene in
                            NavigationLink(destination: SceneDetailView(viewModel: viewModel, currentScene: scene)) {
                                
                                ImageTextRowView(config: scene)
                                    .frame(height: 60)
                            }
                        }
                    } label: {
                        Text("Scene Continuity (\(sceneContinuities.count))")
                            .font(.headline)
                    }
                    
//                    Button("Add Actor") {
//                        sheet.state = .updateActors
//                    }
                }
                /*
                Section {
                    DisclosureGroup(isExpanded: $isDetailsExpanded) {
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
                    } label: {
                        Text("Scene Details")
                            .font(.headline)
                    }
                }
                 */
            }
            .listStyle(InsetGroupedListStyle())
            .zIndex(2.0)
            .padding(.top, 50)
        }
        .navigationTitle("\(currentScene.number) - \(currentScene.name)")
        .navigationBarItems(trailing: menuView())
        .actionSheet(isPresented: $showAction, content: {
            ActionSheet(title: Text("Delete Photo"), message: nil, buttons: [.cancel(), .destructive(Text("Delete"), action: { deleteImage() })])
        })
        .alert(isPresented: $showAlert) { () -> Alert in
            let primaryButton = Alert.Button.destructive(Text("Delete")) {
                deleteScene()
            }
            let secondaryButton = Alert.Button.cancel(Text("Cancel")) {
                print("secondary button pressed")
            }
            return Alert(title: Text("Delete Scene?"), message: Text("Are you sure you want to delete this scene?"), primaryButton: primaryButton, secondaryButton: secondaryButton)
        }
        .onAppear {
            sceneActors = viewModel.getActors(for: currentScene)
            sceneImages = currentScene.images
            sceneContinuities = getScenes(for: currentScene.id ?? "")
        }
        .sheet(isPresented: $sheet.isShowing,
               onDismiss: {
            sceneActors = viewModel.getActors(for: currentScene)
               }, content: {
                sheetContent()
        })
    }
}

extension SceneDetailView {
    func deleteScene() {
        for sceneContinuity in viewModel.sceneContinuities where (sceneContinuity.scene1 == currentScene.id!) || (sceneContinuity.scene2 == currentScene.id!) {
            viewModel.delete(object: sceneContinuity, completion: { _ in })
        }
        
        viewModel.delete(object: currentScene, completion: { _ in
            presentationMode.wrappedValue.dismiss()
        })
    }

    func deleteImage() {
        if let index = sceneImages.firstIndex(of: currentImage) {
            sceneImages.remove(at: index)
            viewModel.update(object: currentScene, with: ["images": sceneImages])
        }
        
        showAction = false
    }
    
    @ViewBuilder
    private func menuView() -> some View {
        Menu {
            Button(action: {
                sheet.state = .editScene
            }) {
                Label("Edit Scene", systemImage: "film")
            }
            
            Button(action: {
                showAlert.toggle()
            }) {
                Label("Delete Scene", systemImage: "trash")
                    .foregroundColor(.red)
            }
        } label: {
            Image(systemName: "ellipsis")
                .font(.title)
        }
    }
    
    @ViewBuilder
    private func sheetContent() -> some View {
        switch self.sheet.state {
        case .updateActors:
            UpdateSceneActorListView(showAddScene: $sheet.isShowing,
                                     movieScene: $currentScene,
                                     viewModel: viewModel)
        case .editScene:
            EditSceneView(showAddScene: $sheet.isShowing,
                          viewModel: viewModel,
                          currentScene: currentScene)
        case .none:
            EmptyView()
        }
    }
    
    private func deleteActor(offsets: IndexSet) {
        sceneActors.remove(atOffsets: offsets)
        self.currentScene.actors.remove(atOffsets: offsets)
        viewModel.update(object: currentScene, with: ["actors": currentScene.actors])
    }
    
    func getScenes(for sceneId: String) -> [MovieScene] {
        var allScenes: [MovieScene] = []
        
        let scenes = viewModel.sceneContinuities.filter {
            $0.scene1 == sceneId ||
            $0.scene2 == sceneId
        }
        
        for scene in scenes where scene.scene1 == sceneId {
            allScenes.append(getScene(for: scene.scene2))
        }
        
        for scene in scenes where scene.scene2 == sceneId {
            allScenes.append(getScene(for: scene.scene1))
        }
        
        return allScenes
    }
    
    func getScene(for sceneId: String) -> MovieScene {
        if let scene = viewModel.scenes.filter({ $0.id ?? "" == sceneId }).first {
            return scene
        } else {
            return MovieScene.preview()
        }
    }
}

struct SceneDetailView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            SceneDetailView(viewModel: ProjectViewModel.preview(), currentScene: MovieScene.preview())
        }
    }
}
