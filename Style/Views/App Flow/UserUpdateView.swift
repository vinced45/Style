//
//  UserUpdateView.swift
//  Style
//
//  Created by Vince Davis on 11/23/20.
//

import SwiftUI
import KingfisherSwiftUI

struct UserUpdateView: View {
    @Binding var showSheetView: Bool
    @ObservedObject var viewModel: ProjectViewModel
    var user: ProjectUser?
    
    @State var showAlert: Bool = false
    
    @EnvironmentObject var session: SessionStore
    
    @State private var name: String = ""
    @State private var title: String = ""
    
    @State private var showingImagePicker = false
    @State private var inputImage: UIImage?
    @State private var userImage: Image?
    
    @State private var imageUrlString: String = ""
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Profile Image")) {
                    HStack{
                        Spacer()
                        if let image = userImage {
                            image
                                .resizable()
                                .modifier(ProfileImageStyle())
                                .onTapGesture {
                                    self.showingImagePicker = true
                                }
                        } else {
                            if imageUrlString.isEmpty {
                                Image(systemName: "plus.circle.fill")
                                    .resizable()
                                    .modifier(ProfileImageStyle())
                                    .onTapGesture {
                                        self.showingImagePicker = true
                                    }
                            } else {
                                KFImage(URL(string: imageUrlString))
                                    .resizable()
                                    .modifier(ProfileImageStyle())
                                    .onTapGesture {
                                        self.showingImagePicker = true
                                    }
                            }
                            
                        }
                        Spacer()
                    }
                }
                
                Section {
                    VStack(alignment: .leading) {
                        Text("Name").bold()
                        TextField("Name", text: $name)
                            .modifier(TextFieldStyle())
                    }
                    
                    VStack(alignment: .leading) {
                        Text("Title").bold()
                        TextField("Title", text: $title)
                            .modifier(TextFieldStyle())
                    }
                }
                
                Section {
                    Button(action: {
                        showAlert.toggle()
                    }) {
                        HStack(spacing: 10) {
                            Text("Sign Out")
                        }
                    }
                        .modifier(ButtonStyle())
                        .padding(10)
                }
            }
            .padding(12)
            .navigationBarTitle("Profile")
            .navigationBarItems(leading: Button(action: {
                self.showSheetView = false
            }) {
                Text("Cancel").bold()
            }, trailing: Button(action: {
                updateUser()
            }) {
                Text("Save").bold()
            })
            .alert(isPresented: $showAlert) { () -> Alert in
                        let primaryButton = Alert.Button.destructive(Text("Sign Out")) {
                            self.showSheetView = false
                            session.signOut()
                        }
                        let secondaryButton = Alert.Button.cancel(Text("Cancel")) {
                            print("secondary button pressed")
                        }
                        return Alert(title: Text("Sign Out"), message: Text("Are you sure you want to sign out?"), primaryButton: primaryButton, secondaryButton: secondaryButton)
                    }
            .sheet(isPresented: $showingImagePicker, onDismiss: loadImage) {
                ImagePicker(image: self.$inputImage)
            }
            .onAppear {
                viewModel.fetchUser(for: session.session?.uid ?? "")
            }
            .onReceive(viewModel.didChange) { _ in
                if let newUser = viewModel.currentUser {
                    name = newUser.name
                    title = newUser.title
                    imageUrlString = newUser.image
                }
            }
        }
    }
}

extension UserUpdateView {
    func updateUser() {
        if let newUser = viewModel.currentUser {
            viewModel.update(object: newUser, with: ["name": name, "title": title, "image" : imageUrlString])
        } else {
            let user = ProjectUser(id: nil,
                                   uid: session.session?.uid ?? "",
                                   name: name,
                                   title: title,
                                   image: imageUrlString,
                                   createdTime: nil)
            
            viewModel.add(object: user)
        }
        showSheetView = false
    }
    
    func loadImage() {
        guard let inputImage = inputImage,
              let imageData = inputImage.jpegData(compressionQuality: 0.9) else { return }
        
        userImage = Image(uiImage: inputImage)
        
        viewModel.upload(data: imageData, to: "image/\(UUID().uuidString).jpg") { url in
            guard let imageUrl = url else { return }
            print("url: \(imageUrl.absoluteString)")
            imageUrlString = imageUrl.absoluteString
        }
    }
}

//struct UserUpdateView_Previews: PreviewProvider {
//    static var previews: some View {
//        UserUpdateView()
//    }
//}
