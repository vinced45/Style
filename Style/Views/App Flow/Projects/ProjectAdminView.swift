//
//  ProjectAdminView.swift
//  Scene Me
//
//  Created by Vince Davis on 2/28/21.
//

import SwiftUI
import Combine
import FirebaseFirestore
import FirebaseFirestoreSwift
import KingfisherSwiftUI

struct ProjectAdminView: View {
    @Binding var showSheet: Bool
    @Binding var project: Project
    @ObservedObject var viewModel: ProjectViewModel
    
    @State var userIDs: [String] = []
    
    @EnvironmentObject var session: SessionStore
    
    var body: some View {
        NavigationView {
            ZStack {
                SlantedBackgroundView()
                    .zIndex(1.0)
                
                Form {
                    Section(header: Text("Users for Project")) {
                        List {
                            ForEach(viewModel.users) { user in
                                HStack {
                                    KFImage(URL(string: user.image))
                                        .resizable()
                                        .frame(width: 44, height: 44)
                                        .clipShape(Circle())
                                        .shadow(radius: 10)
                                        .overlay(Circle().stroke(Color.black, lineWidth: 3))
                                    VStack(alignment: .leading) {
                                        Text(user.firstName + " " + user.lastName)
                                        Text(user.title)
                                            .font(.subheadline)
                                            .foregroundColor(.gray)
                                    }
                                    Spacer()
                                    Image(systemName: (self.userIDs.contains(user.uid)) ? "checkmark.rectangle" : "rectangle")
                                        .resizable()
                                        .frame(width: 30, height: 30, alignment: .center)

                                }
                                .onTapGesture {
                                    toggle(user: user)
                                }
                            }
                        }
                    }
                }
                .zIndex(2.0)
            }
            .navigationBarTitle("Admin", displayMode: .inline)
            .navigationBarItems(leading : Button(action: {
                showSheet = false
            }) {
                Text("Cancel")
            }, trailing: Button(action: {
                save()
            }) {
                Text("Save")
            })
            .onAppear {
                userIDs = project.admins
                viewModel.fetchUsers(exclude: session.session?.uid ?? "")
            }
        }
    }
}

extension ProjectAdminView {
    func save() {
        project.admins = userIDs
        viewModel.update(object: project, with: ["admins": userIDs])
        showSheet = false
    }
    
    func toggle(user: ProjectUser) {
        if userIDs.contains(user.uid) {
            self.userIDs.removeAll(where: { $0 == user.uid })
        }
        else {
            self.userIDs.append(user.uid)
        }
    }
}

struct ProjectAdminView_Previews: PreviewProvider {
    static var previews: some View {
        ProjectAdminView(showSheet: .constant(true),
                         project: .constant(Project.preview()),
                         viewModel: ProjectViewModel.preview())
    }
}
