//
//  SheetState.swift
//  Style
//
//  Created by Vince Davis on 1/11/21.
//

import SwiftUI

class SheetState<State>: ObservableObject {
    @Published var isShowing = false
    @Published var state: State? {
        didSet { isShowing = state != nil }
    }
}
