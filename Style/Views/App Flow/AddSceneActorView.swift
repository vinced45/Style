//
//  AddSceneActorView.swift
//  Style
//
//  Created by Vince Davis on 12/15/20.
//

import SwiftUI
import KingfisherSwiftUI

struct AddSceneActorView: View {
    @Binding var showSheet: Bool
    @ObservedObject var viewModel: ProjectViewModel
    @State var currentSceneActor: SceneActor?
    
    @State private var showingImagePicker = false
    @State var showCamera: Bool = false
    
    @State private var inputImage: UIImage? = nil

    @State private var nameOfLook: String = ""
    @State private var top: String = ""
    @State private var bottom: String = ""
    @State private var shoes: String = ""
    @State private var accessories: String = ""
    @State private var notes: String = ""
    @State private var image: Image = Image("viola")
        
    @State private var imageUrlString: String = ""
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Tap image to add look")) {
                    HStack{
                        Spacer()
                        VStack {
                            if !imageUrlString.isEmpty {
                                KFImage(URL(string: imageUrlString))
                                    .resizable()
                                    .scaledToFit()
                                    .frame(height: 250)
                                    //.aspectRatio(1, contentMode: .fit)
                            } else if inputImage == nil {
                                Image(systemName: "photo.fill")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(height: 250)
                                    //.aspectRatio(1, contentMode: .fit)
                            } else {
                                image
                                    .resizable()
                                    .scaledToFit()
                                    .frame(height: 250)
                                    //.aspectRatio(1, contentMode: .fit)
                            }
                            Menu {
                                Button(action: {
                                    showCamera = true
                                    showingImagePicker.toggle()
                                }) {
                                    Label("Take Picture", systemImage: "camera")
                                }
                                Button(action: {
                                    showCamera = false
                                    showingImagePicker.toggle()
                                }) {
                                    Label("Photo Gallery", systemImage: "photo.on.rectangle")
                                }
                            } label: {
                                Text("Tap to Update Image")
                            }
                        }
                        Spacer()
                    }
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
            .navigationBarTitle(Text("Add Actor"), displayMode: .inline)
                .navigationBarItems(leading: Button(action: {
                    self.showSheet = false
                }) {
                    Text("Cancel").bold()
                }, trailing: Button(action: {
                    addSceneActor()
                }) {
                    Text("Save").bold()
                })
            .sheet(isPresented: $showingImagePicker, onDismiss: loadImage) {
                ImagePicker(image: $inputImage, showCamera: $showCamera)
            }
            .onAppear {
                currentSceneActor = viewModel.currentSceneActor
                if let sceneActor = currentSceneActor {
                    nameOfLook = sceneActor.name
                    top = sceneActor.top
                    bottom = sceneActor.bottom
                    shoes = sceneActor.shoes
                    accessories = sceneActor.accessories
                    notes = sceneActor.notes
                    imageUrlString = sceneActor.image
                    
                    viewModel.fetchactorImageDetails(for: imageUrlString) { foundActorImage in
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
                                    image: imageUrlString,
                                    createdTime: nil)
        
        viewModel.add(object: sceneActor)
        self.showSheet = false
    }
    
    func loadImage() {
        guard let inputImage = inputImage,
              let imageData = inputImage.jpegData(compressionQuality: 0.9) else { return }
        
        image = Image(uiImage: inputImage)
        
        viewModel.upload(data: imageData, to: "image/\(UUID().uuidString).jpg") { url in
            guard let imageUrl = url else { return }
            print("url: \(imageUrl.absoluteString)")
            imageUrlString = imageUrl.absoluteString
        }
    }
}

//struct AddSceneActorView_Previews: PreviewProvider {
//    static var previews: some View {
//        AddSceneActorView()
//    }
//}
