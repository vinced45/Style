//
//  MultipleSelectionRow.swift
//  Style
//
//  Created by Vince Davis on 12/7/20.
//

import SwiftUI

struct MultipleSelectionRow: View {
    var item: String
    var isSelected: Bool
    var action: () -> Void

    var body: some View {
        Button(action: self.action) {
            HStack {
                Text(self.item)
                Spacer()
                if self.isSelected {
                    Image(systemName: "checkmark.rectangle")
                } else {
                    Image(systemName: "rectangle")
                }
            }
        }
        .foregroundColor(Color.black)
    }
}

struct MultipleSelectionRow_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            MultipleSelectionRow(item: "Test", isSelected: true) { }
                .previewLayout(.sizeThatFits)
                .padding()
            MultipleSelectionRow(item: "Test", isSelected: false) { }
                .previewLayout(.sizeThatFits)
                .padding()
        }
    }
}
