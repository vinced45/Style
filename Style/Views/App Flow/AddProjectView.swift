//
//  AddProjectView.swift
//  Style
//
//  Created by Vince Davis on 12/15/20.
//

import Foundation
import SwiftUI
import Combine
import FirebaseFirestore
import FirebaseFirestoreSwift

struct AddProjectView: View {
    @Binding var showSheetView: Bool
    @ObservedObject var viewModel: ProjectViewModel
    
    @State private var showingImagePicker = false
    @State var showCamera: Bool = false
    
    @State private var inputImage: UIImage? = nil
    
    @State private var projectImage: Image = Image("viola")
    @State private var name: String = ""
    
    @State private var imageUrlString: String = ""
    
    //let newProject: (Project) -> Void
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    HStack{
                        Spacer()
                        VStack {
                            if inputImage == nil {
                                Image(systemName: "person.circle.fill")
                                    .resizable()
                                    .modifier(ProfileImageStyle())
                            } else {
                                projectImage
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
                        Spacer()
                    }
                }
                
                Section {
                    VStack(alignment: .leading) {
                        Text("Project Name").bold()
                        TextField("Name", text: $name)
                            .modifier(TextFieldStyle())
                    }
                }
            }
            .navigationBarTitle(Text("Add Project"), displayMode: .inline)
                .navigationBarItems(leading: Button(action: {
                    self.showSheetView = false
                }) {
                    Text("Cancel").bold()
                }, trailing: Button(action: {
                    addProject()
                }) {
                    Text("Save").bold()
                })
            .sheet(isPresented: $showingImagePicker, onDismiss: loadImage) {
                ImagePicker(image: $inputImage, showCamera: $showCamera)
            }
        }
    }
}

extension AddProjectView {
    func addProject() {
        let project = Project(id: UUID().uuidString, name: name, image: imageUrlString, createdTime: nil)
        viewModel.add(object: project)
        self.showSheetView = false
    }
    
    func loadImage() {
        guard let inputImage = inputImage,
              let imageData = inputImage.jpegData(compressionQuality: 0.9) else { return }
        
        projectImage = Image(uiImage: inputImage)
        
        viewModel.upload(data: imageData, to: "image/\(UUID().uuidString).jpg") { url in
            guard let imageUrl = url else { return }
            print("url: \(imageUrl.absoluteString)")
            imageUrlString = imageUrl.absoluteString
        }
    }
}


//struct AddProjectView_Previews: PreviewProvider {
//    @State static var showSheetView = true
//
//    static var previews: some View {
//        Group {
//            AddProjectView(showSheetView: $showSheetView, viewModel: <#Binding<ProjectViewModel>#>) { actor in
//
//            }
//            AddProjectView(showSheetView: $showSheetView) { actor in
//
//            }
//            .preferredColorScheme(.dark)
//        }
//    }
//}
