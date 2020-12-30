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
        
    @State private var showImagePicker: Bool = false
    
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
        GridItem(.flexible(minimum: 40)),
    ]
    
    var body: some View {
        VStack {
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
                    LazyVGrid(columns: columns, alignment: .center) {
                        ForEach(viewModel.currentActorImages, id: \.self) { image in
                            GeometryReader { gr in
                                KFImage(URL(string: image))
                                    .resizable()
                                    .scaledToFill()
                                    .frame(height: gr.size.width)
                            }
                            .clipped()
                            .aspectRatio(1, contentMode: .fit)
                        }
                    }
                    .padding(.horizontal)
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
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle(currentActor.screenName)
        .toolbar {
            ToolbarItem(placement: .bottomBar) {
                ProgressView(uploadText, value: Float(uploadedCount), total: Float(uploadTotal))
            }
        }
        .navigationBarItems(trailing:
            Menu {
//                Button {
//                    showImagePicker.toggle()
//                } label: {
//                    Image(systemName: "camera")
//                    Text("Camera")
//
//                }
                Button {
                    showImagePicker.toggle()
                } label: {
                    Image(systemName: "photo.on.rectangle")
                    Text("Photo Gallery")

                }
            } label: {
                 Image(systemName: "plus")
            }
        )
        .onAppear {
            viewModel.currentActor = currentActor
            scenes = viewModel.filterScene(for: currentActor.id ?? "")
            viewModel.getActorImages()
        }
        .sheet(isPresented: $showImagePicker, onDismiss: uploadImages) {
            PhotoPicker(result: $photoList)
        }
        
    }
}

extension ActorDetailView {
    func uploadImages() {
        guard let results = photoList, results.count > 0 else { return }
        uploadTotal = results.count
        uploadText = "Uploading..."
        AssetProcessor.process(results: photoList ?? []) { data in
            viewModel.upload(data: data, to: "images/actors/\(currentActor.id ?? "")/gallery/\(UUID().uuidString).jpg") { url in
                if let newUrl = url {
                    print("uploaded photo \(newUrl.absoluteString)")
                    uploadedCount += 1
                    if uploadedCount == uploadTotal {
                        uploadText = ""
                        uploadedCount = 0
                    }
                }
            }
        }
    }
    
}
