//
//  CounterViewModel.swift
//  MVICounter
//
//  Created by HEssam on 4/8/25.
//

import Foundation
import SwiftUI

@Observable
final class CounterViewModel {

    var store: CounterStore = CounterStore()
    
    var state: CounterState {
        store.state
    }
    
    func send(_ intent: CounterIntent) {
        let action = intent.mapToAction()
        store.send(action)
    }
}
