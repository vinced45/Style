//
//  BulkImageUploadView.swift
//  Scene Me
//
//  Created by Vince Davis on 3/10/21.
//

import SwiftUI
import Kingfisher
import AlertToast

struct BulkImageUploadView: View {
    @Binding var showSheet: Bool
    @State var actor: Actor
    @State var sceneIDs: [String]
    @ObservedObject var viewModel: ProjectViewModel
    
    @State var sceneImages: [String] = []
    
    @State var isImagesExpanded = true
    @State var isScenesExpanded = true
    @State var isDetailsExpanded = true
    
    @State var notes: String = ""
    
    @State var deptChoice = 0
    var deptType = ["Wardrobe", "Hair", "Make Up", "Props"]
    
    @State var showToast: Bool = false
    
    var body: some View {
        NavigationView {
            ZStack {
                SlantedBackgroundView()
                    .zIndex(1.0)
                
                List {
                    Section(header: Text("Department"), footer: Text("Select Dept for Image(s)")) {
                        Picker("Dept", selection: $deptChoice) {
                            ForEach(0 ..< deptType.count) { index in
                                Text(self.deptType[index])
                                    .tag(index)
                            }
                        }
                        .pickerStyle(SegmentedPickerStyle())
                        .padding(.leading)
                        .padding(.trailing)
                    }
                    
                    Section {
                        DisclosureGroup(isExpanded: $isImagesExpanded) {
                            UpdateMultipleImageView(isEditing: true, images: $sceneImages, imageTapped: { _ in }, imageData: { imageData in
                                showToast = true
                                upload(imageData: imageData)
                            })
                            .toast(isPresenting: $showToast) {
                                //AlertToast(type: .regular, title: "Uploading Image")
                                AlertToast(type: .loading, title: "Please Wait", subTitle: "Uploading Images")
                                //Choose .hud to toast alert from the top of the screen
                                //AlertToast(displayMode: .hud, type: .regular, title: "Uploading Image")
                            }
                        } label: {
                            Text("Images (\(sceneImages.count))")
                                .font(.headline)
                                .onTapGesture {
                                    isImagesExpanded.toggle()
                                }
                        }
                        
//                        NavigationLink(destination: Text("Fix Me")) {
//                            Text("List Images")
//                        }
                    }
                    
                    
                    
                    if actor.id ?? "" == "1111" {
                        Section(header: Text("Actor"), footer: Text("Tap to update Actor for scene")) {
                            NavigationLink(destination: ActorListView(actor: $actor, viewModel: viewModel)) {
                                HStack {
                                    KFImage(URL(string: actor.image))
                                        .resizable()
                                        .frame(width: 44, height: 44)
                                        .clipShape(Circle())
                                        .shadow(radius: 10)
                                        .overlay(Circle().stroke(Color.black, lineWidth: 3))
                                    VStack(alignment: .leading) {
                                        Text(actor.realName)
                                        Text(actor.screenName).font(.subheadline).foregroundColor(.gray)
                                    }
                                }
                                .frame(height: 60)
                            }
                        }
                    }
                    
                    Section(header: Text("Notes")) {
                        TextView(text: $notes, textStyle: .callout)
                            .modifier(TextViewStyle())
                            .frame(height: 100)
                    }
                    
                    Section {
                        DisclosureGroup(isExpanded: $isScenesExpanded) {
                            ForEach(viewModel.scenes) { scene in
                                HStack {
                                    ImageTextRowView(config: scene)
                                    
                                    Spacer()
                                    
                                    Image(systemName: (sceneIDs.contains(scene.id ?? "")) ? "checkmark.rectangle" : "rectangle")
                                        .resizable()
                                        .frame(width: 30, height: 30, alignment: .center)
                                }
                                .onTapGesture {
                                    toggle(scene: scene)
                                }
                            }
                        } label: {
                            Text("Scenes (\(sceneIDs.count))")
                                .font(.headline)
                                .onTapGesture {
                                    isScenesExpanded.toggle()
                                }
                        }
                    }
                }
                .listStyle(InsetGroupedListStyle())
                .zIndex(2.0)
                .padding(.top, 50)
                
            }
            .navigationBarTitle(Text("Add Image(s)"), displayMode: .inline)
            .navigationBarItems(leading: Button(action: {
                showSheet = false
            }) {
                Text("Cancel").bold()
            }, trailing: Button(action: {
               addImages()
            }) {
                Text("Save").bold()
            })
        }
    }
}

extension BulkImageUploadView {
    func addImages() {
        for image in sceneImages {
            let projectImage = ProjectImage(id: nil,
                                            projectId: viewModel.currentProject?.id ?? "",
                                            actorIds: [actor.id ?? ""],
                                            sceneIds: sceneIDs,
                                            deptId: (deptChoice + 1),
                                            notes: notes,
                                            image: image,
                                            createdTime: nil)
            viewModel.add(object: projectImage) { _ in }
        }
        showSheet = false
    }
    
    func upload(imageData: Data) {
        viewModel.upload(data: imageData, to: "images/actors/\(actor.id ?? "")/gallery/\(deptChoice)/\(UUID().uuidString).jpg") { url in
            guard let imageUrl = url else { return }
            showToast = false
            self.sceneImages.append(imageUrl.absoluteString)
        }
    }
    
    func toggle(scene: MovieScene) {
        if sceneIDs.contains(scene.id ?? "") {
            sceneIDs.removeAll(where: { $0 == scene.id ?? "" })
        }
        else {
            sceneIDs.append(scene.id ?? "")
        }
    }
}

struct BulkImageUploadView_Previews: PreviewProvider {
    static var previews: some View {
        BulkImageUploadView(showSheet: .constant(true),
                            actor: Actor.preview(),
                            sceneIDs: [MovieScene.preview().id ?? ""],
                            viewModel: ProjectViewModel.preview())
    }
}
