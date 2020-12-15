//
//  ActorUpdateView.swift
//  Style
//
//  Created by Vince Davis on 11/23/20.
//

import SwiftUI
import KingfisherSwiftUI

struct ActorUpdateView: View {
    @ObservedObject var viewModel: ProjectViewModel
    
    @State var showSheetView = false
    
    var body: some View {
        VStack {
            if viewModel.actors.count > 0 {
                List {
                    ForEach(viewModel.actors) { actor in
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
                        .frame(width: .infinity, height: 60)
                    }
                    //.onDelete(perform: onDelete)
                    //.onMove(perform: onMove)
                }
            } else {
                Spacer(minLength: 150)
                EmptyView(image: "person.2.fill", title: "No Actors", message: "Tap + to add some.")
            }
            
            Spacer()
            NavigationLink(
                destination: SceneUpdateView(scenes: []),
                label: {
                    Text("Next")
                        .modifier(ButtonStyle())
                })
        }
        .padding(12)
        .navigationBarTitle("Actors")
        .navigationBarItems(trailing:
            Button(action: {
                self.showSheetView.toggle()
            }) {
                Image(systemName: "plus")
            }
        )
        .sheet(isPresented: $showSheetView) {
//            AddActorView(showSheetView: self.$showSheetView, newActor: { newActor in
//                self.add(actor: newActor)
//            })
        }
    }
}

extension ActorUpdateView {
    func add(actor: Actor) {
        //actors.append(actor)
    }
    
    private func onDelete(offsets: IndexSet) {
        //actors.remove(atOffsets: offsets)
    }

    private func onMove(source: IndexSet, destination: Int) {
        //actors.move(fromOffsets: source, toOffset: destination)
    }
}

//struct ActorUpdateView_Previews: PreviewProvider {
//    static var previews: some View {
//        Group {
//            ActorUpdateView(actors: [])
//            ActorUpdateView(actors: [Actor.dummyActor(), Actor.dummyActor2()])
//        }
//    }
//}


