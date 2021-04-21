//
//  MessageListView.swift
//  Scene Me
//
//  Created by Vince Davis on 3/12/21.
//

import SwiftUI

struct MessageListView: View {
    @Binding var showSheet: Bool
    @ObservedObject var viewModel: ProjectViewModel
    
    enum SheetType {
        case newMessage
    }
    
    @ObservedObject var sheet = SheetState<MessageListView.SheetType>()
    
    var body: some View {
        NavigationView {
            VStack {
                if viewModel.messages.count == 0 {
                    EmptyIconView(type: .message) {}
                } else {
                    List {
                        ForEach(viewModel.messages) { message in
                            NavigationLink(destination: Text("wow")) {
                                HStack {
                                    Image(systemName: "circlebadge.fill")
                                        .renderingMode(.original)
                                        .foregroundColor(.white)
                                    
                                    Image(systemName: "person.crop.circle.fill")
                                        .resizable()
                                        .frame(width: 40, height: 40, alignment: .center)
                                    
                                    VStack(alignment: .leading) {
                                        HStack {
                                            Text(message.from)
                                                .bold()
                                            
                                            Spacer ()
                                            
                                            Text(message.created.relative)
                                                .foregroundColor(.gray)
                                        }
                                        
                                        Text(message.text)
                                            .lineLimit(2)
                                            .foregroundColor(.gray)
                                    }
                                }
                                .frame(height: 60)
                            }
                        }
                    }
                    .listStyle(PlainListStyle())
                }
            }
            .sheet(isPresented: $sheet.isShowing, content: {
                switch sheet.state {
                case .newMessage: NewMessageView(showSheet: $sheet.isShowing, viewModel: viewModel)
                default: EmptyView()
                }
            })
            .navigationBarTitle(Text("Messages"), displayMode: .inline)
            .navigationBarItems(leading: Button(action: {
                self.showSheet = false
            }) {
                Text("Done").bold()
            }, trailing: Button(action: {
                sheet.state = .newMessage
            }) {
                Image(systemName: "plus.circle.fill")
                    .renderingMode(.original)
                    .font(.largeTitle)
            })
        }
    }
}

struct MessageListView_Previews: PreviewProvider {
    static var previews: some View {
        MessageListView(showSheet: .constant(true), viewModel: ProjectViewModel.preview())
    }
}
