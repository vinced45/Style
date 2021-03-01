//
//  UIImage+Extensions.swift
//  Scene Me
//
//  Created by Vince Davis on 2/6/21.
//

import UIKit

extension UIImage {
    func watermark() -> UIImage? {
        guard let watermarkImage = UIImage(named: "watermark") else { return nil }

        let size = self.size
        let scale = self.scale
        print("scale \(scale)")

        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        self.draw(in: CGRect(x: 0.0, y: 0.0, width: size.width, height: size.height))
        watermarkImage.draw(in: CGRect(x: 10, y: 10, width: 265 * scale, height: 201 * scale))

        let result = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
//        guard let image = result,
//              let data = image.jpegData(compressionQuality: 0.9) else { return nil }
//
//        return data
        
        return result
    }
}
