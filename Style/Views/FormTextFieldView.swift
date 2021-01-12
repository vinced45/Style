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
            Text(name).bold()
            TextField(placeholder, text: $text)
                .modifier(TextFieldStyle())
        }
    }
}

//struct FormTextFieldView_Previews: PreviewProvider {
//    @State var text = "Taye Diggs"
//    
//    static var previews: some View {
//        
//        FormTextFieldView(name: "Name", placeholder: "Actor Name", text: $text)
//    }
//}
