//
//  BackgroundView.swift
//  Scene Me
//
//  Created by Vince Davis on 1/27/21.
//

import SwiftUI

struct BackgroundView: View {
    
    @State var projectName: String = ""
    
    var body: some View {
        ZStack {
            VStack {
                Rectangle()
                    .fill(Color("darkBlue"))
                    .ignoresSafeArea(.container, edges: .top)
                    .frame(height: 280)
                
                Triangle()
                    .fill(Color("darkBlue"))
                    .frame(width: 300, height: 100)
                    .rotationEffect(.degrees(180))
                    .offset(x: 0, y: -50.0)
                
                SlantedRectangle()
                    .fill(Color("midGray"))
                    .frame(height: 450)
                    .offset(x: 0, y: -100.0)
                
                Spacer()
            }
            .zIndex(1)
            
            VStack {
                Image("viola-0")
                    .resizable()
                    //.frame(h)
                    .modifier(ProfileImageStyle())
                Text("Enter A New Project Name")
                    .foregroundColor(.white)
                
                TextField("Enter your project name", text: $projectName)
                    .background(
                        RoundedRectangle(cornerRadius: 5)
                            .fill(Color.white)
                            //.strokeBorder(Color.black, lineWidth: 1)
                    )
                    
                    .frame(width: 250)
                
                HStack {
                    Button("Cancel", action: {})
                        .foregroundColor(.white)
                        .frame(width: 100, height: 50)
                    
                    Spacer(minLength: 200)
                    
                    Button("Create", action: {})
                        .frame(width: 100, height: 50)
                        .foregroundColor(.white)
                        .background(Color("teal"))
                        .cornerRadius(5.0)

                }
                .padding(.top)
                
                Text("OR")
                    .font(.largeTitle)
                    .foregroundColor(.white)
                    .offset(x: 0, y: 15)
                
                Spacer()
                
                Image("logo")
                
                Spacer()
            }
            .padding([.top, .leading, .trailing], 30)
            .zIndex(2)
        }
        
        
    }
}

struct BackgroundView_Previews: PreviewProvider {
    static var previews: some View {
        BackgroundView()
    }
}

struct Triangle: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()

        path.move(to: CGPoint(x: rect.midX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.midX, y: rect.minY))

        return path
    }
}
