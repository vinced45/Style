//
//  ProjectDetailView.swift
//  Style
//
//  Created by Vince Davis on 12/15/20.
//

import SwiftUI
import KingfisherSwiftUI

struct ProjectDetailView: View {
    @ObservedObject var viewModel: ProjectViewModel
    var currentProject: Project

    enum SheetType {
        case actor
        case scene
        case editProject
    }
    
    @ObservedObject var sheet = SheetState<ProjectDetailView.SheetType>()

    var body: some View {
        Form {
            Section(header: Text("Actors")) {
                ForEach(viewModel.actors) { actor in
                    NavigationLink(destination: ActorDetailView(viewModel: viewModel, currentActor: actor)) {
                        ImageTextRowView(config: actor)
                            .frame(height: 60)
                    }
                }
                
                Button(action: {
                    sheet.state = .actor
                }) {
                    Text("Add Actor")
                }
            }
            
            Section(header: Text("Scenes")) {
                ForEach(viewModel.scenes) { scene in
                    NavigationLink(destination: SceneDetailView(viewModel: viewModel, currentScene: scene)) {
                        ImageTextRowView(config: scene)
                            .frame(height: 60)
                    }
                }
                
                Button(action: {
                    sheet.state = .scene
                }) {
                    Text("Add Scene")
                }
            }
        }
        .navigationTitle(currentProject.name)
        .navigationBarItems(trailing:
            Menu {
                Button(action: {
                    sheet.state = .editProject
                }) {
                    Label("Edit Project", systemImage: "video.fill")
                }
            } label: {
                Image(systemName: "ellipsis")
            }
        )
        .onAppear {
            viewModel.currentProject = self.currentProject
            viewModel.fetchActors(for: currentProject.id ?? "")
            viewModel.fetchScenes(for: currentProject.id ?? "")
        }
        .onReceive(viewModel.didChange) { _ in
            viewModel.fetchActors(for: currentProject.id ?? "")
            viewModel.fetchScenes(for: currentProject.id ?? "")
        }
        .sheet(isPresented: $sheet.isShowing, content: {
            sheetContent()
        })
    }
}

extension ProjectDetailView {
    @ViewBuilder
    private func sheetContent() -> some View {
        switch sheet.state {
        case .actor: AddActorView(showAddActor: $sheet.isShowing, viewModel: viewModel)
        case .scene: AddSceneView(showAddScene: $sheet.isShowing, viewModel: viewModel)
        case .editProject: EditProjectView(showSheetView: $sheet.isShowing, project: currentProject, viewModel: viewModel)
        case .none: EmptyView()
        }
    }
}

struct ProjectDetailView_Previews: PreviewProvider {
    static var previews: some View {
        ProjectDetailView(viewModel: ProjectViewModel.preview(), currentProject: Project.preview())
    }
}
