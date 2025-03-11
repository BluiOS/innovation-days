//
//  MockConcept.swift
//  MockDataPresentation
//
//  Created by Hossein Hajimirza on 3/11/25.
//

import Foundation

// Mock: Provides predefined responses and allows you to verify interactions (method calls).

protocol NetworkService {
    func fetchData(url: String, completion: @escaping (Data?) -> Void)
}

class DataManager {
    private let networkService: NetworkService

    init(networkService: NetworkService) {
        self.networkService = networkService
    }

    func fetchDataFromAPI(url: String, completion: @escaping (Data?) -> Void) {
        networkService.fetchData(url: url) { data in
            completion(data)
        }
    }
}
