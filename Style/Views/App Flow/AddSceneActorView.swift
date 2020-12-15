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
    var currentSceneActor: SceneActor?
    
    @State private var showingImagePicker = false
    
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
                        if inputImage == nil {
                            Image(systemName: "person.crop.circle.fill.badge.plus")
                                .resizable()
                                .frame(height: 250)
                                .onTapGesture {
                                    self.showingImagePicker.toggle()
                                }
                        } else {
                            image
                                .resizable()
                                .frame(height: 250)
                                .onTapGesture {
                                    self.showingImagePicker.toggle()
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
                ImagePicker(image: self.$inputImage)
            }
            .onAppear {
                if let sceneActor = currentSceneActor {
                    nameOfLook = sceneActor.name
                    top = sceneActor.top
                    bottom = sceneActor.bottom
                    shoes = sceneActor.shoes
                    accessories = sceneActor.accessories
                    notes = sceneActor.notes
//                    KingfisherManager.shared.retrieveImage(with: url, options: nil, progressBlock: nil, completionHandler: { img, error, cacheType, imageURL in
//                        guard let newImage = img else { return }
//                        inputImage = newImage
//                        image = Image(uiImage: newImage)
//                        
//                    })
                }
            }
        }
    }
}

extension AddSceneActorView {
    func addSceneActor() {
        let sceneActor = SceneActor(id: nil,
                                    sceneActorId: "\(viewModel.currentScene?.id ?? "")-\(viewModel.currentActor?.id ?? "")",
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
