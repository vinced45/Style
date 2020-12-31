//
//  ActorDetailView.swift
//  Style
//
//  Created by Vince Davis on 12/29/20.
//

import SwiftUI
import Photos
import PhotosUI
import KingfisherSwiftUI

struct ActorDetailView: View {
    @ObservedObject var viewModel: ProjectViewModel
    var currentActor: Actor
    
    @State var scenes: [MovieScene] = []
    
    @Namespace private var animation
    @State var showImage: Bool = false
    @State var tappedImage: String = ""
    @State var selectedSceneId: String = ""
        
    @State private var showHUD = false
    
    @State var isLoading: Bool = false
    
    @State var message: String = ""
    @State private var showMessageHUD = false
    
    enum SheetState {
        case none
        case camera
        case photoAlbum
        case editImage
        case selectScene
        case addToScene
    }
    
    @State var isShowingSheet = false
    @State var sheetState = SheetState.none {
        willSet {
            isShowingSheet = newValue != .none
        }
    }
    
    @State var isShowingActionSheet = false
        
    @State private var inputImage: UIImage? = nil
    
    @State private var photoList: [PHPickerResult]?
    @State private var uploadedCount: Int = 0
    @State private var uploadTotal: Int = 0
    @State private var uploadText = ""
    
    @State var choice = 0
    var settings = ["Pre Production", "Scenes"]
    
    let data = (0...4).map { "viola-\($0)" }

    let columns = [
        GridItem(.flexible(minimum: 40)),
        GridItem(.flexible(minimum: 40)),
        GridItem(.flexible(minimum: 40)),
    ]
    
