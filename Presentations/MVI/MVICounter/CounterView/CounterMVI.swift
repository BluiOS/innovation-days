//
//  CounterMVI.swift
//  MVICounter
//
//  Created by HEssam on 4/8/25.
//

import Foundation
import SwiftUI

enum CounterIntent: MVIIntent {
    case userIncremented
    case userDecremented
    case navigateToDetail
    
    func mapToAction() -> CounterAction {
        return switch self {
        case .userIncremented: .increment
        case .userDecremented: .decrement
        case .navigateToDetail: .navigateToDetail
        }
    }
}

enum CounterAction: MVIAction {
    case increment
    case decrement
    case navigateToDetail
}

enum CounterResult: MVIResult, Equatable {
    case counterUpdated(Int)
    case navigateToDetail
}

struct CounterProcessor: MVIProcessor {
    typealias Action = CounterAction
    typealias Result = CounterResult
    
    private var counterNetwork = CounterNetwork()
    
    func process(_ action: CounterAction) -> CounterResult {
        return switch action {
        case .increment: .counterUpdated(counterNetwork.fetchMultipleCount())
        case .decrement: .counterUpdated(counterNetwork.fetchMultipleCount() * -1)
        case .navigateToDetail: .navigateToDetail
        }
    }
}

struct CounterState: MVIState {
    var count: Int = 0
}

struct CounterReducer: MVIReducer {
    typealias Result = CounterResult
    typealias State = CounterState
    
    func reduce(_ result: CounterResult, currentState state: CounterState) -> CounterState {
        var newState = state
        
        switch result {
        case .counterUpdated(let int):
            newState.count = max(0, newState.count + int)
            
        default: break
        }
        
        return newState
    }
}

enum CounterNavigator: MVINavigator {
    case navigateToDetail
}

extension NavigationPath: MVINavigator { }

@Observable
final class CounterStore: MVIStore {
    typealias Reducer = CounterReducer
    typealias Processor = CounterProcessor
    typealias Action = CounterAction
    typealias State = CounterState
    typealias Navigator = NavigationPath
    
    var processor = CounterProcessor()
    var reducer = CounterReducer()
    var state = CounterState()
    var navigator = NavigationPath()
    
    func send(_ action: CounterAction) {
        let result = processor.process(action)
        
        switch result {
        case .navigateToDetail:
            navigator.append(CounterNavigator.navigateToDetail)
            
        default:
            state = reducer.reduce(result, currentState: state)
        }
    }
}
