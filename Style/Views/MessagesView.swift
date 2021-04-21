//
//  MessagesView.swift
//  Scene Me
//
//  Created by Vince Davis on 3/1/21.
//

import SwiftUI
import Foundation
import UIKit

struct Message: Hashable {
    var jobName: String
    var createDate: Date
    var userName: String
    var to: String
    var topic: String
    var viewableBy: String
    var type: MessageType
    var text: String
    var replies: [Message]
    var images: [String]
    var attachments: [String]
    
    static func preview() -> Message {
        return Message(jobName: "Cool Job Name",
                       createDate: Date(),
                       userName: "John Smith",
                       to: "Jessica",
                       topic: "Payments",
                       viewableBy: "Managers and Up",
                       type: .message,
                       text: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.",
                       replies: [Message.replyPreview(), Message.replyPreview2()],
                       images: ["house", "house", "house", "house", "house", "house", "house", "house"],
                       attachments: ["cool_file_name.pdf"])
    }
    
    static func preview2() -> Message {
        return Message(jobName: "Cool Job Name",
                       createDate: Date(),
                       userName: "John Smith",
                       to: "Steven",
                       topic: "Roof",
                       viewableBy: "Managers and Up",
                       type: .sms,
                       text: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.",
                       replies: [Message.replyPreview2(), Message.replyPreview()],
                       images: [],
                       attachments: [])
    }
    
    static func replyPreview() -> Message {
        return Message(jobName: "Cool Job Name",
                       createDate: Date(),
                       userName: "Mark",
                       to: "Steven",
                       topic: "",
                       viewableBy: "",
                       type: .reply,
                       text: "Looks good to me",
                       replies: [],
                       images: [],
                       attachments: [])
    }
    
    static func replyPreview2() -> Message {
        return Message(jobName: "Cool Job Name",
                       createDate: Date(),
                       userName: "John Smith",
                       to: "Mark",
                       topic: "",
                       viewableBy: "",
                       type: .reply,
                       text: "This needs to be longer so that we can see how long this screen will go.",
                       replies: [],
                       images: [],
                       attachments: [])
    }
}

enum MessageType {
    case message
    case sms
    case email
    case reply
    
    var image: String? {
        switch self {
        case .message: return "message.fill"
        case .sms: return "iphone"
        case .email: return "envelope.fill"
        case .reply: return nil
        }
    }
}

struct MessagesIconView: View {
    var body: some View {
        HStack {
            Text("Messages")
                .bold()
                .foregroundColor(Color("accuBlue"))
            
            Spacer()
            
            Image(systemName: "magnifyingglass")
                .renderingMode(.template)
                .foregroundColor(Color("accuBlue"))
            
            Image(systemName: "text.badge.plus")
                .renderingMode(.template)
                .foregroundColor(Color("accuBlue"))
            
            Image(systemName: "lightbulb.fill")
                .renderingMode(.template)
                .foregroundColor(Color("accuBlue"))
            
            Image(systemName: "square.and.pencil")
                .renderingMode(.template)
                .foregroundColor(Color("accuBlue"))
            
            Image(systemName: "arrow.up.arrow.down")
                .renderingMode(.template)
                .foregroundColor(Color("accuBlue"))
        }
        .padding()
        .background(Color.white)
    }
}

struct MessagesIconView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            MessagesIconView()
                .previewLayout(.sizeThatFits)
        }
    }
}

