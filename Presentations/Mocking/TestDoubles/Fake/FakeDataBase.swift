//
//  FakeDataBase.swift
//  MockDataPresentation
//
//  Created by Hossein Hajimirza on 3/11/25.
//

import Foundation

// Fake: A simplified implementation of a dependency.

// The FakeDatabase simulates a database with simple in-memory storage,
// allowing us to test the behavior of DataManager without needing a real database.

protocol Database {
    func save(data: String)
    func fetch() -> String?
}

class FakeDatabase: Database {
    private var storedData: String?

    func save(data: String) {
        storedData = data
    }

    func fetch() -> String? {
        return storedData
    }
}

class DataManager {
    var database: Database

    init(database: Database) {
        self.database = database
    }

    func saveData(data: String) {
        database.save(data: data)
    }

    func getData() -> String? {
        return database.fetch()
    }
}

// Test using FakeDatabase
let fakeDatabase = FakeDatabase()
let dataManager = DataManager(database: fakeDatabase)
dataManager.saveData(data: "test data")
print(dataManager.getData()) // Output: test data
