//
//  ActorListView.swift
//  Scene Me
//
//  Created by Vince Davis on 3/10/21.
//

import SwiftUI

struct ActorListView: View {
    @Binding var actor: Actor
    @ObservedObject var viewModel: ProjectViewModel
    
    var body: some View {
        List {
            Button(action: { actor = Actor.none() } ) {
                HStack {
                    ImageTextRowView(config: Actor.none())
                    
                    Spacer()
                    
                    if let id = actor.id, id == "1111" {
                        Image(systemName: "checkmark")
                    }
                }
            }
            
            ForEach(viewModel.actors) { listActor in
                Button(action: { self.actor = listActor }) {
                    HStack {
                        ImageTextRowView(config: listActor)
                        
                        Spacer()
                        
                        if let id = actor.id, id == listActor.id ?? "" {
                            Image(systemName: "checkmark")
                        }
                    }
                }
            }
        }
    }
}

struct ActorListView_Previews: PreviewProvider {
    static var previews: some View {
        ActorListView(actor: .constant(Actor.preview()), viewModel: ProjectViewModel.preview())
    }
}
