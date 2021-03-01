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
        ZStack {
            HStack {
                if actorLook.completed {
                    Image(systemName: "checkmark.rectangle")
                        .renderingMode(.template)
                        .foregroundColor(Color("dark"))
                } else {
                    Image(systemName: "rectangle")
                        .renderingMode(.template)
                        .foregroundColor(Color("dark"))
                }
                
                VStack(alignment: .leading) {
                    Text(actorLook.text)
                        .foregroundColor(colorForTitle())
                        .strikethrough(actorLook.completed, color: Color("dark"))
                    Text(getRelativeDate(for: actorLook.lastUpdated ))
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                
                Spacer()
                
                StackedImageView(images: [actorLook.image, actorLook.image])
                    .frame(width: 80, height: 80)
    //                .onTapGesture {
    //                    selection = 1
    //                }
            }
            .zIndex(2.0)
        }
        .cornerRadius(5.0)
        
    }
}

extension ActorLookView {
    func colorForTitle() -> Color {
        return self.actorLook.completed ? Color.gray : Color("dark")
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
