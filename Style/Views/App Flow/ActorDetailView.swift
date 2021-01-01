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
                                EmptyView(image: "photo.on.rectangle.angled", title: "No Pictures", message: "Tap to add some pictures.") {
                                    sheetState = .photoAlbum
                                }
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
                                        //.scaledToFit()
                                        //.scaledToFill()
                                        .clipped()
                                        .aspectRatio(1, contentMode: .fill)
                                        .matchedGeometryEffect(id: image, in: animation)
                                        .contextMenu {
                                            Button(action: {
                                                tappedImage = image
                                                self.sheetState = .editImage
                                            }) {
                                                Image(systemName: "square.and.pencil")
                                                Text("Edit Notes")
                                            }
                                            Button(action: {
                                                tappedImage = image
                                                self.sheetState = .selectScene
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
                ActorImageView(showImage: $showImage,
                               image: tappedImage,
                               actor: currentActor,
                               viewModel: viewModel,
                               actorImage: nil,
                               animation: animation)
                    .zIndex(2)
            }
            
            UploadHUDView(progress: $uploadedCount, total: $uploadTotal)
                .zIndex(99)
                .offset(y: showHUD ? 0 : -200)
                .animation(.easeOut)
            
            MessageHUDView(message: $message)
                .zIndex(98)
                .offset(y: showMessageHUD ? 0 : -200)
                .animation(.easeOut)
        }
        //.navigationBarBackButtonHidden(showImage)
        .navigationBarTitleDisplayMode(.inline)
//        .navigationBarItems(trailing:
//            HStack {
//                if showImage {
//                    Button {
//                        sheetState = .editImage
//                    } label: {
//                        Text("Edit")
//                    }
//                    Button {
//                        withAnimation(.interactiveSpring(response: 0.5, dampingFraction: 0.8, blendDuration: 0.8)) {
//                            showImage.toggle()
//                        }
//                    } label: {
//                        Image(systemName: "xmark")
//                    }
//                } else {
//                    Button {
//                        isShowingActionSheet.toggle()
//                    } label: {
//                        Image(systemName: "plus")
//                    }
//                }
//            }
//        )
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Menu {
                    if showImage {
                        Button(action: {
                            withAnimation(.interactiveSpring(response: 0.5, dampingFraction: 0.8, blendDuration: 0.8)) {
                                showImage.toggle()
                            }
                        }) {
                            Label("Close", systemImage: "xmark")
                        }

                        Button(action: {
                            sheetState = .editImage
                        }) {
                            Label("Edit", systemImage: "pencil")
                        }
                    } else {
                        Button(action: {
                            sheetState = .camera
                        }) {
                            Label("Show Camera", systemImage: "camera")
                        }

                        Button(action: {
                            sheetState = .photoAlbum
                        }) {
                            Label("Photo Album", systemImage: "photo.on.rectangle")
                        }
                    }
                }
                label: {
                    Label(showImage ? "Options" : "Add", systemImage: showImage ? "ellipsis" : "plus")
                }
            }
        }
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
                PhotoPicker(result: $photoList)
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
        sheetState = .none
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
    let actor: Actor
    @ObservedObject var viewModel: ProjectViewModel
    
    @State var actorImage: ActorImage?
    
    @GestureState var scale: CGFloat = 1.0
    
    var animation: Namespace.ID
        
    let didSelect = PassthroughSubject<Actor, Never>()
        
    var body: some View {
        
        VStack(alignment: .leading) {
            HStack {
                KFImage(URL(string: actor.image))
                    .resizable()
                    .frame(width: 44, height: 44)
                    .clipShape(Circle())
                    .shadow(radius: 10)
                    .overlay(Circle().stroke(Color.black, lineWidth: 3))
                
                VStack(alignment: .leading) {
                    Text(actor.realName).font(.headline).bold()
                    Text(actor.screenName).font(.footnote)
                }
                
                Spacer()
                
                //Image(systemName: "ellipsis")
            }
            .frame(height: 60)
            .padding()
            
            KFImage(URL(string: image))
                .resizable()
                .scaledToFit()
                .frame(width: UIScreen.main.bounds.width)
                .matchedGeometryEffect(id: image, in: animation)
                .scaleEffect(scale)
                .gesture(MagnificationGesture()
                    .updating($scale, body: { (value, scale, trans) in
                        scale = value.magnitude
                    })
                )
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
                
            Text(createText())
                .padding(.leading)
                .padding(.bottom)
            
            Text(getRelativeDate(for: actorImage?.createdTime?.dateValue() ?? Date()))
                .font(.footnote)
                .foregroundColor(.gray)
                .padding(.leading)
                .padding(.bottom)
                
        }
        .onAppear {
            viewModel.fetchactorImageDetails(for: image) { actorImageWeb in
                actorImage = actorImageWeb
            }
        }

    }
}

extension ActorImageView {
    func createText() -> String {
        var text = ""
        
        if let top = actorImage?.top {
            text += "👕 " + top + " "
        }

        if let bottom = actorImage?.bottom {
            text += "👖 " + bottom + " "
        }

        if let shoes = actorImage?.shoes {
            text += "👞 " + shoes + " "
        }

        if let accessories = actorImage?.accessories {
            text += "💼 " + accessories + " "
        }

        if let notes = actorImage?.notes {
            text += "📝 " + notes + " "
        }
        
        return text
    }
    
    func getRelativeDate(for date: Date) -> String {
        // ask for the full relative date
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .full

        // get exampleDate relative to the current date
        let relativeDate = formatter.localizedString(for: date, relativeTo: Date())

        return relativeDate
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

struct TextEditView: View {
 
    @Binding var text: String
    var fieldToEdit: String
 
    var body: some View {
        Form {
            Section {
                VStack(alignment: .leading) {
                    Text(fieldToEdit).bold()
                    TextField(fieldToEdit, text: $text)
                        .modifier(TextFieldStyle())
                }
            }
        }
    }
}
