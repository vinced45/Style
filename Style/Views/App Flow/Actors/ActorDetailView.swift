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
    @State var currentActor: Actor
    
    @State var scenes: [MovieScene] = []
    
    @Namespace private var animation
    @State var showImage: Bool = false
    @State var tappedImage: String = ""
    @State var selectedSceneId: String = ""
        
    @State private var showHUD = false
    
    @State var isLoading: Bool = false
    
    @State var message: String = ""
    @State private var showMessageHUD = false
    
    enum SheetType {
        case camera
        case photoAlbum
        case editImage
        case editImage2
        case selectScene
        case addToScene
        case editNote
        case addLook
        case updateActor
    }
    
    @ObservedObject var sheet = SheetState<ActorDetailView.SheetType>()
    
    @State var isShowingActionSheet = false
        
    @State private var inputImage: UIImage? = nil
    
    @State private var photoList: [PHPickerResult]?
    @State private var uploadedCount: Int = 0
    @State private var uploadTotal: Int = 0
    @State private var uploadText = ""
    
    @State var choice = 0
    var settings = ["Pre Prod", "Scenes", "Looks", "Notes"]
    
    @State var listChoice = 0
    var listType = ["square.grid.3x3.fill", "photo.fill"]
    
    @State var deptChoice = 0
    var deptType = ["All", "Wardrobe", "Hair", "Make Up", "Props"]
    
    let data = (0...4).map { "viola-\($0)" }

    let gridColumns = [
        GridItem(.flexible(minimum: 40)),
        GridItem(.flexible(minimum: 40)),
        GridItem(.flexible(minimum: 40)),
    ]
    
    let oneColumn = [
        GridItem(.flexible(minimum: 40)),
    ]
    
    let emptySpacerHeight: CGFloat = 100.0
    
    var body: some View {
        ZStack(alignment: .top) {
            VStack {
                ActorProfileView(actor: currentActor)
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
                    if choice == 0 /* Pre Prod */ {
                        if viewModel.currentActorImages.count == 0 {
                            Spacer(minLength: emptySpacerHeight)
                            if isLoading {
                                LoadingCircleView().frame(width: 100, height: 100, alignment: .center)
                            } else {
                                EmptyIconView(type: .photo) {
                                    self.sheet.state = .photoAlbum
                                }
                            }
                        } else {
                            Picker("Dept", selection: $deptChoice) {
                                ForEach(0 ..< deptType.count) { index in
                                    Text(self.deptType[index])
                                        .tag(index)
                                }
                            }
                            .pickerStyle(SegmentedPickerStyle())
                            .padding(.leading)
                            .padding(.trailing)
                            
                            Picker("List Type", selection: $listChoice) {
                                ForEach(0 ..< listType.count) { index in
                                    Image(systemName: self.listType[index])
                                        .tag(index)
                                }
                            }
                            .pickerStyle(SegmentedPickerStyle())
                            .padding(.leading)
                            .padding(.trailing)
                            
                            if listChoice == 0 {
                                LazyVGrid(columns: gridColumns, alignment: .center) {
                                    ForEach(viewModel.currentActorImages, id: \.self) { image in
                                        KFImage(URL(string: image))
                                            .placeholder {
                                                Image(systemName: "photo.on.rectangle.angled")
                                                    .resizable()
                                                    
                                                    .frame(width: 80.0, height: 80.0)
                                                    .colorMultiply(.gray)
                                            }
                                            .resizable()
                                            
                                            .scaledToFill()
                                            .frame(width: UIScreen.main.bounds.width / 3, height: UIScreen.main.bounds.width / 3)
                                            //.aspectRatio(1, contentMode: .fill)
                                            .clipped()
                                            .matchedGeometryEffect(id: image, in: animation)
                                            .contextMenu {
                                                Button(action: {
                                                    tappedImage = image
                                                    self.sheet.state = .editImage
                                                }) {
                                                    Image(systemName: "square.and.pencil")
                                                    Text("Edit Notes")
                                                }
                                                Button(action: {
                                                    tappedImage = image
                                                    self.sheet.state = .selectScene
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
                            else {
                                LazyVGrid(columns: oneColumn, alignment: .center) {
                                    ForEach(viewModel.currentActorImages, id: \.self) { image in
                                        ImageUploadView(image: image)
                                    }
                                }
                            }
                        }
                        
                    } else if choice == 1 /* Scenes */ {
                        if scenes.count == 0 {
                            Spacer(minLength: emptySpacerHeight)
                            EmptyIconView(type: .scene) {}
                        } else {
                            ForEach(scenes) { scene in
                                NavigationLink(destination: SceneDetailView(viewModel: viewModel, currentScene: scene)) {
                                    VStack(alignment: .leading) {
                                        HStack {
                                            ImageTextRowView(config: scene)
                                                .padding()
                                                .frame(height: 60)
                                                .foregroundColor(.black)
                                            
                                            Spacer()
                                            
                                            Image(systemName: "chevron.right")
                                                .padding()
                                                .foregroundColor(.black)
                                        }
                                    }
                                }
                            }
                        }
                    } else if choice == 2 /* Looks */ {
                        if viewModel.actorLooks.count == 0 {
                            Spacer(minLength: emptySpacerHeight)
                            EmptyIconView(type: .actorLook) {
                                self.sheet.state = .addLook
                            }
                        } else {
                            ForEach(viewModel.actorLooks) { actorLook in
                                VStack(alignment: .leading) {
                                    HStack {
                                        Group {
                                            ActorLookView(actorLook: actorLook)
                                                .padding()
                                                .frame(height: 80)
                                                .foregroundColor(.black)
                                                
                                            Spacer()
                                        }.onTapGesture {
                                            viewModel.update(object: actorLook,
                                                             with: ["completed": !actorLook.completed,
                                                                    "lastUpdated": Date()])
                                            
                                            viewModel.fetchActorLooks(for: currentActor.id ?? "")
                                        }

                                        NavigationLink(destination: EditActorLookView(actorLook: actorLook, viewModel: viewModel)) {
                                            Image(systemName: "info.circle")
                                                .padding()
                                                .foregroundColor(.blue)
                                        }
                                        
                                    }
                                }
                                
                            }
                        }
                    }  else if choice == 3 /* Notes */ {
                        if viewModel.notes.count == 0 {
                            Spacer(minLength: emptySpacerHeight)
                            EmptyIconView(type: .note) {
                                self.sheet.state = .editNote
                            }
                        } else {
                            ForEach(viewModel.notes) { note in
                                NavigationLink(destination: EditNoteView(note: note, viewModel: viewModel)) {
                                    VStack(alignment: .leading) {
                                        HStack {
                                            ImageTextRowView(config: note)
                                                .padding()
                                                //.frame(height: 60)
                                                .foregroundColor(.black)
                                            
                                            Spacer()
                                            
                                            Image(systemName: "chevron.right")
                                                .padding()
                                                .foregroundColor(.black)
                                        }
                                    }
                                }
                            }
                        }
                    } else { }
                }
            }
            .opacity(showImage ? 0 : 1)
            .zIndex(1)
            
            if showImage {
                IGView(showImage: $showImage, //sheetState: self.$sheet.state,
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
        .navigationBarItems(trailing:
            HStack {
                if showImage {
                    Button {
                        showImage = false
                        self.sheet.state = .editImage
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
                        Image(systemName: "ellipsis")
                    }
                }
            }
        )
        .onAppear {
            viewModel.currentActor = currentActor
            scenes = viewModel.filterScene(for: currentActor.id ?? "")
            viewModel.getActorImages()
            viewModel.fetchNotes(for: currentActor.id ?? "")
            viewModel.fetchActorLooks(for: currentActor.id ?? "")
        }
        .sheet(isPresented: self.$sheet.isShowing, onDismiss: handleDismiss) {
            sheetContent()
        }
        .actionSheet(isPresented: $isShowingActionSheet, content: {
            ActionSheet(title: Text("Actions"),
                        message: nil,
                        buttons: [
                            .default(Text(Image(systemName: "person")) + Text("Update Actor") , action: {
                                self.sheet.state = .updateActor
                            }),
                            .default(Text(Image(systemName: "camera")) + Text("Take Picture") , action: {
                                self.sheet.state = .camera
                            }),
                            .default(Text(Image(systemName: "photo.on.rectangle")) + Text("Add Pic from Photo Albnum") , action: {
                                self.sheet.state = .photoAlbum
                            }),
                            .default(Text(Image(systemName: "binoculars")) + Text("Add Look") , action: {
                                self.sheet.state = .addLook
                            }),
                            .default(Text(Image(systemName: "note.text")) + Text("Add Note") , action: {
                                self.sheet.state = .editNote
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
    @ViewBuilder
    private func sheetContent() -> some View {
        switch self.sheet.state {
        case .camera:
            ImagePicker(image: $inputImage, showCamera: self.$sheet.isShowing)
        case .photoAlbum:
            PhotoPicker(result: $photoList)
        case .editImage, .editImage2:
            ImageEditView(showSheet: self.$sheet.isShowing, image: tappedImage, actorId: currentActor.id ?? "", viewModel: viewModel)
        case .selectScene:
            SceneListView(showSheet: self.$sheet.isShowing, scenes: scenes, image: tappedImage, viewModel: viewModel)
        case .addToScene:
            AddSceneActorView(showSheet: self.$sheet.isShowing, viewModel: viewModel)
        case .editNote:
            AddNoteView(showSheet: self.$sheet.isShowing, note: viewModel.currentNote, viewModel: viewModel)
        case .addLook:
            AddActorLookView(showSheet: self.$sheet.isShowing, viewModel: viewModel)
        case .updateActor:
            UpdateActorView(showSheet: $sheet.isShowing, actor: $currentActor, viewModel: viewModel)
        case .none:
            EmptyView()
        }
    }
    
    func handleDismiss() {
        guard let sheetState = self.sheet.state else { return }
        
        switch sheetState {
        case .camera: uploadImage()
        case .photoAlbum: uploadImages()
        case .editNote: viewModel.fetchNotes(for: currentActor.id ?? "")
        case .addLook: viewModel.fetchActorLooks(for: currentActor.id ?? "")
        default: break
        }
    }
    
    func uploadImage() {
        guard let inputImage = inputImage,
              let imageData = inputImage.jpegData(compressionQuality: 0.9) else { return }
        
        showHUD = true
        
        viewModel.upload(data: imageData, to: "images/actors/\(currentActor.id ?? "")/gallery/\(UUID().uuidString).jpg") { url in
            guard url != nil else { return }
            
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
                if url != nil {
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

struct ActorDetailView_Previews: PreviewProvider {
    static var previews: some View {
        ActorDetailView(viewModel: ProjectViewModel.preview(), currentActor: Actor.preview())
    }
}
