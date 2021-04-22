//
//  ScriptSceneUpdateView.swift
//  Scene Me
//
//  Created by Vince Davis on 2/28/21.
//

import SwiftUI

struct ScriptSceneUpdateView: View {
    @Binding var scene: PDFScene
    var scriptUrl: String
    
    @State var showScript: Bool = false
    
    var body: some View {
        VStack {
            FormTextFieldView(name: "Scene Number", placeholder: "1", text: $scene.number)
                .padding([.leading, .trailing], 30)
                .keyboardType(.numberPad)
            
            FormTextFieldView(name: "Scene Name", placeholder: "Scene Name", text: $scene.text)
                .padding([.leading, .trailing], 30)
            
            FormTextFieldView(name: "Details Name", placeholder: "Details", text: $scene.details)
                .padding([.leading, .trailing], 30)
        }
        .navigationBarTitle("Edit Scene", displayMode: .inline)
        .navigationBarItems(trailing: Button(action: { showScript = true }) {
            Text("ShowScript").bold()
        }
        .sheet(isPresented: $showScript, content: {
            PDFKitView(url: URL(string: scriptUrl)!, showSheet: $showScript)
        })
        )
    }
}

struct ScriptSceneUpdateView_Previews: PreviewProvider {
    static var previews: some View {
        ScriptSceneUpdateView(scene: .constant(PDFScene(number: "2", text: "coool", details: "huh")), scriptUrl: "")
    }
}
