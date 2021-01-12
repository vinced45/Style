//
//  ImageTextRowView.swift
//  Style
//
//  Created by Vince Davis on 1/11/21.
//

import SwiftUI
import KingfisherSwiftUI

protocol ImageTextRowConfigable {
    var imageUrl: String { get }
    var text: String { get }
    var detailText: String { get }
    var icon: Bool { get }
}

struct ImageTextRowView: View {
    var config: ImageTextRowConfigable
    
    var body: some View {
        HStack {
            if config.icon {
                Image(systemName: config.imageUrl)
                    .resizable()
                    .frame(width: 44, height: 44)
            } else {
                KFImage(URL(string: config.imageUrl))
                    .resizable()
                    .frame(width: 44, height: 44)
                    .clipShape(Circle())
                    .shadow(radius: 10)
                    .overlay(Circle().stroke(Color.black, lineWidth: 3))
            }
            
            VStack(alignment: .leading) {
                Text(config.text)
                    .lineLimit(3)
                if config.detailText.isNotEmpty {
                    Text(config.detailText)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                
            }
        }
    }
}

struct ImageTextRowView_Previews: PreviewProvider {
    static var previews: some View {
        ImageTextRowView(config: Project.preview())
            .previewLayout(.fixed(width: 320, height: 70))
        ImageTextRowView(config: Actor.preview())
            .previewLayout(.fixed(width: 320, height: 70))
    }
}

extension Project: ImageTextRowConfigable {
    var imageUrl: String {
        return self.image
    }
    
    var text: String {
        return self.name
    }
    
    var detailText: String {
        return ""
    }
    
    var icon: Bool {
        return false
    }
}

extension Actor: ImageTextRowConfigable {
    var imageUrl: String {
        return self.image
    }
    
    var text: String {
        return self.screenName
    }
    
    var detailText: String {
        return self.realName
    }
    
    var icon: Bool {
        return false
    }
}


extension MovieScene: ImageTextRowConfigable {
    var imageUrl: String {
        return "film"
    }
    
    var text: String {
        return "\(self.number) - \(self.name)"
    }
    
    var detailText: String {
        return "Actors in Scene: \(self.actors.count)"
    }
    
    var icon: Bool {
        return true
    }
}

extension Note: ImageTextRowConfigable {
    var imageUrl: String {
        return "note.text"
    }
    
//    var text: String {
//        return "\(self.number) - \(self.name)"
//    }
    
    var detailText: String {
        return DateStyle.getRelativeDate(for: lastUpdated)
    }
    
    var icon: Bool {
        return true
    }
}
