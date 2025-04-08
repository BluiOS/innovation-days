//
//  BaseMVI.swift
//  MVICounter
//
//  Created by HEssam on 4/8/25.
//

import Foundation

protocol MVIIntent {
    associatedtype Action: MVIAction
    
    func mapToAction() -> Action
}

protocol MVIAction {
    
}

protocol MVIResult {
    
}

protocol MVIProcessor {
    associatedtype Action: MVIAction
    associatedtype Result: MVIResult
    
    func process(_ action: Action) -> Result
}

protocol MVIState {
    
}

protocol MVIReducer {
    associatedtype Result: MVIResult
    associatedtype State: MVIState
    
    func reduce(_ result: Result, currentState state: State) -> State
}

protocol MVINavigator {
    
}

protocol MVIStore: AnyObject {
    associatedtype Reducer: MVIReducer
    associatedtype Processor: MVIProcessor
    associatedtype Action: MVIAction where Action == Processor.Action
    associatedtype State: MVIState where State == Reducer.State
    associatedtype Navigator: MVINavigator
    
    var reducer: Reducer { get }
    var processor: Processor { get }
    var state: State { get }
    var navigator: Navigator { get }
    
    func send(_ action: Action)
}
