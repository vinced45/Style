//
//  UpdateActorLookView.swift
//  Style
//
//  Created by Vince Davis on 1/11/21.
//

import SwiftUI
import Photos
import PhotosUI
import AlertToast

struct AddActorLookView: View {
    @Binding var showSheet: Bool

    @ObservedObject var viewModel: ProjectViewModel
    
    @EnvironmentObject var session: SessionStore

    @State var text: String = ""

    @State var lookImages: [String] = []
    
    @State var isImagesExpanded = true
    
    @State private var photoList: [PHPickerResult]?
    
    @State var inputImage: UIImage? = nil
    
    enum SheetType {
        case camera
        case photoAlbum
    }
    
    @ObservedObject var sheet = SheetState<AddActorLookView.SheetType>()

    var body: some View {
        NavigationView {
            ZStack {
                SlantedBackgroundView()
                    .zIndex(1.0)
                
                VStack {
                    List {
                        Section(header: Text("Add Image")) {
                            Button(action: { sheet.state = .photoAlbum }) {
                                Label("Photo Gallery", systemImage: "photo.on.rectangle.angled")
                            }
                            
                            Button(action: { sheet.state = .camera }) {
                                Label("Camera", systemImage: "camera")
                            }
                        }
                        Section {
                            DisclosureGroup(isExpanded: $isImagesExpanded) {
                                UpdateMultipleImageView(isEditing: false, images: $lookImages, imageTapped: { _ in }, imageData: { _ in })
                            } label: {
                                Text("Look Images")
                                    .font(.headline)
                                    .onTapGesture {
                                        isImagesExpanded.toggle()
                                    }
                            }
                            
                            NavigationLink(destination: SceneImageListView(images: lookImages, index: 4)) {
                                Text("List Images")
                            }
                        }
                        
                        Section {
                            FormTextFieldView(name: "Description", placeholder: "Description of Look", text: $text)
                                //.padding([.leading, .trailing], 30)
                        }
                    }
                    .listStyle(InsetGroupedListStyle())
                    .padding(.top, 50)
                }
                .zIndex(2.0)
            }
            .navigationBarTitle(Text("Add Look"), displayMode: .inline)
            .navigationBarItems(leading: Button(action: {
                    self.showSheet = false
                }) {
                    Text("Cancel").bold()
                }, trailing: Button(action: {
                    let newActorLook = ActorLook(id: nil,
                                                 actorId: viewModel.currentActor?.id ?? "",
                                                 images: lookImages,
                                                 text: text,
                                                 completed: false,
                                                 creatorId: session.session?.uid ?? "",
                                                 lastUpdated: Date(),
                                                 createdTime: nil)
                    self.viewModel.add(object: newActorLook) { _ in }
                    self.showSheet = false
                }) {
                    Text("Save").bold()
                })
            .sheet(isPresented: $sheet.isShowing, onDismiss: handleDismiss) {
                switch sheet.state {
                case .camera:
                    ImagePicker(image: $inputImage, showCamera: $sheet.isShowing)
                case .photoAlbum:
                    PhotoPicker(result: $photoList)
                case .none: EmptyView()
                }
            }
        }
    }
}

extension AddActorLookView {
    func handleDismiss() {
        switch sheet.state {
        case .camera: loadImage()
        case .photoAlbum: loadImages()
        default: break
        }
    }
    func loadImage() {
        guard let inputImage = inputImage,
              let watermarkImage = inputImage.watermark(),
              let imageData = watermarkImage.jpegData(compressionQuality: 0.9) else { return }
        
        upload(data: imageData)
    }
    
    func loadImages() {
        guard let results = photoList, results.count > 0 else { return }

        AssetProcessor.process(results: photoList ?? []) { data in
            self.upload(data: data)
        }
    }
    
    func upload(data: Data) {
        self.viewModel.upload(data: data, to: "image/\(UUID().uuidString).jpg") { url in
            guard let imageUrl = url else { return }
            
            self.lookImages.append(imageUrl.absoluteString)
        }
    }
}

struct AddActorLookView_Previews: PreviewProvider {
    static var previews: some View {
        AddActorLookView(showSheet: .constant(true), viewModel: ProjectViewModel.preview())
    }
}

