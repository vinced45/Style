//
//  ProjectListView.swift
//  Style
//
//  Created by Vince Davis on 12/7/20.
//

import SwiftUI
import KingfisherSwiftUI

enum UserUpdateViewActiveSheet {
    case updateProfile
    case addProject
}

struct ProjectListView: View {    
    @StateObject var viewModel: ProjectViewModel = ProjectViewModel()
    
    @State var showSheet: Bool = false
    
    @State private var activeSheet: UserUpdateViewActiveSheet = .addProject
    
    var body: some View {
        NavigationView {
            VStack {
                if viewModel.projects.count > 0 {
                    List {
                        ForEach(viewModel.projects) { project in
                            NavigationLink(destination: ProjectDetailView(viewModel: viewModel, currentProject: project)) {
                                HStack {
                                    KFImage(URL(string: project.image))
                                        .resizable()
                                        .frame(width: 44, height: 44)
                                        .clipShape(Circle())
                                        .shadow(radius: 10)
                                        .overlay(Circle().stroke(Color.black, lineWidth: 3))
                                    VStack(alignment: .leading) {
                                        Text(project.name)
//                                        Text("Users : \(project.users.count)")
//                                            .font(.subheadline)
//                                            .foregroundColor(.gray)
                                    }
                                }
                                .frame(height: 60)
                            }
                        }
                    }
                } else {
                    EmptyView(image: "video.fill", title: "No Projects", message: "Tap + to add some.") {}
                }
            }
            .navigationBarTitle("Projects")
            .navigationBarItems(leading : Button(action: {
                activeSheet = .updateProfile
                showSheet.toggle()
            }) {
                Image(systemName: "person.circle")
                    .font(.title)
            }, trailing:
                Button(action: {
                    activeSheet = .addProject
                    showSheet.toggle()
                }) {
                    Image(systemName: "plus")
                }
            )
            .sheet(isPresented: $showSheet, content: {
                switch activeSheet {
                case .addProject: AddProjectView(showSheetView: $showSheet, viewModel: viewModel)
                case .updateProfile: UserUpdateView(showSheetView: $showSheet, viewModel: viewModel)
                }
            })
            .onAppear {
                viewModel.fetchProjects()
            }
        }
    }
}

//struct ProjectListView_Previews: PreviewProvider {
//    static var previews: some View {
//        ProjectListView()
//    }
//}
