//
//  UserUpdateView.swift
//  Style
//
//  Created by Vince Davis on 11/23/20.
//

import SwiftUI
import KingfisherSwiftUI
import iPhoneNumberField

struct UserUpdateView: View {
    @Binding var showSheetView: Bool
    @ObservedObject var viewModel: ProjectViewModel
    var user: ProjectUser?
    
    @State var showAlert: Bool = false
    
    @EnvironmentObject var session: SessionStore
    
    @State private var lastName: String = ""
    @State private var firstName: String = ""
    @State private var title: String = ""
    @State private var phone: String = ""
    
    @State private var showingImagePicker = false
    @State var showCamera: Bool = false
    @State private var inputImage: UIImage?
    @State private var userImage: Image?
    
    @State private var imageUrlString: String = ""
    
    var body: some View {
        NavigationView {
            
            ZStack {
                StyleBackgroundView()
                    .zIndex(1.0)
                
                VStack {
                    VStack {
                        if let image = userImage {
                            image
                                .resizable()
                                .modifier(ProfileImageStyle())
                        } else {
                            if imageUrlString.isEmpty {
                                Image(systemName: "person.circle.fill")
                                    .resizable()
                                    .modifier(ProfileImageStyle())
                            } else {
                                KFImage(URL(string: imageUrlString))
                                    .resizable()
                                    .modifier(ProfileImageStyle())
                            }
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
                    .padding(.top, 90)
                    
                    Spacer()
                    
                    Group {
                        FormTextFieldView(name: "First Name", placeholder: "First Name", text: $firstName)
                        
                        FormTextFieldView(name: "Last Name", placeholder: "Last Name", text: $lastName)
                        
                        VStack(alignment: .leading) {
                            Text("Phone").padding(.leading, 15)
                            iPhoneNumberField("000-000-0000", text: $phone)
                                .flagHidden(true)
                                .flagSelectable(true)
                                .maximumDigits(10)
                                .clearButtonMode(.whileEditing)
                                .modifier(TextFieldStyle())
                        }
                        
                        FormTextFieldView(name: "Title", placeholder: "Title", text: $title)
                    }
                    .padding([.leading, .trailing], 30)
                    
                    
                    Spacer()
                }
                .zIndex(2.0)
            }

            .navigationBarTitle("Profile", displayMode: .inline)
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
                ImagePicker(image: $inputImage, showCamera: $showCamera)
            }
            .onAppear {
                viewModel.fetchUser(for: session.session?.uid ?? "")
            }
            .onReceive(viewModel.didChange) { _ in
                if let newUser = viewModel.currentUser {
                    firstName = newUser.firstName
                    lastName = newUser.lastName
                    phone = newUser.phone.filter("0123456789".contains)
                    title = newUser.title
                    imageUrlString = newUser.image
                }
            }
        }
    }
}

extension UserUpdateView {
    func updateUser() {
        let user: [String: Any] = ["firstName": firstName,
                                   "lastName": lastName,
                                   "phone" : phone,
                                   "title" : title,
                                   "image" : imageUrlString]
        
        
//        session.updateUserDetails(for: user) { success in
//            print("User was update \(success)")
//        }
        if let foundUser = viewModel.currentUser {
            viewModel.update(object: foundUser, with: user)
        } else {
            let user = ProjectUser(id: nil,
                                   uid: session.session?.uid ?? "",
                                   firstName: firstName,
                                   lastName: lastName,
                                   phone: phone,
                                   title: title,
                                   image: imageUrlString,
                                   createdTime: nil)

            viewModel.add(object: user) { _ in }
        }
        
        showSheetView = false
    }
    
    func loadImage() {
        guard let inputImage = inputImage,
              let imageData = inputImage.jpegData(compressionQuality: 0.9) else { return }
        
        userImage = Image(uiImage: inputImage)
        
        viewModel.upload(data: imageData, to: "image/\(UUID().uuidString).jpg") { url in
            guard let imageUrl = url else { return }
            //print("url: \(imageUrl.absoluteString)")
            imageUrlString = imageUrl.absoluteString
        }
    }
}

struct UserUpdateView_Previews: PreviewProvider {
    static var previews: some View {
        UserUpdateView(showSheetView: .constant(true), viewModel: ProjectViewModel.preview())
            .environmentObject(SessionStore())
    }
}