    var body: some View {
        ZStack(alignment: .top) {
            VStack {
                HStack {
                    KFImage(URL(string: currentActor.image))
                        .resizable()
                        .frame(width: 88, height: 88)
                        .clipShape(Circle())
                        .shadow(radius: 10)
                        .overlay(Circle().stroke(Color.black, lineWidth: 3))
                        
                    VStack {
                        VStack(alignment: .leading) {
                            Text(currentActor.realName)
                            Text(currentActor.screenName).font(.subheadline).foregroundColor(.gray)
                        }
                    }
                    
                    Spacer()
                }
                .padding()
                
                Picker("Options", selection: $choice) {
                    ForEach(0 ..< settings.count) { index in
                        Text(self.settings[index])
                            .tag(index)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()
                
                ScrollView {
                    if choice == 0 {
                        if viewModel.currentActorImages.count == 0 {
                            //EmptyView(image: "photo.on.rectangle.angled", title: "No Pictures", message: "Please add some pictures.")
                            if isLoading {
                                Spacer(minLength: 100)
                                LoadingCircleView().frame(width: 100, height: 100, alignment: .center)
                            } else {
                                Spacer(minLength: 100)
                                EmptyView(image: "photo.on.rectangle.angled", title: "No Pictures", message: "Please add some pictures.")
                            }
                            
                            //LoadingLineView()
                        } else {
                            LazyVGrid(columns: columns, alignment: .center) {
                                ForEach(viewModel.currentActorImages, id: \.self) { image in
                                    KFImage(URL(string: image))
                                        .placeholder {
                                            Image(systemName: "photo.on.rectangle.angled")
                                                .resizable()
                                                .frame(width: 80.0, height: 80.0)
                                                //.renderingMode(.template)
                                                .colorMultiply(.gray)
                                        }
                                        .resizable()
                                        .clipped()
                                        .aspectRatio(1, contentMode: .fill)
                                        .matchedGeometryEffect(id: image, in: animation)
                                        .contextMenu {
                                            Button(action: {
                                                tappedImage = image
                                                sheetState = .editImage
                                            }) {
                                                Image(systemName: "square.and.pencil")
                                                Text("Edit Notes")
                                            }
                                            Button(action: {
                                                tappedImage = image
                                                sheetState = .selectScene
                                            }) {
                                                Image(systemName: "film")
                                                Text("Add to Scene")
                                            }
                                            
                                        }
                                        .onTapGesture {
                                            withAnimation(.interactiveSpring(response: 0.5, dampingFraction: 0.8, blendDuration: 0.8)) {
                                                tappedImage = image
                                                showImage.toggle()
                                            }
                                        }
                                }
                            }
                            //.padding(.horizontal)
                        }
                        
                    } else {
                        ForEach(scenes) { scene in
                            NavigationLink(destination: SceneDetailView(viewModel: viewModel, currentScene: scene)) {
                                HStack {
                                    Image(systemName: "film")
                                        .resizable()
                                        .frame(width: 44, height: 44)
                                        .foregroundColor(.black)
                                    VStack(alignment: .leading) {
                                        Text(scene.name)
                                            .bold()
                                            .foregroundColor(.black)
                                        
                                        Text("Actors in Scene: \(scene.actors.count)")
                                            .font(.subheadline)
                                            .foregroundColor(.gray)
                                    }
                                    Spacer()
                                }
                                .padding()
                                .frame(height: 60)
                            }
                        }
                    }
                }
            }
            .opacity(showImage ? 0 : 1)
            .zIndex(1)
            
            if showImage {
                ActorImageView(showImage: $showImage, image: tappedImage, viewModel: viewModel, actorImage: nil, animation: animation)
                    .zIndex(2)
            }
            
            UploadHUDView(progress: $uploadedCount, total: $uploadTotal)
                .zIndex(99)
                .offset(y: showHUD ? 0 : -100)
                .animation(.easeOut)
            
            MessageHUDView(message: $message)
                .zIndex(98)
                .offset(y: showMessageHUD ? 0 : -100)
                .animation(.easeOut)
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarItems(trailing:
            HStack {
                if showImage {
                    Button {
                        sheetState = .editImage
                    } label: {
                        Text("Edit")
                    }
                    Button {
                        withAnimation(.interactiveSpring(response: 0.5, dampingFraction: 0.8, blendDuration: 0.8)) {
                            showImage.toggle()
                        }
                    } label: {
                        Image(systemName: "xmark")
                    }
                } else {
                    Button {
                        isShowingActionSheet.toggle()
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
        )
        .onAppear {
            viewModel.currentActor = currentActor
            scenes = viewModel.filterScene(for: currentActor.id ?? "")
            viewModel.getActorImages()
        }
        .sheet(isPresented: $isShowingSheet, onDismiss: handleImage) {
            switch sheetState {
            case .camera: ImagePicker(image: $inputImage, showCamera: $isShowingSheet)
            case .photoAlbum: PhotoPicker(result: $photoList)
            case .editImage: ImageEditView(showSheet: $isShowingSheet, image: tappedImage, actorId: currentActor.id ?? "", viewModel: viewModel)
            case .selectScene:
                SceneListView(showSheet: $isShowingSheet, scenes: scenes) { selectedScene in
                    print("got scene \(selectedScene.id ?? "")-\(currentActor.id ?? "")")
                    let sceneActor = SceneActor(id: nil,
                                                sceneActorId: "\(selectedScene.id ?? "")-\(currentActor.id ?? "")",
                                                name: "",
                                                top: "",
                                                bottom: "",
                                                shoes: "",
                                                accessories: "",
                                                notes: "",
                                                beforeLook: false,
                                                image: tappedImage,
                                                createdTime: nil)
                    viewModel.currentSceneActor = sceneActor
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        sheetState = .addToScene
                    }
                }
            case .addToScene:
                AddSceneActorView(showSheet: $isShowingSheet, viewModel: viewModel)
            case .none:
                AddSceneActorView(showSheet: $isShowingSheet, viewModel: viewModel)
            }
        }
        .actionSheet(isPresented: $isShowingActionSheet, content: {
            ActionSheet(title: Text("Picture Actions"), message: nil, buttons: [
                            .default(Text(Image(systemName: "camera")) + Text(" Take Picture") , action: {
                                sheetState = .camera
                            }),
                            .default(Text(Image(systemName: "photo.on.rectangle")) + Text(" Photo Album") , action: {
                                sheetState = .photoAlbum
                            }),
                            .cancel()
            ])
        })
        .onReceive(viewModel.message) { msg in
            self.message = msg
            showMessageHUD = true
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                showMessageHUD = false
            }
        }
        .onReceive(viewModel.loading) { loading in
            self.isLoading = loading
        }
    }
}

extension ActorDetailView {
    func handleImage() {
        switch sheetState {
        case .camera: uploadImage()
        case .photoAlbum: uploadImages()
        default: break
        }
    }
    
    func uploadImage() {
        guard let inputImage = inputImage,
              let imageData = inputImage.jpegData(compressionQuality: 0.9) else { return }
        
        showHUD = true
        
        viewModel.upload(data: imageData, to: "images/actors/\(currentActor.id ?? "")/gallery/\(UUID().uuidString).jpg") { url in
            guard let imageUrl = url else { return }
            print("url: \(imageUrl.absoluteString)")
            //imageUrlString = imageUrl.absoluteString
            showHUD = false
            viewModel.getActorImages()
            viewModel.message.send("Image Uploaded")
        }
    }
    
    func uploadImages() {
        guard let results = photoList, results.count > 0 else { return }
        
        showHUD = true
        
        uploadTotal = results.count
        uploadText = "Uploading..."
        AssetProcessor.process(results: photoList ?? []) { data in
            viewModel.upload(data: data, to: "images/actors/\(currentActor.id ?? "")/gallery/\(UUID().uuidString).jpg") { url in
                if let newUrl = url {
                    //print("uploaded photo \(newUrl.absoluteString)")
                    uploadedCount += 1
                    if uploadedCount == uploadTotal {
                        uploadText = ""
                        uploadedCount = 0
                        uploadTotal = 0
                        showHUD = false
                        viewModel.getActorImages()
                        viewModel.message.send("Images Uploaded")
                    }
                }
            }
        }
    }
    
}

import SwiftUI
import KingfisherSwiftUI
import Combine

struct ActorImageView: View {
    @Binding var showImage: Bool
    let image: String
    @ObservedObject var viewModel: ProjectViewModel
    
    @State var actorImage: ActorImage?
    
    @GestureState var scale: CGFloat = 1.0
    
    var animation: Namespace.ID
        
    let didSelect = PassthroughSubject<Actor, Never>()
        
    var body: some View {
        VStack {
            KFImage(URL(string: image))
                .resizable()
                //.frame(width: 65, height: 65)
                .aspectRatio(contentMode: .fit)
                //.padding(.all, 5.0)
                .matchedGeometryEffect(id: image, in: animation)
                //.cornerRadius(15)
                .scaleEffect(scale)
                .gesture(MagnificationGesture()
                    .updating($scale, body: { (value, scale, trans) in
                        scale = value.magnitude
                    })
                )
//                .onTapGesture {
//                    withAnimation(.interactiveSpring(response: 0.5, dampingFraction: 0.8, blendDuration: 0.8)) {
//                        showImage = false
//                    }
//                }
                .gesture(
                    DragGesture(minimumDistance: 3.0)
                            .onEnded { value in
                                if value.translation.height > 0 && value.translation.width < 100 && value.translation.width > -100 {
                                        print("down swipe")
                                    withAnimation(.interactiveSpring(response: 0.5, dampingFraction: 0.8, blendDuration: 0.8)) {
                                        showImage = false
                                    }
                                    }
                            }
                    )
                                 
            List {
                HStack(alignment: .top) {
                    Text("Top").bold()
                    Spacer()
                    Text(actorImage?.top ?? "")
                }
                
                HStack(alignment: .top) {
                    Text("Bottom").bold()
                    Spacer()
                    Text(actorImage?.bottom ?? "")
                }
                
                HStack(alignment: .top) {
                    Text("Shoes").bold()
                    Spacer()
                    Text(actorImage?.shoes ?? "")
                }
                
                HStack(alignment: .top) {
                    Text("Accessories").bold()
                    Spacer()
                    Text(actorImage?.accessories ?? "")
                }
                
                HStack(alignment: .top) {
                    Text("Notes").bold()
                    Spacer()
                    Text(actorImage?.notes ?? "")
                }
            }
        }
        .onAppear {
            viewModel.fetchactorImageDetails(for: image) { actorImageWeb in
                actorImage = actorImageWeb
            }
        }

    }
}

struct LoadingCircleView: View {
 
    @State private var isLoading = false
 
    var body: some View {
        ZStack {
 
            Circle()
                .stroke(Color(.systemGray5), lineWidth: 14)
                .frame(width: 80, height: 80)
 
            Circle()
                .trim(from: 0, to: 0.2)
                .stroke(Color("bg1"), lineWidth: 7)
                .frame(width: 80, height: 80)
                .rotationEffect(Angle(degrees: isLoading ? 360 : 0))
                .animation(Animation.linear(duration: 1).repeatForever(autoreverses: false))
                .onAppear() {
                    self.isLoading = true
            }
        }
    }
}

struct LoadingLineView: View {
 
    @State private var isLoading = false
 
    var body: some View {
        ZStack {
 
            Text("Loading")
                .font(.system(.body, design: .rounded))
                .bold()
                .offset(x: 0, y: -25)
 
            RoundedRectangle(cornerRadius: 3)
                .stroke(Color(.systemGray5), lineWidth: 3)
                .frame(width: 250, height: 3)
 
            RoundedRectangle(cornerRadius: 3)
                .stroke(Color("bg1"), lineWidth: 3)
                .frame(width: 30, height: 3)
                .offset(x: isLoading ? 110 : -110, y: 0)
                .animation(Animation.linear(duration: 1).repeatForever(autoreverses: false))
        }
        .onAppear() {
            self.isLoading = true
        }
    }
}
