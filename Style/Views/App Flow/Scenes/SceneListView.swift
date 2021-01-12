//
//  SceneListView.swift
//  Style
//
//  Created by Vince Davis on 12/30/20.
//

import SwiftUI

struct SceneListView: View {
    @Binding var showSheet: Bool
    
    var scenes: [MovieScene]
    
    var image: String
    
    @ObservedObject var viewModel: ProjectViewModel
    
    @State var secondSheet: Bool = false
    
    var body: some View {
        NavigationView {
            VStack {
                List {
                    ForEach(scenes) { scene in
                        HStack {
                            ImageTextRowView(config: scene)
//                            Image(systemName: "film")
//                                .resizable()
//                                .frame(width: 44, height: 44)
//                            VStack(alignment: .leading) {
//                                Text("\(scene.number) - \(scene.name)").bold()
//                                Text("Actors in Scene: \(scene.actors.count)")
//                                    .font(.subheadline)
//                                    .foregroundColor(.gray)
//                            }
                            Spacer()
                            Image(systemName: "chevron.right")
                        }
                        .frame(height: 60)
                        .onTapGesture {
                            let sceneActor = SceneActor(id: nil,
                                                        sceneActorId: "\(scene.id ?? "")-\(viewModel.currentActor?.id ?? "")",
                                                        name: "",
                                                        top: "",
                                                        bottom: "",
                                                        shoes: "",
                                                        accessories: "",
                                                        notes: "",
                                                        beforeLook: false,
                                                        images: [image],
                                                        createdTime: nil)
                            
                            viewModel.currentSceneActor = sceneActor
                            secondSheet.toggle()
                        }
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .sheet(isPresented: $secondSheet, onDismiss: { showSheet.toggle() }, content: {
                AddSceneActorView(showSheet: $secondSheet, viewModel: viewModel)
            })
            .navigationTitle(Text("Select Scene"))
        }
        
    }
}

//struct SceneListView_Previews: PreviewProvider {
//    static var previews: some View {
//        SceneListView()
//    }
//}
