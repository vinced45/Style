//
//  FormTextFieldView.swift
//  Style
//
//  Created by Vince Davis on 1/11/21.
//

import SwiftUI

struct FormTextFieldView: View {
    var name: String
    var placeholder: String
    @Binding var text: String
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(name)
                .padding(.leading, 10)
            TextField(placeholder, text: $text)
                .modifier(TextFieldStyle())
                .textFieldStyle(RoundedBorderTextFieldStyle())
        }
    }
}

struct FormTextFieldView_Previews: PreviewProvider {

    static var previews: some View {
        FormTextFieldView(name: "Name", placeholder: "Actor Name", text: .constant("Taye Diggs"))
    }
}

struct FormTextFieldView2: View {
    var name: String
    var placeholder: String
    @Binding var text: String
    
    var body: some View {
        HStack {
            Text(name)
                .bold()
                .padding(.leading, 10)
            
            Spacer()
            
            TextField(placeholder, text: $text)
                .frame(width: 100)
                .modifier(TextFieldStyle())
                .textFieldStyle(RoundedBorderTextFieldStyle())
        }
    }
}

struct FormTextFieldView2_Previews: PreviewProvider {

    static var previews: some View {
        FormTextFieldView2(name: "Name", placeholder: "Actor Name", text: .constant("Taye Diggs"))
    }
}

struct FormTextFieldView3: View {
    var name: String
    var placeholder: String
    @Binding var text: String
    @Binding var note: String
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(name)
                .bold()
                .padding(.leading, 10)
            
            HStack {
                TextField(placeholder, text: $text)
                    .frame(width: 80)
                    .modifier(TextFieldStyle())
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                Spacer()
                
                TextField("Notes", text: $note)
                    //.frame(width: 160)
                    .modifier(TextFieldStyle())
                    .textFieldStyle(RoundedBorderTextFieldStyle())
            }
        }
        
    }
}

struct FormTextFieldView3_Previews: PreviewProvider {

    static var previews: some View {
        FormTextFieldView3(name: "Name", placeholder: "Actor Name", text: .constant("36B"), note: .constant("cool note!"))
    }
}
