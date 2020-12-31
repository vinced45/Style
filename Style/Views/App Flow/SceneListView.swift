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
    
    let completionHandler: (MovieScene) -> Void
    
    var body: some View {
        NavigationView {
            VStack {
                List {
                    ForEach(scenes) { scene in
                        HStack {
                            Image(systemName: "film")
                                .resizable()
                                .frame(width: 44, height: 44)
                            VStack(alignment: .leading) {
                                Text(scene.name).bold()
                                Text("Actors in Scene: \(scene.actors.count)")
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                            }
                            Spacer()
                            Image(systemName: "chevron.right")
                        }
                        .frame(height: 60)
                        .onTapGesture {
                            completionHandler(scene)
                            showSheet.toggle()
                        }
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle(Text("Select Scene"))
        }
        
    }
}

//struct SceneListView_Previews: PreviewProvider {
//    static var previews: some View {
//        SceneListView()
//    }
//}