struct EditActorLookView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var actorLook: ActorLook
    
    @ObservedObject var viewModel: ProjectViewModel
    
    @EnvironmentObject var session: SessionStore
    
    @State var text: String = ""
    
    @State var lookImages: [String] = []
    
    @State var isImagesExpanded = true
    
    @State private var photoList: [PHPickerResult]?
    
    @State var inputImage: UIImage? = nil
    
    @State var showSheet: Bool = false
    
    @State private var currentImage: String = ""
    
    @State var showToast: Bool = false
    
    enum SheetType {
        case camera
        case photoAlbum
    }
    
    @ObservedObject var sheet = SheetState<EditActorLookView.SheetType>()
    
    var body: some View {
        ZStack {
            StyleBackgroundView()
                .zIndex(1.0)
            
            VStack {
                List {
                    Section(header: Text("Add Image")) {
                        Button(action: { sheet.state = .photoAlbum }) {
                            Label("Photo Gallery", systemImage: "photo.on.rectangle.angled")
                        }
                        
                        Button(action: { sheet.state = .camera }) {
                            Label("Camera", systemImage: "camera")
                        }
                    }
                    Section {
                        DisclosureGroup(isExpanded: $isImagesExpanded) {
                            UpdateMultipleImageView(isEditing: false, images: $lookImages, imageTapped: { imageUrl in
                                currentImage = imageUrl
                                showSheet = true
                            }, imageData: { _ in })
                            .toast(isPresenting: $showToast) {
                                //AlertToast(type: .regular, title: "Uploading Image")
                                AlertToast(type: .loading, title: "Please Wait", subTitle: "Uploading Images")
                                //Choose .hud to toast alert from the top of the screen
                                //AlertToast(displayMode: .hud, type: .regular, title: "Uploading Image")
                            }
                        } label: {
                            Text("Look Images")
                                .font(.headline)
                                .onTapGesture {
                                    isImagesExpanded.toggle()
                                }
                        }
                        
                        NavigationLink(destination: SceneImageListView(images: lookImages, index: 4)) {
                            Text("List Images")
                        }
                    }
                    
                    Section {
                        FormTextFieldView(name: "Description", placeholder: "Description of Look", text: $text)
                            //.padding([.leading, .trailing], 30)
                    }
                }
                .listStyle(InsetGroupedListStyle())
                .padding(.top, 50)
            }
            .zIndex(2.0)
        }
        .navigationBarTitle(Text("Edit Look"), displayMode: .inline)
        .onAppear {
            lookImages = actorLook.images
            text = actorLook.text
        }
        .actionSheet(isPresented: $showSheet, content: {
            ActionSheet(title: Text("Delete Photo"), message: nil, buttons: [.cancel(), .destructive(Text("Delete"), action: { delete() })])
        })
        .sheet(isPresented: $sheet.isShowing, onDismiss: handleDismiss) {
            switch sheet.state {
            case .camera:
                ImagePicker(image: $inputImage, showCamera: $sheet.isShowing)
            case .photoAlbum:
                PhotoPicker(result: $photoList)
            case .none: EmptyView()
            }
        }
        
        .navigationBarItems(trailing: Button(action: {
                viewModel.update(object: actorLook, with: ["text": text, "images" : lookImages])
                //viewModel.fetchNotes(for: viewModel.currentActor.id ?? "")
                self.presentationMode.wrappedValue.dismiss()
            }) {
                Text("Save").bold()
            })
    }
}

extension EditActorLookView {
    func delete() {
        if let index = lookImages.firstIndex(of: currentImage) {
            lookImages.remove(at: index)
            viewModel.update(object: actorLook, with: ["images": lookImages])
        }
        
        showSheet = false
    }
    
    func handleDismiss() {
        switch sheet.state {
        case .camera: loadImage()
        case .photoAlbum: loadImages()
        default: break
        }
    }
    func loadImage() {
        guard let inputImage = inputImage,
              let watermarkImage = inputImage.watermark(),
              let imageData = watermarkImage.jpegData(compressionQuality: 0.9) else { return }
        showToast = true
        upload(data: imageData)
    }
    
    func loadImages() {
        guard let results = photoList, results.count > 0 else { return }
        showToast = true
        AssetProcessor.process(results: photoList ?? []) { data in
            self.upload(data: data)
        }
    }
    
    func upload(data: Data) {
        self.viewModel.upload(data: data, to: "image/\(UUID().uuidString).jpg") { url in
            guard let imageUrl = url else { return }
            showToast = false
            self.lookImages.append(imageUrl.absoluteString)
        }
    }
}

struct EditActorLookView_Previews: PreviewProvider {
    static var previews: some View {
        EditActorLookView(actorLook: ActorLook.preview(), viewModel: ProjectViewModel.preview())
    }
}
