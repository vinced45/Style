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
import Kingfisher

struct AddProjectView: View {
    @Binding var showSheetView: Bool
    @ObservedObject var viewModel: ProjectViewModel
    
    @State private var showingImagePicker = false
    @State var showCamera: Bool = false
    
    @State private var inputImage: UIImage? = nil
    
    @State private var projectImage: Image = Image("viola")
    @State private var name: String = ""
    
    @State private var imageUrlString: String = ""
    
    @EnvironmentObject var session: SessionStore
        
    var body: some View {
        NavigationView {
            ZStack {
                
                StyleBackgroundView()
                    .zIndex(1.0)
                
                VStack {
                    VStack {
                        if inputImage == nil {
                            Image(systemName: "person.circle.fill")
                                .resizable()
                                .frame(width: 120, height: 80)
                                .overlay(Rectangle().stroke(Color("darkPink"), lineWidth: 3))
                        } else {
                            projectImage
                                .resizable()
                                .frame(width: 120, height: 80)
                                .overlay(Rectangle().stroke(Color("darkPink"), lineWidth: 3))
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
                    .padding(.top, 100)
                    
                    Spacer().frame(height: 150)
                    
                    FormTextFieldView(name: "Project Name", placeholder: "Name", text: $name)
                        .padding([.leading, .trailing], 30)
                    
                    Spacer()
                }
                .zIndex(2.0)
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
        let project = Project(id: UUID().uuidString,
                              name: name,
                              image: imageUrlString,
                              admins: [session.session?.uid ?? ""],
                              readOnlyUsers: [],
                              creatorId: session.session?.uid ?? "",
                              dateCreated: Date(),
                              lastUser: session.session?.uid ?? "",
                              lastUpdated: Date(),
                              createdTime: nil)
        
        viewModel.add(object: project) { _ in }
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

struct AddProjectView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            AddProjectView(showSheetView: .constant(true), viewModel: ProjectViewModel.preview())
        }
    }
}

struct EditProjectView: View {
    @Binding var showSheetView: Bool
    @Binding var project: Project
    @ObservedObject var viewModel: ProjectViewModel
    
    @State private var showingImagePicker = false
    @State var showCamera: Bool = false
    
    @State private var inputImage: UIImage? = nil
    
    @State private var projectImage: Image = Image("viola")
    @State private var name: String = ""
    
    @State private var imageUrlString: String = ""
    
    @EnvironmentObject var session: SessionStore
        
    var body: some View {
        NavigationView {
            ZStack {
                StyleBackgroundView()
                    .zIndex(1.0)
                
                VStack {
                    VStack {
                        if imageUrlString.isNotEmpty {
                            KFImage(URL(string: project.image))
                                .resizable()
                                .frame(width: 120, height: 80)
                                .overlay(Rectangle().stroke(Color("darkPink"), lineWidth: 3))
                        } else if inputImage == nil {
                            Image(systemName: "person.circle.fill")
                                .resizable()
                                .frame(width: 120, height: 80)
                                .overlay(Rectangle().stroke(Color("darkPink"), lineWidth: 3))
                        } else {
                            projectImage
                                .resizable()
                                .frame(width: 120, height: 80)
                                .overlay(Rectangle().stroke(Color("darkPink"), lineWidth: 3))
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
                    .padding(.top, 100)
                    
                    Spacer()
                        .frame(height: 150)
                    
                    FormTextFieldView(name: "Project Name", placeholder: "Name", text: $name)
                        .padding([.leading, .trailing], 30)
                    
                    Spacer()
                }
                .zIndex(2.0)
            }
            .navigationBarTitle(Text("Edit Project"), displayMode: .inline)
                .navigationBarItems(leading: Button(action: {
                    self.showSheetView = false
                }) {
                    Text("Cancel").bold()
                }, trailing: Button(action: {
                    updateProject()
                }) {
                    Text("Save").bold()
                })
            .sheet(isPresented: $showingImagePicker, onDismiss: loadImage) {
                ImagePicker(image: $inputImage, showCamera: $showCamera)
            }
            .onAppear {
                imageUrlString = project.image
                name = project.name
            }
        }
    }
}

extension EditProjectView {
    func updateProject() {
        project.image = imageUrlString
        project.name = name
        viewModel.update(object: project, with: ["image": imageUrlString,
                                                 "name": name,
                                                 "lastUser": session.session?.uid ?? "",
                                                 "lastUpdated": Date()])
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

struct EditProjectView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            EditProjectView(showSheetView: .constant(true),
                            project: .constant(Project.preview()),
                            viewModel: ProjectViewModel.preview())
        }
    }
}
