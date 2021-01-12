//
//  ActorLookView.swift
//  Style
//
//  Created by Vince Davis on 1/11/21.
//

import SwiftUI
import KingfisherSwiftUI

struct ActorLookView: View {
    var actorLook: ActorLook
    
    var body: some View {
        HStack {
            if actorLook.completed {
                Image(systemName: "checkmark.rectangle")
                
            } else {
                Image(systemName: "rectangle")
                
            }
            
            VStack(alignment: .leading) {
                Text(actorLook.text)
                    .foregroundColor(colorForTitle())
                    .strikethrough(actorLook.completed, color: .black)
                Text(getRelativeDate(for: actorLook.lastUpdated ?? Date()))
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            
            Spacer()
            
            KFImage(URL(string: actorLook.image))
                .resizable()
                .frame(width: 70, height: 70)
                .scaledToFit()
        }
    }
}

extension ActorLookView {
    func colorForTitle() -> Color {
        return self.actorLook.completed ? Color.gray : Color.black
    }
    
    func getRelativeDate(for date: Date) -> String {
        // ask for the full relative date
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .full

        // get exampleDate relative to the current date
        let relativeDate = formatter.localizedString(for: date, relativeTo: Date())

        return relativeDate
    }
}

struct ActorLookView_Previews: PreviewProvider {
    static var previews: some View {
        ActorLookView(actorLook: ActorLook.preview())
            .padding(.all)
            .previewLayout(.sizeThatFits)
    }
}
