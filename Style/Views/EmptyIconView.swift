//
//  EmptyView.swift
//  Style
//
//  Created by Vince Davis on 12/7/20.
//

import SwiftUI

enum EmptyType {
    case project
    case actor
    case scene
    case photo
    case note
    case actorLook
        
    var image: String {
        switch self {
        case .project: return "video.fill"
        case .actor: return "person.2.fill"
        case .scene: return "film"
        case .photo: return "photo.on.rectangle.angled"
        case .note: return "note.text"
        case .actorLook: return "binoculars"
        }
    }
    
    var title: String {
        switch self {
        case .project: return "No Projects"
        case .actor: return "No Actors"
        case .scene: return "No Scenes"
        case .photo: return "No Pictures"
        case .note: return "No Notes"
        case .actorLook: return "No Looks"
        }
    }
    
    var message: String {
        switch self {
        case .project: return "Tap + or here to add some."
        case .actor: return "Tap + or here to add some."
        case .scene: return "Tap + or here to add some."
        case .photo: return "Tap to add some pictures."
        case .note: return "Tap to add some notes."
        case .actorLook: return "Tap to add some looks for actor."
        }
    }
}

struct EmptyIconView: View {
    var type: EmptyType
    
    let completionHandler: () -> Void
    
    var body: some View {
        VStack {
            Image(systemName: type.image)
                .emptyStyle()
            Text(type.title)
                .font(.system(size: 20, weight: .bold))
            Text(type.message)
                .font(.system(size: 14, weight: .regular))
        }
        .onTapGesture {
            completionHandler()
        }
    }
}

struct EmptyView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            EmptyIconView(type: .project) { }
                .previewLayout(.sizeThatFits)
            EmptyIconView(type: .actor) { }
                .preferredColorScheme(.dark)
                .previewLayout(.sizeThatFits)
            EmptyIconView(type: .scene) { }
                .previewLayout(.sizeThatFits)
            EmptyIconView(type: .photo) { }
                .previewLayout(.sizeThatFits)
            EmptyIconView(type: .note) { }
                .previewLayout(.sizeThatFits)
            EmptyIconView(type: .actorLook) { }
                .previewLayout(.sizeThatFits)
        }
    }
}
