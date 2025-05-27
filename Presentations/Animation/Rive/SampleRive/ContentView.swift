//
//  ContentView.swift
//  SampleRive
//
//  Created by HEssam on 5/27/25.
//

import SwiftUI
import RiveRuntime

struct ContentView: View {
    @StateObject private var rvm = SleepOnboardingViewModel()
    
    var body: some View {
        VStack {
            rvm.view()
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                rvm.fallen()
            }
        }
    }
}

#Preview {
    ContentView()
}
