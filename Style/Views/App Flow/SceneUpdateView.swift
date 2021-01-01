//
//  SceneUpdateView.swift
//  Style
//
//  Created by Vince Davis on 11/23/20.
//

import SwiftUI

struct SceneUpdateView: View {
    var allActors: [Actor] = []
    @State var scenes: [MovieScene]
    
    @State var showSheetView = false
    
    var body: some View {
        NavigationView {
        VStack {
            if scenes.count > 0 {
                List {
                    ForEach(scenes) { scene in
                        NavigationLink(destination: Text("Scene Details")) {
                            VStack(alignment: .leading, spacing: 5) {
                            HStack {
                                Image(systemName: "film")
                                Text(scene.name).bold()
                            }
                            HStack {
                                Image(systemName: "person.2.fill")
                                Text("Actors in scene:  \(scene.actors.count)")
                            }
                        }
                        }
                        
                    }
                    .onDelete(perform: onDelete)
                    .onMove(perform: onMove)
                }
            } else {
                Spacer(minLength: 150)
                EmptyView(image: "film", title: "No Scenes", message: "Tap + to add some.") {}
            }
            
            Spacer()
            NavigationLink(
                destination: Text("huh"),
                label: {
                    Text("Next")
                        .modifier(ButtonStyle())
                })
        }
        .padding(12)
        .navigationBarTitle("Scenes")
        .navigationBarItems(trailing:
            Button(action: {
                self.showSheetView.toggle()
            }) {
                Image(systemName: "plus")
            }
        )
        .sheet(isPresented: $showSheetView) {
            //AddSceneView(showSheetView: self.$showSheetView, allActors: allActors)
        }}
    }
}

extension SceneUpdateView {
    func add(scene: MovieScene) {
        scenes.append(scene)
    }
    
    private func onDelete(offsets: IndexSet) {
        scenes.remove(atOffsets: offsets)
    }

    private func onMove(source: IndexSet, destination: Int) {
        scenes.move(fromOffsets: source, toOffset: destination)
    }
}

struct SceneUpdateView_Previews: PreviewProvider {
    @State static var showSheetView = true
    
    static var previews: some View {
        Group {
            SceneUpdateView(scenes: [])
            SceneUpdateView(scenes: [MovieScene.dummyScene(), MovieScene.dummyScene2()])
        }
    }
}


