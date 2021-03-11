//
//  ImageEditView.swift
//  Style
//
//  Created by Vince Davis on 12/30/20.
//

import SwiftUI

import SwiftUI
import KingfisherSwiftUI

struct ImageEditView: View {
    @Binding var showSheet: Bool
    var image: String
    var actorId: String
    
    @ObservedObject var viewModel: ProjectViewModel

    @State private var nameOfLook: String = ""
    @State private var top: String = ""
    @State private var bottom: String = ""
    @State private var shoes: String = ""
    @State private var accessories: String = ""
    @State private var notes: String = ""
            
    var body: some View {
        NavigationView {
            Form {
                Section {
                    HStack{
                        Spacer()
                        VStack {
                            KFImage(URL(string: image))
                                .resizable()
                                .frame(height: 250)
                                .aspectRatio(1, contentMode: .fit)
                        }
                        Spacer()
                    }
                }
                
                Section(header: Text("Details")) {
                    VStack(alignment: .leading) {
                        Text("Name of Look").bold()
                        TextField("Name of Look", text: $nameOfLook)
                            .modifier(TextFieldStyle())
                    }
                    
                    VStack(alignment: .leading) {
                        Text("Top").bold()
                        TextField("Top", text: $top)
                            .modifier(TextFieldStyle())
                    }
                    
                    VStack(alignment: .leading) {
                        Text("Bottom").bold()
                        TextField("Bottom", text: $bottom)
                            .modifier(TextFieldStyle())
                    }
                    
                    VStack(alignment: .leading) {
                        Text("Shoes").bold()
                        TextField("Shoes", text: $shoes)
                            .modifier(TextFieldStyle())
                    }
                    
                    VStack(alignment: .leading) {
                        Text("Accessories").bold()
                        TextField("Accessories", text: $accessories)
                            .modifier(TextFieldStyle())
                    }
                    
                    VStack(alignment: .leading) {
                        Text("Notes").bold()
                        //TextField("Notes", text: $notes)
                        TextView(text: $notes, textStyle: .callout)
                            .modifier(TextFieldStyle())
                            .frame(height: 100)
                    }
                }
            }
            .navigationBarTitle(Text("Add Image Details"), displayMode: .inline)
            .navigationBarItems(leading: Button(action: {
                self.showSheet = false
            }) {
                Text("Cancel").bold()
            }, trailing: Button(action: {
                AddImageDetails()
            }) {
                Text("Save").bold()
            })
            .onAppear {
                viewModel.fetchactorImageDetails(for: image) { foundActorImage in
                    nameOfLook = foundActorImage?.name ?? ""
                    top = foundActorImage?.top ?? ""
                    bottom = foundActorImage?.bottom ?? ""
                    shoes = foundActorImage?.shoes ?? ""
                    accessories = foundActorImage?.accessories ?? ""
                    notes = foundActorImage?.notes ?? ""
                }
            }

        }
    }
}

extension ImageEditView {
    func AddImageDetails() {
        let imageObj = ActorImage(id: nil,
                                  actorId: actorId,
                                  name: nameOfLook,
                                  top: top,
                                  bottom: bottom,
                                  shoes: shoes,
                                  accessories: accessories,
                                  notes: notes,
                                  image: image,
                                  createdTime: nil)
        
        viewModel.add(object: imageObj) { _ in }
        self.showSheet = false
    }
}

//struct ImageEditView_Previews: PreviewProvider {
//    static var previews: some View {
//        ImageEditView()
//    }
//}
