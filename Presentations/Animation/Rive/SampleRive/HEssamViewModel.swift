//
//  HEssamViewModel.swift
//  SampleRive
//
//  Created by HEssam on 5/27/25.
//

import SwiftUI
import RiveRuntime

class HEssamViewModel: RiveViewModel {
    
    private var stateMachine: RiveStateMachineInstance?

    init() {
        super.init(fileName: "sleep_onboarding_screen")//, stateMachineName: "Velocidade normal")
        
        do {
            let file = try RiveFile(name: "sleep_onboarding_screen")
            let artboard = try file.artboard()
            for name in artboard.stateMachineNames() {
                print("State machine Name: \(name)")
            }
            let stateMachine = try artboard.stateMachine(fromName: "Velocidade normal")
            print(stateMachine.name())
            self.stateMachine = stateMachine

            let inputs = stateMachine.inputs
            for input in inputs {
                print("Input name: \(input.name), type: \(type(of: input))")
            }

        } catch {
            print("Failed to load Rive file or state machine: \(error)")
        }
    }

    func view() -> some View {
        return super.view()
    }
    
    func fallen() {
        let viewModel = self.riveModel!.riveFile.viewModelNamed("View Model 1")
        let instance = viewModel!.createDefaultInstance()!
        
        riveModel!.stateMachine?.bind(viewModelInstance: instance)
        
        instance.numberProperty(fromPath: "Fallen leafs")!.value = 3 // leaf is index 3
        
        Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { _ in
//            self.setInput("pink squashes", value: true)
//            self.triggerInput("pink squashes")
            self.triggerInput("galho shakes")
        }
    }
    
}
