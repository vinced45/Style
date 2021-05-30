//
//  TokenSearchBar.swift
//  Scene Me
//
//  Created by Vince Davis on 5/14/21.
//

import SwiftUI

struct TokenSearchBar {
    @Binding var searchText: [String]
}

extension TokenSearchBar: UIViewRepresentable {

    internal func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    func makeUIView(context: Context) -> UISearchBar {
        //Configures the Search Bar
        let searchBar = UISearchBar()

        searchBar.delegate = context.coordinator

        return searchBar
    }

    func updateUIView(_ searchBar: UISearchBar, context: Context) {

        if context.coordinator.searchText != searchText {
            context.coordinator.searchText = searchText
        }
    }


    /// Coordinator and delegate for the searchbar
    internal class Coordinator: NSObject, UISearchBarDelegate {
        var parent: TokenSearchBar

        var searchBar: UISearchBar?

        var searchText: [String] = [] {
            didSet {
                guard let searchBar = searchBar else {
                    return
                }

                //get the current search array
                var tokenSearchText = searchText

                let lastSearchTextItem: String

                if tokenSearchText.isEmpty {
                    lastSearchTextItem = ""
                } else {
                    lastSearchTextItem = tokenSearchText.removeLast()
                }

                //compare them with the search array
                tokenSearchText.enumerated().forEach {
                    offset, searchString in

                    //Get the current tokens.
                    let currentTokens = searchBar.searchTextField.tokens

                    //Check if the number of tokens on display can be displayed with this offset. If not it will create a new token at the end.
                    if currentTokens.count > offset {

                        //Check if the token at this offset has the same object as the searchstring. If not will insert a new token on this offset.
                        //I will assume that all represented objects are strings
                        if let representedObject = currentTokens[offset].representedObject as? String, representedObject != searchString {
                            let newToken = UISearchToken(icon: nil, text: searchString)
                            newToken.representedObject = searchString

                            searchBar.searchTextField.tokens.insert(newToken, at: offset)
                        }

                    } else {
                        let newToken = UISearchToken(icon: nil, text: searchString)
                        newToken.representedObject = searchString

                        self.searchBar?.searchTextField.tokens.append(newToken)
                    }
                }

                //Trim the number of tokens to be equal to the tokenSearchText
                let tokensToRemove = searchBar.searchTextField.tokens.count - tokenSearchText.count
                if tokensToRemove > 0 {
                    searchBar.searchTextField.tokens.removeLast(tokensToRemove)
                }

                //make the search field text equal to lastSearchTextItem
                if searchBar.text != lastSearchTextItem {
                    searchBar.text = lastSearchTextItem
                }

                if parent.searchText != self.searchText {
                    parent.searchText = self.searchText

                }
            }
        }


        init(_ searchBar: TokenSearchBar) {
            self.parent = searchBar
        }

        //MARK: UISearchBarDelegate implementation
        func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
            self.searchBar = searchBar

            searchText = []
        }

        func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
            self.searchBar = searchBar

            //add a new level to the search
            if searchText.last?.trimmingCharacters(in: .whitespacesAndNewlines) != "" {
                searchText.append("")
            }
        }

        func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
            self.searchBar = searchBar

            if self.searchText.last != nil,  self.searchText[self.searchText.count - 1] != searchText {
                self.searchText[self.searchText.count - 1] = searchText
            } else {

                var tokenText = searchBar.searchTextField.tokens.compactMap{$0.representedObject as? String}

                tokenText.append(searchText)

                self.searchText = tokenText

            }
        }
    }
}
