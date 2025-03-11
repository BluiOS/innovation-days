//
//  MockTests.swift
//  MockDataPresentation
//
//  Created by Hossein Hajimirza on 3/11/25.
//

import Foundation
import Cuckoo
import XCTest

// we mocked the NetworkService and verified that the fetchData method was called:

class DataManagerTests: XCTestCase {
    var mockNetworkService: MockNetworkService!
    var dataManager: DataManager!

    override func setUp() {
        super.setUp()
        mockNetworkService = MockNetworkService()
        dataManager = DataManager(networkService: mockNetworkService)
    }

    func testFetchDataFromAPI_CallsNetworkService() {
        // Arrange
        let url = "https://example.com"
        stub(mockNetworkService) { mock in
            when(mock.fetchData(url: any(), completion: any())).thenDoNothing()
        }

        // Act
        dataManager.fetchDataFromAPI(url: url) { data in
            // Verifying the mock interaction
            verify(self.mockNetworkService).fetchData(url: url, completion: any())
        }
    }
}
