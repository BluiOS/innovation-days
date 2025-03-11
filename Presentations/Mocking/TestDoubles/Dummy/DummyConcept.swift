//
//  DummyConcept.swift
//  MockDataPresentation
//
//  Created by Hossein Hajimirza on 3/11/25.
//

import Foundation

// Dummy: Not used in the test but required by the API.

// The DummyLogger class satisfies the Logger interface but doesn't do anything
// It allows the test to run even though logging behavior isn't the focus

protocol Logger {
    func log(message: String)
}

class Service {
    var logger: Logger
    init(logger: Logger) {
        self.logger = logger
    }

    func executeAction() {
        logger.log(message: "Action executed.")
    }
}

class DummyLogger: Logger {
    func log(message: String) {
        // Does nothing
    }
}

let dummyLogger = DummyLogger()
let service = Service(logger: dummyLogger)
service.executeAction() // No verification is needed here
