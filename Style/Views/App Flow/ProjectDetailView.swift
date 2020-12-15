//
//  ProjectDetailView.swift
//  Style
//
//  Created by Vince Davis on 12/15/20.
//

import SwiftUI
import KingfisherSwiftUI


enum ProjectDetailViewActiveSheet {
    case actor
    case scene
}

struct ProjectDetailView: View {
    @ObservedObject var viewModel: ProjectViewModel
    var currentProject: Project
    
    @State private var showSheet = false
    @State private var activeSheet: ProjectDetailViewActiveSheet = .actor
    
    var body: some View {
        Form {
            Section(header: Text("Actors")) {
                ForEach(viewModel.actors) { actor in
                    NavigationLink(destination: Text("th")) {
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
                
                Button(action: {
                    activeSheet = .actor
                    showSheet.toggle()
                }) {
                    Text("Add Actor")
                }
            }
            
            Section(header: Text("Scenes")) {
                ForEach(viewModel.scenes) { scene in
                    NavigationLink(destination: SceneDetailView(viewModel: viewModel, currentScene: scene)) {
                        HStack {
                            Image(systemName: "film")
                                .resizable()
                                .frame(width: 44, height: 44)
                            VStack(alignment: .leading) {
                                Text(scene.name).bold()
                                Text("Actors in Scene: \(scene.actors.count)")
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                            }
                        }
                        .frame(height: 60)
                    }
                }
                
                Button(action: {
                    activeSheet = .scene
                    showSheet.toggle()
                }) {
                    Text("Add Scene")
                }
            }
        }
        .navigationTitle(currentProject.name)
        .onAppear {
            viewModel.currentProject = self.currentProject
            viewModel.fetchActors(for: currentProject.id ?? "")
            viewModel.fetchScenes(for: currentProject.id ?? "")
        }
        .onReceive(viewModel.didChange) { _ in
            viewModel.fetchActors(for: currentProject.id ?? "")
            viewModel.fetchScenes(for: currentProject.id ?? "")
        }
        .sheet(isPresented: $showSheet, content: {
            switch activeSheet {
            case .actor: AddActorView(showAddActor: $showSheet, viewModel: viewModel)
            case .scene: AddSceneView(showAddScene: $showSheet, viewModel: viewModel)
            }
            
        })
    }
}

//struct ProjectDetailView_Previews: PreviewProvider {
//    static var previews: some View {
//        ProjectDetailView()
//    }
//}
