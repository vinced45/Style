//
//  GalleryView.swift
//  Scene Me
//
//  Created by Vince Davis on 5/14/21.
//

import SwiftUI
//import SwiftlySearch

struct GalleryView: View {
    let items: [String] = (1...100).map { "Item \($0)" }

    @State  var searchText = ""
    @State  var searchTexts: [String] = []

    @State var columnSelection: Int = 0
    @State var height: CGFloat = 200
    @State var currentColumns: [GridItem] = [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]
    
    var listType = ["square.grid.3x3.fill", "photo.fill"]
    
    var oneColumns: [GridItem] = [GridItem(.flexible())]
    var twoColumns: [GridItem] = [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]
    
    @State var showMainView: Bool = true
    
    @ObservedObject var searchBar: SearchBar = SearchBar()

    var body: some View {
        VStack {
            if showMainView {
                ScrollView {
                    Picker(selection: $columnSelection, label: Text("")) {
                        Image(systemName: "square.grid.3x3.fill").tag(0)
                        Image(systemName: "photo.fill").tag(1)
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .padding()
                    LazyVGrid(columns: currentColumns, spacing: 0.5) {
                        ForEach(items.filter { searchTexts.contains($0) }, id: \.self) { item in
                            Image("viola-3")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(maxHeight: height)
                        }
                    }
                    .padding(.horizontal, 0.5)
                    //.animation(.easeOut, value: currentColumns)
                }
                //.opacity(showMainView ? 1 : 0)
                //.animation(.easeIn, value: .opacity)
            } else {
                List(items.filter { $0.localizedStandardContains(searchBar.text) }, id: \.self) { item in
                    Text(item)
                        .onTapGesture {
                            add(tokenString: item)
                        }
                }
            }
            
        }
        
        //.navigationBarSearch($searchText)
        .navigationTitle("Gallery")
        .navigationBarItems(trailing:
            HStack {
                Button(action: {}) {
                    Image(systemName: "person.circle.fill")
                        .font(.largeTitle)
                }
                
                Button(action: {}) {
                    Image(systemName: "camera.circle.fill")
                        .font(.largeTitle)
                }
            }
        )
        .add(searchBar)
        .onChange(of: searchBar.didDismiss, perform: { value in
            withAnimation {
                showMainView = value
            }
            updateTokens()
        })
        .onChange(of: columnSelection, perform: { value in
            if value == 0 {
                withAnimation {
                    currentColumns = twoColumns
                    height = 200
                }
            } else {
                withAnimation {
                    currentColumns = oneColumns
                    height = 500
                }
            }
        })
    }
}

extension GalleryView {
    func add(tokenString: String) {
        let token = UISearchToken(icon: UIImage(systemName: "person.fill"), text: tokenString)
        searchBar.searchController.searchBar.searchTextField.tokens.append(token)
        
        searchTexts.append(tokenString)
        //searchBar.searchController.searchBar.searchTextField.text = ""
    }
    
    func updateTokens() {
        var newTokens: [String] = []
        for token in searchBar.searchController.searchBar.searchTextField.tokens {
            newTokens.append(token.value(forKey: "text") as! String)
        }
        print("tokens \(newTokens)")
        searchTexts = newTokens
    }
}

struct GalleryView_Previews: PreviewProvider {
    
    
    static var previews: some View {
        let data = (1...100).map { "Item \($0)" }
        GalleryView()
    }
}
