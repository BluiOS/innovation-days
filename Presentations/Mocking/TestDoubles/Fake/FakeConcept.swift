//
//  FakeConcept.swift
//  MockDataPresentation
//
//  Created by Hossein Hajimirza on 3/11/25.
//

import Foundation

protocol DatabaseService {
    func fetchUserData(userId: String) -> User
}

class FakeDatabaseService: DatabaseService {
    func fetchUserData(userId: String) -> User {
        return User(id: userId, name: "John Doe")
    }
}

class UserManager {
    private let databaseService: DatabaseService

    init(databaseService: DatabaseService) {
        self.databaseService = databaseService
    }

    func getUserData(userId: String) -> User {
        return databaseService.fetchUserData(userId: userId)
    }
}

struct User {
    let id: String
    let name: String
}
