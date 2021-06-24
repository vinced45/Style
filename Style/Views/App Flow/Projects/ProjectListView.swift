//
//  ProjectListView.swift
//  Style
//
//  Created by Vince Davis on 12/7/20.
//

import SwiftUI

struct ProjectListView: View {    
    @ObservedObject var viewModel: ProjectViewModel
    
    enum SheetType {
        case updateProfile
        case addProject
        case docPicker
        case importScript
    }
    
    @State var scriptUrl: String = ""
    
    @ObservedObject var sheet = SheetState<ProjectListView.SheetType>()
    
    @EnvironmentObject var session: SessionStore
    
    init(viewModel: ProjectViewModel) {
        
        self.viewModel = viewModel
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                SlantedBackgroundView()
                    .zIndex(1.0)
                
                VStack {
                    if viewModel.projects.count > 0 {
                        List {
                            ForEach(viewModel.projects) { project in
//                                NavigationLink(destination: ProjectDetailView(viewModel: viewModel, currentProject: project)) {
//                                    SquareImageTextRowView(config: project)
//                                        .frame(height: 100)
//                                }
                                NavigationLink(destination: ProjectAdminView(showSheet: .constant(true), project: .constant(project), viewModel: viewModel)) {
                                    SquareImageTextRowView(config: project)
                                        .frame(height: 100)
                                }
                                
                            }
                        }
                        .listStyle(InsetGroupedListStyle())
                    } else {
                        EmptyIconView(type: .project) {}
                    }
                }
                .zIndex(2.0)
            }
            .navigationBarTitle("Projects", displayMode: .inline)
            .navigationBarItems(leading : Button(action: {
                sheet.state = .updateProfile
            }) {
                Image(systemName: "person.circle")
                    .font(.title)
            }, trailing:
                Menu {
                    Button(action: {
                        sheet.state = .addProject
                    }) {
                        Label("New Project (Manually)", systemImage: "video.fill")
                    }
                    Button(action: {
                        sheet.state = .docPicker
                    }) {
                        Label("New Project (Import Script)", systemImage: "doc.fill")
                    }
                } label: {
                    Image(systemName: "plus.circle.fill")
                        .font(.title)
                }
            )
            .sheet(isPresented: $sheet.isShowing, content: {
                switch sheet.state {
                case .addProject: AddProjectView(showSheetView: $sheet.isShowing, viewModel: viewModel)
                case .updateProfile: UserUpdateView(showSheetView: $sheet.isShowing, viewModel: viewModel)
                case .docPicker: FilePickerController(callback: filePicked)
                case .importScript: ScriptView(fileUrl: $scriptUrl, showSheetView: $sheet.isShowing, viewModel: viewModel)
                default: EmptyView()
                }
            })
            .onAppear {
                viewModel.fetchProjects(uid: session.session?.uid ?? "")
            }
            .onOpenURL { url in
                importScript(from: url)
            }
        }
    }
}

extension ProjectListView {
    func filePicked(_ url: URL) {
        importScript(from: url)
    }
    
    func importScript(from url: URL) {
        guard let newUrl = File.moveUrlToDocumentsDirectory(url: url, fileExtension: "pdf") else {
            print("import script - unable to copy url")
            return
        }

        scriptUrl = newUrl.absoluteString
        sheet.state = .importScript
    }
}

struct ProjectListView_Previews: PreviewProvider {
    static var previews: some View {
        ProjectListView(viewModel: ProjectViewModel.preview())
    }
}
