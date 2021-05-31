//
//  UpdateImageView.swift
//  Style
//
//  Created by Vince Davis on 1/11/21.
//

import SwiftUI
import Photos
import PhotosUI
import Kingfisher

struct UpdateImageView: View {
    @State var showingImagePicker: Bool = false
    @State var showCamera: Bool = false
    
    @State var inputImage: UIImage? = nil
    
    @State var imageUrl: String? = nil

    @State var profileImage: Image = Image("viola-0")
    
    let imageData: (Data) -> Void

    var body: some View {
        HStack{
            Spacer()
            VStack {
                if imageUrl != nil {
                    KFImage(URL(string: imageUrl ?? ""))
                        .resizable()
                        .frame(width: 100, height: 100)
                        .scaledToFit()
                }
                else if inputImage == nil {
                    Image(systemName: "photo.fill")
                        .resizable()
                        .frame(width: 100, height: 100)
                        .scaledToFit()
                } else {
                    profileImage
                        .resizable()
                        .frame(width: 100, height: 100)
                        .scaledToFit()
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
        .sheet(isPresented: $showingImagePicker, onDismiss: loadImage) {
            ImagePicker(image: $inputImage, showCamera: $showCamera)
        }
    }
}

extension UpdateImageView {
    func loadImage() {
        guard let inputImage = inputImage,
              let watermarkImage = inputImage.watermark(),
              let imageData = watermarkImage.jpegData(compressionQuality: 0.9) else { return }
        
        imageUrl = nil
        
        profileImage = Image(uiImage: inputImage)
        
        self.imageData(imageData)
    }
}

struct UpdateImageView_Previews: PreviewProvider {
    static var previews: some View {
        UpdateImageView() { _ in }
            .padding(.all)
            .previewLayout(.sizeThatFits)
    }
}

struct UpdateMultipleImageView: View {
    var isEditing: Bool
    
    @Binding var images: [String]
    
    @State var showGallery: Bool = false
    
    var imageTapped: (String) -> Void
    
    let imageData: (Data) -> Void
    
    enum SheetType {
        case camera
        case photoAlbum
    }
    
    @ObservedObject var sheet = SheetState<UpdateMultipleImageView.SheetType>()
    
    @State var showPicker = false
    
    @State var inputImage: UIImage? = nil
    
    @State private var photoList: [PHPickerResult]?
    
    let imageColumns = [
        GridItem(.flexible(minimum: 40)),
        GridItem(.flexible(minimum: 40)),
        GridItem(.flexible(minimum: 40)),
    ]

    var body: some View {
        LazyVGrid(columns: imageColumns, alignment: .center) {
            ForEach(images, id: \.self) { image in
                KFImage(URL(string: image))
                    .resizable()
                    .cornerRadius(10.0)
                    .clipped()
                    .aspectRatio(1, contentMode: .fill)
                    .onTapGesture {
                        imageTapped(image)
                    }
                
            }
            if isEditing {
                Menu {
                    Button(action: {
                        showPicker = true
                    }) {
                        Label("Take Picture", systemImage: "camera")
                    }
                    
                    Button(action: {
                        showGallery = true
                    }) {
                        Label("Photo Gallery", systemImage: "photo.on.rectangle")
                    }

                } label: {
                    Image(systemName: "plus.square.fill")
                        .resizable()
                        .aspectRatio(1, contentMode: .fill)
                        .foregroundColor(.black)
                }
            }
        }
        .padding(.bottom)
//        .sheet(isPresented: $sheet.isShowing, onDismiss: handleDismiss) {
//            switch sheet.state {
//            case .camera:
//                ImagePicker(image: $inputImage, showCamera: $sheet.isShowing)
//            case .photoAlbum:
//                PhotoPicker(result: $photoList)
//                //ImagePicker(image: $inputImage, showCamera: .constant(false))
//            case .none: EmptyView()
//            }
//        }
        .sheet(isPresented: $showPicker, onDismiss: loadImage) {
            ImagePicker(image: $inputImage, showCamera: .constant(true))
        }
        .sheet(isPresented: $showGallery, onDismiss: loadImages) {
            PhotoPicker(result: $photoList)
        }
    }
}

extension UpdateMultipleImageView {
    func handleDismiss() {
        switch sheet.state {
        case .camera: loadImage()
        case .photoAlbum: loadImages()
        //case .photoAlbum: loadImage()
        default: break
        }
    }
    
    func loadImage() {
        guard let inputImage = inputImage,
              //let watermarkImage = inputImage.watermark(),
              let imageData = inputImage.jpegData(compressionQuality: 0.9) else { return }
        
        self.imageData(imageData)
    }
    
    func loadImages() {
        guard let results = photoList, results.count > 0 else { return }

        AssetProcessor.process(results: photoList ?? []) { data in
            self.imageData(data)
        }
    }
}

struct UpdateMultipleImageView_Previews: PreviewProvider {
    static var previews: some View {
        UpdateMultipleImageView(isEditing: true, images: .constant(["https://static.gofugyourself.com/uploads/2013/10/185512559_10-820x1292.jpg", "https://healthyceleb.com/wp-content/uploads/2015/04/Viola-Davis-during-a-casual-moment-in-New-York.jpg"]), imageTapped: { _ in }, imageData: { _ in })
            .previewLayout(.sizeThatFits)
    }
}
