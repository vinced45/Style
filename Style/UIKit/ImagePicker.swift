//
//  ImagePicker.swift
//  Style
//
//  Created by Vince Davis on 11/23/20.
//

import SwiftUI
import Photos
import PhotosUI
import MobileCoreServices

struct ImagePicker: UIViewControllerRepresentable {
    @Environment(\.presentationMode) var presentationMode
    @Binding var image: UIImage?
    @Binding var showCamera: Bool

    func makeUIViewController(context: UIViewControllerRepresentableContext<ImagePicker>) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.sourceType = showCamera ? .camera : .photoLibrary
        picker.delegate = context.coordinator
        return picker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: UIViewControllerRepresentableContext<ImagePicker>) {
        
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        let parent: ImagePicker

        init(_ parent: ImagePicker) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
            if let uiImage = info[.originalImage] as? UIImage {
                parent.image = uiImage
            }

            parent.presentationMode.wrappedValue.dismiss()
        }
    }
}

/// iOS 14 Picker
struct PhotoPicker: UIViewControllerRepresentable {
    @Environment(\.presentationMode) var presentationMode
    
    @Binding var result: [PHPickerResult]?
    
    func makeUIViewController(context: Context) -> PHPickerViewController {
        var configuration = PHPickerConfiguration(photoLibrary: PHPhotoLibrary.shared())
        configuration.filter = .images
        configuration.selectionLimit = 50
        
        let controller = PHPickerViewController(configuration: configuration)
        controller.delegate = context.coordinator
        
        return controller
    }
    func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) { }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    // Use a Coordinator to act as your PHPickerViewControllerDelegate
    class Coordinator: PHPickerViewControllerDelegate {
        private let parent: PhotoPicker
        
        init(_ parent: PhotoPicker) {
            self.parent = parent
        }
        
        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            //let identifiers = results.compactMap(\.assetIdentifier)
            parent.result = results
//            let fetchResult = PHAsset.fetchAssets(withLocalIdentifiers: identifiers, options: nil)
//            fetchRes
            //picker.dismiss(animated: true, completion: nil)
            parent.presentationMode.wrappedValue.dismiss()
        }
    }
}

struct AssetProcessor {
    static func process(results: [PHPickerResult], completion: @escaping (Data) -> Void) {
        let dispatchQueue = DispatchQueue(label: "com.vincedavis.style.AlbumImageQueue")
        var selectedImageDatas = [Data?](repeating: nil, count: results.count) // Awkwardly named, sure
        var totalConversionsCompleted = 0

        for (index, result) in results.enumerated() {
            result.itemProvider.loadFileRepresentation(forTypeIdentifier: UTType.image.identifier) { (url, error) in
                guard let url = url else {
                    dispatchQueue.sync { totalConversionsCompleted += 1 }
                    return
                }
                
//                guard url.startAccessingSecurityScopedResource() else {
//                    print("****** Unable to access the contents of \(url.path) ***\n")
//                    return
//                }
                
                let sourceOptions = [kCGImageSourceShouldCache: false] as CFDictionary
                
                guard let source = CGImageSourceCreateWithURL(url as CFURL, sourceOptions) else {
                    dispatchQueue.sync { totalConversionsCompleted += 1 }
                    return
                }
                
                let downsampleOptions = [
                    kCGImageSourceCreateThumbnailFromImageAlways: true,
                    kCGImageSourceCreateThumbnailWithTransform: true,
                    kCGImageSourceThumbnailMaxPixelSize: 2_000,
                ] as CFDictionary

                guard let cgImage = CGImageSourceCreateThumbnailAtIndex(source, 0, downsampleOptions) else {
                    dispatchQueue.sync { totalConversionsCompleted += 1 }
                    return
                }

                let data = NSMutableData()
                
                guard let imageDestination = CGImageDestinationCreateWithData(data, kUTTypeJPEG, 1, nil) else {
                    dispatchQueue.sync { totalConversionsCompleted += 1 }
                    return
                }
                
//                defer { url.stopAccessingSecurityScopedResource() }
                
                // Don't compress PNGs, they're too pretty
                let isPNG: Bool = {
                    guard let utType = cgImage.utType else { return false }
                    return (utType as String) == UTType.png.identifier
                }()

                let destinationProperties = [
                    kCGImageDestinationLossyCompressionQuality: isPNG ? 1.0 : 0.75
                ] as CFDictionary

                CGImageDestinationAddImage(imageDestination, cgImage, destinationProperties)
                CGImageDestinationFinalize(imageDestination)
                
                dispatchQueue.sync {
                    selectedImageDatas[index] = data as Data
                    totalConversionsCompleted += 1
                    completion(data as Data)
                }
            }
        }
    }
    
    
}


