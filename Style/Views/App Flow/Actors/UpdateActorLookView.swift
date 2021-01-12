//
//  UpdateActorLookView.swift
//  Style
//
//  Created by Vince Davis on 1/11/21.
//

import SwiftUI

struct AddActorLookView: View {
    @Binding var showSheet: Bool

    @ObservedObject var viewModel: ProjectViewModel
    
    @EnvironmentObject var session: SessionStore

    @State var text: String = ""

    @State var imageUrlString: String = ""

    var body: some View {
        NavigationView {
            Form {
                Section {
                    UpdateImageView() { imageData in
                        self.viewModel.upload(data: imageData, to: "image/\(UUID().uuidString).jpg") { url in
                            guard let imageUrl = url else { return }
                            
                            imageUrlString = imageUrl.absoluteString
                        }
                    }
                }
                
                Section {
                    FormTextFieldView(name: "Description", placeholder: "Description of Look", text: $text)
                }
            }
            .navigationBarTitle(Text("Add Look"), displayMode: .inline)
                .navigationBarItems(leading: Button(action: {
                    self.showSheet = false
                }) {
                    Text("Cancel").bold()
                }, trailing: Button(action: {
                    let newActorLook = ActorLook(id: nil,
                                                 actorId: viewModel.currentActor?.id ?? "",
                                                 image: imageUrlString,
                                                 text: text,
                                                 completed: false,
                                                 creatorId: session.session?.uid ?? "",
                                                 lastUpdated: Date(),
                                                 createdTime: nil)
                    self.viewModel.add(object: newActorLook)
                    self.showSheet = false
                }) {
                    Text("Save").bold()
                })
        }
    }
}

extension AddActorLookView {
    
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
    
    @State var imageUrlString: String = ""
    
    var body: some View {
        Form {
            Section {
                UpdateImageView(imageUrl: actorLook.image) { imageData in
                    self.viewModel.upload(data: imageData, to: "image/\(UUID().uuidString).jpg") { url in
                        guard let imageUrl = url else { return }
                        
                        imageUrlString = imageUrl.absoluteString
                    }
                }
            }
            
            Section {
                FormTextFieldView(name: "Description", placeholder: "Description of Look", text: $text)
            }
        }
        .navigationBarTitle(Text("Edit Look"), displayMode: .inline)
        .onAppear {
            imageUrlString = actorLook.image
            text = actorLook.text
        }
        .navigationBarItems(trailing: Button(action: {
                viewModel.update(object: actorLook, with: ["text": text, "image" : imageUrlString])
                //viewModel.fetchNotes(for: viewModel.currentActor.id ?? "")
                self.presentationMode.wrappedValue.dismiss()
            }) {
                Text("Save").bold()
            })
    }
}

//struct EditActorLookView_Previews: PreviewProvider {
//    static var previews: some View {
//        EditActorLookView(showSheet: .constant(true), viewModel: ProjectViewModel.preview())
//    }
//}
