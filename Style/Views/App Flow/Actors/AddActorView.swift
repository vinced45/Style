//
//  AddActorView.swift
//  Style
//
//  Created by Vince Davis on 11/23/20.
//

import SwiftUI
import Combine

struct AddActorView: View {
    @Binding var showAddActor: Bool
    @ObservedObject var viewModel: ProjectViewModel
    
    @State private var showingImagePicker = false
    @State var showCamera: Bool = false
    
    @State private var inputImage: UIImage? = nil

    @State private var realName: String = ""
    @State private var screenName: String = ""
    @State private var profileImage: Image = Image("viola")
    
    @State var sizeSelection: Int = 0
    
    @State private var imageUrlString: String = ""
    
    //let newActor: (Actor) -> Void
    
    var body: some View {
        NavigationView {
            ZStack {
                StyleBackgroundView()
                    .zIndex(1.0)
                
                VStack {
                    Group {
                        VStack {
                            if inputImage == nil {
                                Image(systemName: "person.circle.fill")
                                    .resizable()
                                    .modifier(ProfileImageStyle())
                            } else {
                                profileImage
                                    .resizable()
                                    .modifier(ProfileImageStyle())
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
                    }
                    .padding(.top, 100)
                    
                    Spacer()
                    
                    Group {
                        FormTextFieldView(name: "Real Name", placeholder: "Real Name", text: $realName)
                        
                        FormTextFieldView(name: "Screen Name", placeholder: "Screen Name", text: $screenName)
                        
//                        Picker(selection: $sizeSelection, label:
//                                Text("Size Chart").bold()
//                                        , content: {
//                                            Text("Small").tag(0)
//                                            Text("Medium").tag(1)
//                                            Text("Large").tag(2)
//                                            Text("Extra Large").tag(3)
//                                    })
                    }
                    .padding([.leading, .trailing], 30)
                    
                    Spacer()
                }
                .zIndex(2.0)
            }
            
            .navigationBarTitle(Text("Add Actor"), displayMode: .inline)
            .navigationBarItems(leading: Button(action: {
                self.showAddActor = false
            }) {
                Text("Cancel").bold()
            }, trailing: Button(action: {
                addActor()
            }) {
                Text("Save").bold()
            })
            .sheet(isPresented: $showingImagePicker, onDismiss: loadImage) {
                ImagePicker(image: $inputImage, showCamera: $showCamera)
            }
        }
    }
}

extension AddActorView {
    func addActor() {
        let actor = Actor(id: nil, projectId: viewModel.currentProject?.id ?? "", realName: realName, screenName: screenName, image: imageUrlString, clothesSize: sizeSelection, images: [], createdTime: nil)
        viewModel.add(object: actor) { _ in }
        self.showAddActor = false
    }
    
    func loadImage() {
        guard let inputImage = inputImage,
              let imageData = inputImage.jpegData(compressionQuality: 0.9) else { return }
        
        profileImage = Image(uiImage: inputImage)
        
        viewModel.upload(data: imageData, to: "image/\(UUID().uuidString).jpg") { url in
            guard let imageUrl = url else { return }
            print("url: \(imageUrl.absoluteString)")
            imageUrlString = imageUrl.absoluteString
        }
    }
}


struct AddActorView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            AddActorView(showAddActor: .constant(true), viewModel: ProjectViewModel.preview())
        }
    }
}
