//
//  SceneActorShareView.swift
//  Style
//
//  Created by Vince Davis on 12/7/20.
//

import SwiftUI

struct SceneActorShareView: View {
    let actor: Actor
    
    @State private var message = ""
    @State private var textStyle = UIFont.TextStyle.body
    
    @State var selecetedEmails: [String] = []
    var emails: [String] = ["director@gmail.com", "designer@gmail.com", "producer@gmail.com"]
    
    @State var selecetedNumbers: [String] = []
    var numbers: [String] = ["555-555-5555", "555-555-1234", "555-555-9999"]
    
    init(actor: Actor){
        self.actor = actor
        //UITableView.appearance().backgroundColor = .clear
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Scene Actor to send:")) {
                    HStack {
                        Image(actor.image)
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
                    .frame(width: .infinity, height: 60)
                }
                
                Section(header: Text("Message:")) {
                    TextView(text: $message, textStyle: .callout)
                        .frame(height: 150)
                }
                
                Section(header: Text("Send to email:")) {
                    ForEach(emails, id: \.self) { email in
                        MultipleSelectionRow(item: email, isSelected: self.selecetedEmails.contains(email)) {
                            if self.selecetedEmails.contains(email) {
                                self.selecetedEmails.removeAll(where: { $0 == email })
                            }
                            else {
                                self.selecetedEmails.append(email)
                            }
                        }
                    }
                }
                
                Section(header: Text("Send to text:")) {
                    ForEach(numbers, id: \.self) { number in
                        MultipleSelectionRow(item: number, isSelected: self.selecetedNumbers.contains(number)) {
                            if self.selecetedNumbers.contains(number) {
                                self.selecetedNumbers.removeAll(where: { $0 == number })
                            }
                            else {
                                self.selecetedNumbers.append(number)
                            }
                        }
                    }
                }
                
                Section {
                    Button(action: {
                        print("Edit button was tapped")
                    }) {
                        HStack(spacing: 10) {
                            Image(systemName: "square.and.arrow.up.fill")
                            Text("Share")
                        }
                    }
                        .modifier(ButtonStyle())
                        //.padding(10)
                }
                
            }
            .navigationTitle("Share")
            .navigationBarItems(leading: Button(action: {
                
            }) {
                Text("Cancel").bold()
            }, trailing: Button(action: {
                 
            }) {
                Image(systemName: "paperplane.fill")
            })
        }
    }
}

//struct SceneActorShareView_Previews: PreviewProvider {
//    static var previews: some View {
//        SceneActorShareView(actor: Actor.dummyActor2())
//    }
//}
