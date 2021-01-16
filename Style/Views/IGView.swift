//
//  IGView.swift
//  Style
//
//  Created by Vince Davis on 1/11/21.
//

import SwiftUI
import KingfisherSwiftUI
import Combine

struct IGView: View {
    @Binding var showImage: Bool
    @State var showEdit: Bool = false

    let image: String
    let actor: Actor
    @ObservedObject var viewModel: ProjectViewModel
    
    @State var actorImage: ActorImage?
    
    @GestureState var scale: CGFloat = 1.0
    
    var animation: Namespace.ID
        
    let didSelect = PassthroughSubject<Actor, Never>()
        
    var body: some View {
        VStack(alignment: .leading) {
            ImageTextRowView(config: actor)
                .frame(height: 60)
                .padding([.leading, .trailing])
            
            KFImage(URL(string: image))
                .resizable()
                .scaledToFit()
                .frame(maxWidth: 500)
                .matchedGeometryEffect(id: image, in: animation)
                .scaleEffect(scale)
                .gesture(MagnificationGesture()
                    .updating($scale, body: { (value, scale, trans) in
                        scale = value.magnitude
                    })
                )
                .gesture(
                    DragGesture(minimumDistance: 3.0)
                        .onEnded { value in
                            if value.translation.height > 0 && value.translation.width < 100 && value.translation.width > -100 {
                                    print("down swipe")
                                withAnimation(.interactiveSpring(response: 0.5, dampingFraction: 0.8, blendDuration: 0.8)) {
                                    showImage = false
                                }
                                }
                        }
                    )
                
            Text(createText())
                .padding(.leading)
                //.padding(.bottom)
            
            Text(getRelativeDate(for: actorImage?.createdTime?.dateValue() ?? Date()))
                .font(.footnote)
                .foregroundColor(.gray)
                .padding(.leading)
                .padding(.bottom)
                
        }
        .frame(maxWidth: 500)
        .onAppear {
            viewModel.fetchactorImageDetails(for: image) { actorImageWeb in
                actorImage = actorImageWeb
            }
        }

    }
}

extension IGView {
    func createText() -> String {
        var text = ""
        
        if let top = actorImage?.top {
            text += "👕 " + top + " "
        }

        if let bottom = actorImage?.bottom {
            text += "👖 " + bottom + " "
        }

        if let shoes = actorImage?.shoes {
            text += "👞 " + shoes + " "
        }

        if let accessories = actorImage?.accessories {
            text += "💼 " + accessories + " "
        }

        if let notes = actorImage?.notes {
            text += "📝 " + notes + " "
        }
        
        return text
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

