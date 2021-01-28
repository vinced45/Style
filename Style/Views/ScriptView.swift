//
//  ScriptView.swift
//  Scene Me
//
//  Created by Vince Davis on 1/27/21.
//

import SwiftUI
import PDFKit
import UniformTypeIdentifiers

struct ScriptView: View {
    @Binding var fileUrl: String
    @Binding var showSheetView: Bool
    @ObservedObject var viewModel: ProjectViewModel
    
    @State var title = ""
    @State var scenes: [PDFScene] = []
    @State private var isImporting: Bool = false
    
    var body: some View {
        NavigationView {
            VStack(alignment: .center) {
                Text(title)
                    .multilineTextAlignment(.center)
                    .padding(.top)
                
                List {
                    ForEach(scenes, id: \.self) { scene in
                        HStack {
                            Text(scene.number)
                                .font(.largeTitle)
                            
                            VStack(alignment: .leading) {
                                Text((scene.text))
                                    .bold()
                                
                                Text(scene.details)
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                            }
                        }
                        
                    }
                }
            }
            .navigationBarTitle(Text("Import Script"), displayMode: .inline)
            .navigationBarItems(leading: Button(action: {
                self.showSheetView = false
            }) {
                Text("Cancel").bold()
            }, trailing: Button(action: {
                //parse()
            }) {
                Text("Save").bold()
            })
            .onAppear {
                parse()
            }
        }
    }
    
    func parse() {
        guard let url = URL(string: fileUrl) else { return
            print("import script - unable to find url")
        }
        PDFReader.parseTitle(for: url) { attrString in
            title = attrString.string
        }
        
        PDFReader.parseScenes(for: url) { scene in
            scenes.append(scene)
        }
    }
}

//struct ScriptView_Previews: PreviewProvider {
//    static var previews: some View {
//        ScriptView()
//    }
//}

struct PDFScene: Hashable {
    var number: String
    var text: String
    var details: String
}

struct PDFReader {
    static func parseScenes(for file: URL, completion: @escaping (PDFScene) -> Void) {
        if let pdf = PDFDocument(url: file) {
            let pageCount = pdf.pageCount
            let documentContent = NSMutableAttributedString()
            print("pages count \(pageCount)")
            for i in 1 ..< pageCount {
                guard let page = pdf.page(at: i) else { continue }
                guard let pageContent = page.attributedString else { continue }
                documentContent.append(pageContent)
                let sceneTypes = ["INT.", "EXT."]
                if let allLines = page.string?.components(separatedBy: "\n") {
                    for line in allLines where sceneTypes.contains(where: line.contains) {
                        let stringArray = line.components(separatedBy: CharacterSet.decimalDigits.inverted)
                        if let str = stringArray.first {
                            let com = line.components(separatedBy: ["INT. ", "EXT. ", " - "])
                            var text = ""
                            var details = ""
                            
                            if com.count > 1 {
                                text = com[1]
                            }
                            if com.count > 2 {
                                details = com[2]
                            }
                            completion(PDFScene(number: str, text: text, details: details))
                        }
                    }
                }
            }
        }
    }
    
    static func parseTitle(for file: URL, completion: @escaping (NSMutableAttributedString) -> Void) {
        if let pdf = PDFDocument(url: file) {
            let documentContent = NSMutableAttributedString()
            
            guard let page = pdf.page(at: 0) else { return }
            guard let pageContent = page.attributedString else { return }
            documentContent.append(pageContent)
            
            completion(documentContent)
        }
    }
}

extension String {
    func components<T>(separatedBy separators: [T]) -> [String] where T : StringProtocol {
        var result = [self]
        for separator in separators {
            result = result
                .map { $0.components(separatedBy: separator)}
                .flatMap { $0 }
        }
        return result
    }
}

extension Text {
    init(_ astring: NSAttributedString) {
        self.init("")
        
        astring.enumerateAttributes(in: NSRange(location: 0, length: astring.length), options: []) { (attrs, range, _) in
            
            var t = Text(astring.attributedSubstring(from: range).string)

            if let color = attrs[NSAttributedString.Key.foregroundColor] as? UIColor {
                t  = t.foregroundColor(Color(color))
            }

            if let font = attrs[NSAttributedString.Key.font] as? UIFont {
                t  = t.font(.init(font))
            }

            if let kern = attrs[NSAttributedString.Key.kern] as? CGFloat {
                t  = t.kerning(kern)
            }
            
            
            if let striked = attrs[NSAttributedString.Key.strikethroughStyle] as? NSNumber, striked != 0 {
                if let strikeColor = (attrs[NSAttributedString.Key.strikethroughColor] as? UIColor) {
                    t = t.strikethrough(true, color: Color(strikeColor))
                } else {
                    t = t.strikethrough(true)
                }
            }
            
            if let baseline = attrs[NSAttributedString.Key.baselineOffset] as? NSNumber {
                t = t.baselineOffset(CGFloat(baseline.floatValue))
            }
            
            if let underline = attrs[NSAttributedString.Key.underlineStyle] as? NSNumber, underline != 0 {
                if let underlineColor = (attrs[NSAttributedString.Key.underlineColor] as? UIColor) {
                    t = t.underline(true, color: Color(underlineColor))
                } else {
                    t = t.underline(true)
                }
            }
            
            self = self + t
            
        }
    }
}


//import Foundation
//
//extension StringProtocol {
//    func index<S: StringProtocol>(of string: S, options: String.CompareOptions = []) -> Index? {
//        range(of: string, options: options)?.lowerBound
//    }
//    func endIndex<S: StringProtocol>(of string: S, options: String.CompareOptions = []) -> Index? {
//        range(of: string, options: options)?.upperBound
//    }
//    func indices<S: StringProtocol>(of string: S, options: String.CompareOptions = []) -> [Index] {
//        ranges(of: string, options: options).map(\.lowerBound)
//    }
//    func ranges<S: StringProtocol>(of string: S, options: String.CompareOptions = []) -> [Range<Index>] {
//        var result: [Range<Index>] = []
//        var startIndex = self.startIndex
//        while startIndex < endIndex,
//            let range = self[startIndex...]
//                .range(of: string, options: options) {
//                result.append(range)
//                startIndex = range.lowerBound < range.upperBound ? range.upperBound :
//                    index(range.lowerBound, offsetBy: 1, limitedBy: endIndex) ?? endIndex
//        }
//        return result
//    }
//}