struct MessageView: View {
    var message: Message
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack(alignment: .top) {
                /// Icon and Date
                VStack(alignment: .center) {
                    if message.type != .reply {
                        Image(systemName: message.type.image!)
                            .renderingMode(.template)
                            .foregroundColor(Color("accuBlue"))
                    }
                    
                    Text(message.createDate.timeAgoDisplay())
                        .font(.subheadline)
                        .lineLimit(2)
                }
                .frame(width: 80)
                .padding([.leading, .top], 5)
                
                /// Rightside Message View
                VStack(alignment: .leading) {
                    HStack {
                        Text(message.userName)
                            .bold()
                        
                        Spacer()
                        
                        Text("10/21/21 10:49 AM")
                            .font(.subheadline)
                    }
                    .padding(.bottom, 3)
                    
                    if !message.to.isEmpty {
                        HStack {
                            Text("To:")
                                .bold()
                                .font(.subheadline)
                            
                            Text(message.to)
                                .font(.subheadline)
                        }
                        .padding(.bottom, 1)
                    }
                    
                    if !message.topic.isEmpty {
                        HStack {
                            Text("Topic:")
                                .bold()
                                .font(.subheadline)
                            
                            Text(message.topic)
                                .font(.subheadline)
                        }
                        .padding(.bottom, 1)
                    }
                    
                    if !message.viewableBy.isEmpty {
                        HStack {
                            Text("Viewable By:")
                                .bold()
                                .font(.subheadline)
                            
                            Text(message.viewableBy)
                                .font(.subheadline)
                        }
                        .padding(.bottom, 1)
                    }
                    
                    Text(message.text)
                        .lineLimit(nil)
                        .padding([.top, .bottom], 4)
                    
                    if message.images.count > 0 {
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 10) {
                                ForEach(message.images, id: \.self) { image in
                                    Image(image)
                                        .resizable()
                                        .frame(width: 50, height: 50)
                                }
                            }
                        }
                    }
                    
                    if message.attachments.count > 0 {
                        HStack {
                            ForEach(message.attachments, id: \.self) { attachment in
                                Button(action: {}) {
                                    Text(attachment)
                                }
                            }
                        }
                        .padding(.top)
                    }
                }
                .padding(.trailing)
            }
        }
        
        .background(Color.white)
    }
}

struct MessageView_Previews: PreviewProvider {
    static var previews: some View {
        MessageView(message: Message.preview())
            .previewLayout(.sizeThatFits)
    }
}

struct MessageReplyView: View {
    var message: Message
    
    var body: some View {
        MessageView(message: message)
            .padding(.leading, 40)
    }
}

struct MessageReplyView_Previews: PreviewProvider {
    static var previews: some View {
        MessageReplyView(message: Message.replyPreview())
            .previewLayout(.sizeThatFits)
    }
}

struct MessageContainerView: View {
    var message: Message
    
    var body: some View {
        ZStack {
            Color.white
                .zIndex(1.0)
            
            VStack(alignment: .leading) {
                MessageView(message: message)
                    .padding(.bottom, 10)
                    
                ForEach(message.replies, id: \.self) { reply in
                    MessageReplyView(message: reply)
                }
                
                Button(action: {
                    
                }) {
                    HStack {
                        Image(systemName: "arrowshape.turn.up.left.fill")
                        
                        Text("Reply")
                    }
                    .padding(20)
                }
            }
            .zIndex(2.0)
        }
        
    }
}

struct MessageContainerView_Previews: PreviewProvider {
    static var previews: some View {
        MessageContainerView(message: Message.preview())
            .previewLayout(.sizeThatFits)
    }
}

struct MessagesView: View {
    var messages: [Message]
    
    @State var searchText: String = ""
    
    @State var showSearch: Bool = false
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.gray
                    .zIndex(1.0)
                
                VStack {
                    MessagesIconView()
                        .onTapGesture {
                            withAnimation {
                                showSearch.toggle()
                            }
                        }
                    if showSearch {
                        ZStack {
                            Color("accuDarkBlue")
                                .zIndex(1.0)
                            
                            TextField("", text: $searchText)
                                .modifier(TextFieldStyle())
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .zIndex(2.0)
                        }
                        .frame(height: 40)
                        
                    }
                    ScrollView {
                        ForEach(messages, id: \.self) { message in
                            MessageContainerView(message: message)
                        }
                    }
                    
                    Spacer()
                }
                .zIndex(2.0)
            }
            .navigationBarTitle(messages.first!.jobName, displayMode: .inline)
            .navigationBarItems(leading: Button(action: {
                
            }) {
                Image(systemName: "chevron.backward")
            }, trailing: Button(action: {
                
            }) {
                Image(systemName: "ellipsis")
            })
        }
    }
}

struct MessagesView_Previews: PreviewProvider {
    static var previews: some View {
        MessagesView(messages: [Message.preview(), Message.preview2()])
    }
}

extension Date {
    func timeAgoDisplay() -> String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .full
        return formatter.localizedString(for: self, relativeTo: Date())
    }
}
