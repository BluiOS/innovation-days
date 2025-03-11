//
//  SpyConcept.swift
//  MockDataPresentation
//
//  Created by Hossein Hajimirza on 3/11/25.
//

import Foundation
import Cuckoo
import XCTest

// Spy: Tracks method calls to verify how many times and with what parameters they were called.

// We'll track how many times fetchData was called:

class DataManagerTests: XCTestCase {
    var mockNetworkService: MockNetworkService!
    var dataManager: DataManager!

    override func setUp() {
        super.setUp()
        mockNetworkService = MockNetworkService()
        dataManager = DataManager(networkService: mockNetworkService)
    }

    func testFetchDataFromAPI_CallsNetworkServiceOnce() {
        // Arrange
        let url = "https://example.com"
        let spy = SpyOn(fetchData: { _ in })
        stub(mockNetworkService) { mock in
            when(mock.fetchData(url: any(), completion: any())).thenDoNothing()
        }

        // Act
        dataManager.fetchDataFromAPI(url: url) { _ in }

        // Verify
        verify(mockNetworkService).fetchData(url: url, completion: any())
    }
}
