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
    @State var currentProject: Project

    enum SheetType {
        case actor
        case scene
        case editProject
        case admin
    }
    
    @ObservedObject var sheet = SheetState<ProjectDetailView.SheetType>()
    
    @State var isActorsExpanded = true
    @State var isScenesExpanded = true

    var body: some View {
        ZStack {
            SlantedBackgroundView()
                .zIndex(1.0)
            
            List {
                Section {
                    DisclosureGroup(isExpanded: $isActorsExpanded) {
                        ForEach(viewModel.actors) { actor in
                            NavigationLink(destination: ActorDetailView(viewModel: viewModel, currentActor: actor)) {
                                ImageTextRowView(config: actor)
                                    .frame(height: 60)
                            }
                        }
                    } label: {
                        Text("Actors (\(viewModel.actors.count))")
                            .font(.headline)
                    }
                    
                    Button(action: {
                        sheet.state = .actor
                    }) {
                        Text("Add Actor")
                    }
                }
                
                Section {
                    DisclosureGroup(isExpanded: $isScenesExpanded) {
                        ForEach(viewModel.scenes) { scene in
                            NavigationLink(destination: SceneDetailView(viewModel: viewModel, currentScene: scene)) {
                                ImageTextRowView(config: scene)
                                    .frame(height: 60)
                            }
                        }
                    } label: {
                        Text("Scenes (\(viewModel.scenes.count))")
                            .font(.headline)
                    }
                    
                    Button(action: {
                        sheet.state = .scene
                    }) {
                        Text("Add Scene")
                    }
                }
            }
            .listStyle(InsetGroupedListStyle())
            .zIndex(2.0)
            .padding(.top, 50)
            
        }
        .navigationBarTitle(currentProject.name, displayMode: .inline)
        .navigationBarItems(trailing:
            Menu {
                Button(action: {
                    sheet.state = .editProject
                }) {
                    Label("Edit Project", systemImage: "video.fill")
                }
                
                Button(action: {
                    sheet.state = .admin
                }) {
                    Label("Manage Users", systemImage: "person.3.fill")
                }
                
                Button(action: {
                    sheet.state = .actor
                }) {
                    Label("Add Actor", systemImage: "person.fill")
                }
                
                Button(action: {
                    sheet.state = .scene
                }) {
                    Label("Add Scene", systemImage: "film.fill")
                }
            } label: {
                Image(systemName: "ellipsis")
                    .font(.title)
            }
        )
        .onAppear {
            viewModel.currentProject = self.currentProject
            if let id = currentProject.id {
                viewModel.fetchActors(for: id)
                viewModel.fetchScenes(for: id)
                viewModel.fetchProjectImagess(projectId: id)
                viewModel.fetchSceneContinuities(projectId: id)
            }
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
        case .editProject: EditProjectView(showSheetView: $sheet.isShowing, project: $currentProject, viewModel: viewModel)
        case .admin: ProjectAdminView(showSheet: $sheet.isShowing, project: $currentProject, viewModel: viewModel)
        case .none: EmptyView()
        }
    }
}

struct ProjectDetailView_Previews: PreviewProvider {
    static var previews: some View {
        ProjectDetailView(viewModel: ProjectViewModel.preview(), currentProject: Project.preview())
    }
}
