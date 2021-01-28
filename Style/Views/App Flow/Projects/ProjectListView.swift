//
//  ProjectListView.swift
//  Style
//
//  Created by Vince Davis on 12/7/20.
//

import SwiftUI

struct ProjectListView: View {    
    @StateObject var viewModel: ProjectViewModel = ProjectViewModel()
    
    enum SheetType {
        case updateProfile
        case addProject
        case showSettings
        case importScript
    }
    
    @State var scriptUrl: String = ""
    
    @ObservedObject var sheet = SheetState<ProjectListView.SheetType>()
    
    var body: some View {
        NavigationView {
            VStack {
                if viewModel.projects.count > 0 {
                    List {
                        ForEach(viewModel.projects) { project in
                            NavigationLink(destination: ProjectDetailView(viewModel: viewModel, currentProject: project)) {
                                ImageTextRowView(config: project)
                                    .frame(height: 60)
                            }
                        }
                    }
                } else {
                    EmptyIconView(type: .project) {}
                }
            }
            .navigationBarTitle("Projects")
            .navigationBarItems(leading : Button(action: {
                sheet.state = .updateProfile
            }) {
                Image(systemName: "person.circle")
                    .font(.title)
            }, trailing:
                HStack {
                    Button(action: {
                        sheet.state = .addProject
                    }) {
                        Image(systemName: "plus")
                    }
                    
                    Button(action: {
                        sheet.state = .showSettings
                    }) {
                        Image(systemName: "gear")
                    }
                }
            )
            .sheet(isPresented: $sheet.isShowing, content: {
                switch sheet.state {
                case .addProject: AddProjectView(showSheetView: $sheet.isShowing, viewModel: viewModel)
                case .updateProfile: UserUpdateView(showSheetView: $sheet.isShowing, viewModel: viewModel)
                case .showSettings: HapticView()
                case .importScript: ScriptView(fileUrl: $scriptUrl, showSheetView: $sheet.isShowing, viewModel: viewModel)
                default: EmptyView()
                }
            })
            .onAppear {
                viewModel.fetchProjects()
            }
            .onOpenURL { url in
                guard let newUrl = File.moveUrlToDocumentsDirectory(url: url, fileExtension: "pdf") else {
                    print("import script - unable to copy url")
                    return
                }

                scriptUrl = newUrl.absoluteString
                sheet.state = .importScript
            }
        }
    }
}

extension ProjectListView {

}

struct ProjectListView_Previews: PreviewProvider {
    static var previews: some View {
        ProjectListView(viewModel: ProjectViewModel.preview())
    }
}
