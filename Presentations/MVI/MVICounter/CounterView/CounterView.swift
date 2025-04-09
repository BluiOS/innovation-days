//
//  CounterView.swift
//  MVICounter
//
//  Created by HEssam on 4/8/25.
//

import SwiftUI

struct CounterView: View {
    
    @State private var viewModel: CounterViewModel = .init()
    
    var body: some View {
        NavigationStack(path: $viewModel.store.navigator) {
            VStack(spacing: 20) {
                Text("count is \(viewModel.state.count)")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                Stepper("Change Counter with theses buttons") {
                    viewModel.send(.userIncremented)
                } onDecrement: {
                    viewModel.send(.userDecremented)
                }
                
                Button("Go to Detail") {
                    viewModel.send(.navigateToDetail)
                }
                .navigationDestination(for: CounterNavigator.self) { navigator in
                    switch navigator {
                    case .navigateToDetail:
                        DetailView()
                    }
                }
            }
        }
    }
}

#Preview {
    CounterView()
}
