//
//  HUDView.swift
//  Style
//
//  Created by Vince Davis on 12/30/20.
//
import SwiftUI
import Foundation

struct UploadHUDView: View {
    @Binding var progress: Int
    @Binding var total: Int
    
    @ViewBuilder var body: some View {
        HStack(alignment: .center) {
            Image(systemName: "icloud.and.arrow.up")
                .imageScale(.large)
                .foregroundColor(.blue)
            VStack(alignment: .center) {
                Text("Uploading").font(.footnote)
                    .foregroundColor(.secondary)
                    .padding(.top, 4)
                ProgressView("", value: Float(progress), total: Float(total))
                    .frame(width: 120)
            }
        }.padding(.horizontal, 10)
        .padding(10)
        .background(
            Blur(style: .systemMaterial)
                .clipShape(Capsule())
                .shadow(color: Color(.black).opacity(0.22), radius: 12, x: 0, y: 5)
        )
    }
}

struct UploadHUDView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            UploadHUDView(progress: .constant(5), total: .constant(10))
                .padding(.all)
                .previewLayout(.sizeThatFits)
        }
    }
}

struct MessageHUDView: View {
    @Binding var message: String
    
    @ViewBuilder var body: some View {
        HStack(alignment: .center) {
            Text(message).font(.headline)
                .foregroundColor(.secondary)
                .padding(.top, 4)
                .frame(width: 200, height: 44)
        }.padding(.horizontal, 10)
        .padding(10)
        .background(
            Blur(style: .systemMaterial)
                .clipShape(Capsule())
                .shadow(color: Color(.black).opacity(0.22), radius: 12, x: 0, y: 5)
        )
    }
}

struct MessageHUDView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            MessageHUDView(message: .constant("Uploading"))
                .padding(.all)
                .previewLayout(.sizeThatFits)
        }
    }
}

struct Blur: UIViewRepresentable {
    var style: UIBlurEffect.Style
    
    func makeUIView(context: Context) -> UIVisualEffectView {
        return UIVisualEffectView(effect: UIBlurEffect(style: style))
    }
    
    func updateUIView(_ uiView: UIVisualEffectView, context: Context) {
        uiView.effect = UIBlurEffect(style: style)
    }
}
