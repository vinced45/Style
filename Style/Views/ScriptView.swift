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
    @State var scenesWithoutNumbers: [PDFScene] = []
    @State private var isImporting: Bool = false
    
    @State private var isUploading: Bool = false
    
    @State var showPdf: Bool = false
    
    @EnvironmentObject var session: SessionStore
    
    var body: some View {
        NavigationView {
            ZStack {
                LoadingView(text: "Uploading Script")
                    .zIndex(1.0)
                    .opacity(isUploading ? 1.0 : 0.0)
                
                VStack(alignment: .center) {
                    Text(title)
                        .multilineTextAlignment(.center)
                        .padding(.top)
                    
                    Button(action: { showPdf.toggle() }) {
                        Text("Show Script")
                    }
                    .sheet(isPresented: $showPdf, content: {
                        PDFKitView(url: URL(string: fileUrl)!, showSheet: $showPdf)
                    })
                    
                    List {
                        Section(header: Text("Scenes with Numbers")) {
                            ForEach(scenes.indices, id: \.self) { i in
                                let scene = scenes[i]
                                NavigationLink(destination: ScriptSceneUpdateView(scene: $scenes[i], scriptUrl: fileUrl)) {
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
                            .onDelete(perform: removeRows)
                        }
                        
                        Section(header: Text("Scenes without Numbers")) {
                            ForEach(scenesWithoutNumbers.indices, id: \.self) { i in
                                let scene = scenesWithoutNumbers[i]
                                NavigationLink(destination: ScriptSceneUpdateView(scene: $scenesWithoutNumbers[i], scriptUrl: fileUrl)) {
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
                            .onDelete(perform: removeRows2)
                        }
                    }.listStyle(GroupedListStyle())
                }
                .zIndex(2.0)
            }
            .navigationBarTitle(Text("Import Script"), displayMode: .inline)
            .navigationBarItems(leading: Button(action: {
                self.showSheetView = false
            }) {
                Text("Cancel").bold()
            }, trailing: Button(action: {
                isUploading = true
                let saveScenes = scenes + scenesWithoutNumbers
                viewModel.save(pdfScenes: saveScenes, with: getFirstLine(from: title), user: session.session?.uid ?? "") {
                    self.showSheetView = false
                    isUploading = false
                }
                
            }) {
                Text("Save").bold()
            })
            .onAppear {
                parse()
            }
        }
    }
    
    func removeRows(at offsets: IndexSet) {
        scenes.remove(atOffsets: offsets)
    }
    
    func removeRows2(at offsets: IndexSet) {
        scenesWithoutNumbers.remove(atOffsets: offsets)
    }
    
    func parse() {
        guard let url = URL(string: fileUrl) else { return
            print("import script - unable to find url")
        }
        PDFReader.parseTitle(for: url) { attrString in
            title = attrString.string
        }
        
        PDFReader.parseScenes(for: url) { scene in
            if !scenes.contains(scene) && !scene.number.isEmpty {
                scenes.append(scene)
            }
            
            if !scenesWithoutNumbers.contains(scene) && scene.number.isEmpty {
                scenesWithoutNumbers.append(scene)
            }
        }
    }
    
    func getFirstLine(from text: String) -> String {
        if let firstLine = text.components(separatedBy: "\n").first {
            return firstLine
        } else {
            return ""
        }
    }
}

//struct ScriptView_Previews: PreviewProvider {
//    static var previews: some View {
//        ScriptView()
//    }
//}

struct PDFScene: Hashable, Equatable {
    var number: String
    var text: String
    var details: String
    
    static func ==(lhs:PDFScene, rhs:PDFScene) -> Bool {
        return (lhs.number == rhs.number) && (lhs.text == rhs.text) && (lhs.details == rhs.details)
    }
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


struct PDFKitRepresentedView: UIViewRepresentable {
    let url: URL

    init(_ url: URL) {
        self.url = url
    }

    func makeUIView(context: UIViewRepresentableContext<PDFKitRepresentedView>) -> PDFKitRepresentedView.UIViewType {
        // Create a `PDFView` and set its `PDFDocument`.
        let pdfView = PDFView()
        pdfView.document = PDFDocument(url: self.url)
        return pdfView
    }

    func updateUIView(_ uiView: UIView, context: UIViewRepresentableContext<PDFKitRepresentedView>) {
        // Update the view.
    }
}

struct PDFKitView: View {
    var url: URL
    @Binding var showSheet: Bool

    var body: some View {
        NavigationView {
            PDFKitRepresentedView(url)
                .navigationBarTitle(Text("Script"), displayMode: .inline)
                .navigationBarItems(leading: Button(action: {
                    self.showSheet = false
                }) {
                    Text("Done").bold()
                })
        }
    }
}
