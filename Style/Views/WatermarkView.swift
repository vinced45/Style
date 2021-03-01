//
//  WatermarkView.swift
//  Scene Me
//
//  Created by Vince Davis on 2/5/21.
//

import SwiftUI

struct WatermarkView: View {
    var body: some View {
        Image(uiImage: watermark()!)
            .resizable()
            .aspectRatio(contentMode: .fit)
    }
}

extension WatermarkView {
    func watermark() -> UIImage? {
        guard let backgroundImage = UIImage(named: "viola-0"),
              let watermarkImage = UIImage(named: "watermark") else { return nil }

        let size = backgroundImage.size
        let scale = backgroundImage.scale

        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        backgroundImage.draw(in: CGRect(x: 0.0, y: 0.0, width: size.width, height: size.height))
        watermarkImage.draw(in: CGRect(x: 5, y: 5, width: 265 * scale, height: 201 * scale))

        let result = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
//        guard let image = result,
//              let data = image.jpegData(compressionQuality: 0.9) else { return nil }
//
//        return data
        
        return result
    }
}

struct WatermarkView_Previews: PreviewProvider {
    static var previews: some View {
        WatermarkView()
    }
}
