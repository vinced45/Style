//
//  NewMessageView.swift
//  Scene Me
//
//  Created by Vince Davis on 3/12/21.
//

import SwiftUI

struct NewMessageView: View {
    @Binding var showSheet: Bool
    @ObservedObject var viewModel: ProjectViewModel
    
    @State var text: String = ""
    
    @State var toUser: ProjectUser?
    
    var body: some View {
        NavigationView {
            VStack {
                List {
//                    ForEach(viewModel.users) { user in
//                        Text(user.firstName)
//                    }
                    Picker("Select a User", selection: $toUser) {
                        ForEach(viewModel.users, id: \.self) { user in
                            Text(user.firstName)
                        }
                        ForEach(viewModel.users, id: \.self) { user in
                            Text(user.firstName)
                        }
                    }
                }
                
                Spacer()
                
                HStack {
                    TextField("Message...", text: $text)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .frame(minHeight: CGFloat(30))
                    
                    Button(action: {}) {
                        Image(systemName: "paperplane.circle.fill")
                            .renderingMode(.original)
                            .font(.largeTitle)
                    }
                }
                .frame(minHeight: CGFloat(50))
                .padding()
            }
            .navigationBarTitle(Text("New Message"), displayMode: .inline)
            .navigationBarItems(leading: Button(action: {
                self.showSheet = false
            }) {
                Text("Cancel").bold()
            })
        }
    }
}

extension NewMessageView {
    func sendMessage(to token: String, title: String, body: String) {
        let sender = PushNotificationSender()

        sender.sendPushNotification(to: token, title: title, body: body)
    }
}

struct NewMessageView_Previews: PreviewProvider {
    static var previews: some View {
        NewMessageView(showSheet: .constant(true), viewModel: ProjectViewModel.preview())
    }
}
