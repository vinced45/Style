//
//  View+Extensions.swift
//  Style
//
//  Created by Vince Davis on 1/21/21.
//

import SwiftUI

extension View {
  func hapticFeedbackOnTap(style: UIImpactFeedbackGenerator.FeedbackStyle = .light) -> some View {
    self.onTapGesture {
      let impact = UIImpactFeedbackGenerator(style: style)
      impact.impactOccurred()
    }
  }

}
