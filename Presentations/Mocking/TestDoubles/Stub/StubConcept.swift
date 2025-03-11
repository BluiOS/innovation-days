//
//  StubConcept.swift
//  MockDataPresentation
//
//  Created by Hossein Hajimirza on 3/11/25.
//

import Foundation
import Cuckoo
import XCTest

// Stub: Provides predefined responses to method calls.

// we stub the fetchData method to return a predefined Data object when called:

class DataManagerTests: XCTestCase {
    var mockNetworkService: MockNetworkService!
    var dataManager: DataManager!

    override func setUp() {
        super.setUp()
        mockNetworkService = MockNetworkService()
        dataManager = DataManager(networkService: mockNetworkService)
    }

    func testFetchDataFromAPI_ReturnsData() {
        // Arrange
        let url = "https://example.com"
        let expectedData = Data()

        stub(mockNetworkService) { mock in
            when(mock.fetchData(url: url, completion: any())).then { _, completion in
                completion(expectedData)
            }
        }

        // Act
        var receivedData: Data?
        dataManager.fetchDataFromAPI(url: url) { data in
            receivedData = data
        }

        // Assert
        XCTAssertEqual(receivedData, expectedData)
    }
}
