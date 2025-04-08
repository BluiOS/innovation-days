//
//  MVICounterTests.swift
//  MVICounterTests
//
//  Created by HEssam on 4/8/25.
//

import Testing
@testable import MVICounter

struct MVICounterTests {
    
    // processor
    @Test
    func processorIncrement() {
        let processor = CounterProcessor()
        let result = processor.process(.increment)
        #expect(result == .counterUpdated(10))
    }
    
    @Test
    func processorDecrement() {
        let processor = CounterProcessor()
        let result = processor.process(.decrement)
        #expect(result == .counterUpdated(-10))
    }
    
    @Test
    func processorNavigation() {
        let processor = CounterProcessor()
        let result = processor.process(.navigateToDetail)
        #expect(result == .navigateToDetail)
    }
    
    // reducer
    @Test
    func reducerAddsCorrectly() {
        let reducer = CounterReducer()
        let state = CounterState(count: 2)
        let result = CounterResult.counterUpdated(3)
        let newState = reducer.reduce(result, currentState: state)
        #expect(newState.count == 5)
    }
    
    @Test
    func reducerSubtractsCorrectly() {
        let reducer = CounterReducer()
        let state = CounterState(count: 5)
        let result = CounterResult.counterUpdated(-2)
        let newState = reducer.reduce(result, currentState: state)
        #expect(newState.count == 3)
    }
    
    // store
    @Test
    func testStoreFlow() {
        let store = CounterStore()
        #expect(store.state.count == 0)
        
        store.send(.increment)
        #expect(store.state.count == 10)
        
        store.send(.decrement)
        #expect(store.state.count == 0)
        
        store.send(.decrement)
        #expect(store.state.count != -1)
        
        store.send(.decrement)
        #expect(store.state.count == 0)
        
        store.send(.navigateToDetail)
        #expect(store.navigator.count == 1)
    }
}
