//
//  EditNoteView.swift
//  Style
//
//  Created by Vince Davis on 1/5/21.
//

import SwiftUI

struct EditNoteView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var note: Note?
    
    @ObservedObject var viewModel: ProjectViewModel
    
    @State var text: String = ""
    
    var body: some View {
        ZStack {
            SlantedBackgroundView()
                .zIndex(1.0)
            
            VStack(alignment: .leading) {
                Text("Note")
                TextView(text: $text, textStyle: .callout)
                    .modifier(TextViewStyle())
                    .frame(height: 200)
                Spacer()
            }
            .padding(30)
            .zIndex(2.0)
            .padding(.top, 80)
        }
        .navigationBarTitle(Text("Edit Note"), displayMode: .inline)
        .navigationBarItems(trailing: Button(action: {
            if let newNote = note {
                viewModel.update(object: newNote, with: ["text": text, "lastUpdated": Date()])
                //viewModel.fetchNotes(for: viewModel.currentActor.id ?? "")
                self.presentationMode.wrappedValue.dismiss()
                
            }
            }) {
            Text("Save").bold()
            })
        .onAppear {
            guard let newText = note?.text else { return }
            
            text = newText
        }
    }
}

struct AddNoteView: View {
    @Binding var showSheet: Bool
    
    var note: Note?
    
    @ObservedObject var viewModel: ProjectViewModel
    
    @EnvironmentObject var session: SessionStore
    
    @State var text: String = ""
    
    var body: some View {
        NavigationView {
            ZStack {
                SlantedBackgroundView()
                    .zIndex(1.0)
                
                VStack(alignment: .leading) {
                    Text("Note").bold()
                    TextView(text: $text, textStyle: .callout)
                        .modifier(TextViewStyle())
                        .frame(height: 200)
                    Spacer()
                }
                .padding(30)
                .zIndex(2.0)
            }
            .navigationBarTitle(Text("Add Note"), displayMode: .inline)
            .navigationBarItems(leading: Button(action: {
                    showSheet = false
                }) {
                    Text("Cancel").bold()
                }, trailing: Button(action: {
                    if let author = viewModel.currentActor,
                       let id = author.id {
                        let note = Note(id: nil,
                                        actorId: id,
                                        text: text,
                                        creatorId: session.session?.uid ?? "",
                                        lastUpdated: Date(),
                                        createdTime: nil)
                        viewModel.add(object: note) { _ in }
                    }
                    showSheet = false
                }) {
                    Text("Save").bold()
                })
        }
        .onAppear {
            guard let newText = note?.text else { return }
            
            text = newText
        }
    }
}

struct EditNoteView_Previews: PreviewProvider {
    static var previews: some View {
        EditNoteView(note: Note.preview(), viewModel: ProjectViewModel.preview())
    }
}
