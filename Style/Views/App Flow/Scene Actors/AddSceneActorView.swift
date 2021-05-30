//
//  AddSceneActorView.swift
//  Style
//
//  Created by Vince Davis on 12/15/20.
//

import SwiftUI
import Kingfisher

struct AddSceneActorView: View {
    @Binding var showSheet: Bool
    @ObservedObject var viewModel: ProjectViewModel
    @State var currentSceneActor: SceneActor?

    @State private var nameOfLook: String = ""
    @State private var top: String = ""
    @State private var bottom: String = ""
    @State private var shoes: String = ""
    @State private var accessories: String = ""
    @State private var notes: String = ""
    @State private var image: Image = Image("viola")
    
    @State var sceneImages: [String] = []
    
    var body: some View {
        NavigationView {
            ZStack {
                SlantedBackgroundView()
                    .zIndex(1.0)
                
                Form {
                    Section(header: Text("Photo"), footer: Text("Tap + button to add scene Images")) {
                        UpdateMultipleImageView(isEditing: true, images: $sceneImages, imageTapped: { _ in }, imageData: { imageData in
                            self.viewModel.upload(data: imageData, to: "image/\(UUID().uuidString).jpg") { url in
                                guard let imageUrl = url else { return }
                                
                                self.sceneImages.append(imageUrl.absoluteString)
                                //viewModel.update(object: currentScene, with: ["images": sceneImages])
                            }
                        })
                    }
                    
                    Section(header: Text("Details")) {
                        VStack(alignment: .leading) {
                            Text("Name of Look").bold()
                            TextField("Name of Look", text: $nameOfLook)
                                .modifier(TextFieldStyle())
                        }
                        
                        VStack(alignment: .leading) {
                            Text("Top").bold()
                            TextField("Top", text: $top)
                                .modifier(TextFieldStyle())
                        }
                        
                        VStack(alignment: .leading) {
                            Text("Bottom").bold()
                            TextField("Bottom", text: $bottom)
                                .modifier(TextFieldStyle())
                        }
                        
                        VStack(alignment: .leading) {
                            Text("Shoes").bold()
                            TextField("Shoes", text: $shoes)
                                .modifier(TextFieldStyle())
                        }
                        
                        VStack(alignment: .leading) {
                            Text("Accessories").bold()
                            TextField("Accessories", text: $accessories)
                                .modifier(TextFieldStyle())
                        }
                        
                        VStack(alignment: .leading) {
                            Text("Notes").bold()
                            TextField("Notes", text: $notes)
                                .modifier(TextFieldStyle())
                        }
                    }
                }
                .zIndex(2.0)
            }
            .navigationBarTitle(Text(viewModel.currentActor?.screenName ?? ""), displayMode: .inline)
                .navigationBarItems(leading: Button(action: {
                    self.showSheet = false
                }) {
                    Text("Cancel").bold()
                }, trailing: Button(action: {
                    addSceneActor()
                }) {
                    Text("Save").bold()
                })
            .onAppear {
                currentSceneActor = viewModel.currentSceneActor
                if let sceneActor = currentSceneActor {
                    nameOfLook = sceneActor.name
                    top = sceneActor.top
                    bottom = sceneActor.bottom
                    shoes = sceneActor.shoes
                    accessories = sceneActor.accessories
                    notes = sceneActor.notes
                    sceneImages = sceneActor.images
                    
                    viewModel.fetchactorImageDetails(for: sceneActor.images.first ?? "") { foundActorImage in
                        nameOfLook = foundActorImage?.name ?? ""
                        top = foundActorImage?.top ?? ""
                        bottom = foundActorImage?.bottom ?? ""
                        shoes = foundActorImage?.shoes ?? ""
                        accessories = foundActorImage?.accessories ?? ""
                        notes = foundActorImage?.notes ?? ""
                    }
                }
            }
        }
    }
}

extension AddSceneActorView {
    func addSceneActor() {
        var newId = ""
        if let tempId = currentSceneActor?.sceneActorId {
            newId = tempId
        } else {
            newId = "\(viewModel.currentScene?.id ?? "")-\(viewModel.currentActor?.id ?? "")"
        }
        let sceneActor = SceneActor(id: nil,
                                    sceneActorId: newId,
                                    name: nameOfLook,
                                    top: top,
                                    bottom: bottom,
                                    shoes: shoes,
                                    accessories: accessories,
                                    notes: notes,
                                    beforeLook: true,
                                    images: sceneImages,
                                    createdTime: nil)
        
        viewModel.add(object: sceneActor) { _ in }
        self.showSheet = false
    }
}

//struct AddSceneActorView_Previews: PreviewProvider {
//    static var previews: some View {
//        AddSceneActorView()
//    }
//}
