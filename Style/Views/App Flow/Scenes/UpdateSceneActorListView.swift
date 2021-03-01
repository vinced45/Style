//
//  UpdateSceneActorListView.swift
//  Style
//
//  Created by Vince Davis on 1/15/21.
//

import SwiftUI
import KingfisherSwiftUI

struct UpdateSceneActorListView: View {
    @Binding var showAddScene: Bool
    @Binding var movieScene: MovieScene
    @ObservedObject var viewModel: ProjectViewModel
    
    @State var actorIDs: [String] = []
    
    var body: some View {
        NavigationView {
            ZStack {
                SlantedBackgroundView()
                    .zIndex(1.0)
                
                List {
                    Text("Actors In Scene").bold()
                    
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
                            Spacer()
                            Image(systemName: (self.actorIDs.contains(actor.id ?? "")) ? "checkmark.rectangle" : "rectangle")
                                .resizable()
                                .frame(width: 30, height: 30, alignment: .center)

                        }
                        .padding([.top, .bottom], 2)
                        .onTapGesture {
                            toggle(actor: actor)
                        }
                    }
                }
                .listStyle(InsetGroupedListStyle())
                .zIndex(2.0)
            }
            .navigationBarTitle(Text("Update Actors"), displayMode: .inline)
            .navigationBarItems(leading: Button(action: {
                self.showAddScene = false
            }) {
                Text("Cancel").bold()
            }, trailing: Button(action: {
                updateScene()
            }) {
                Text("Save").bold()
            })
            .onAppear {
                actorIDs = movieScene.actors
            }
        }
    }
}

extension UpdateSceneActorListView {
    func updateScene() {
        movieScene.actors = actorIDs
        viewModel.update(object: movieScene, with: ["actors": actorIDs])
        self.showAddScene = false
    }
    
    func toggle(actor: Actor) {
        if actorIDs.contains(actor.id ?? "") {
            self.actorIDs.removeAll(where: { $0 == actor.id ?? "" })
        }
        else {
            self.actorIDs.append(actor.id ?? "")
        }
    }
}

struct AUpdateSceneActorListView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            UpdateSceneActorListView(showAddScene: .constant(true), movieScene: .constant(MovieScene.preview()), viewModel: ProjectViewModel.preview())
        }
    }
}
