//
//  FakeUserTests.swift
//  MockDataPresentation
//
//  Created by Hossein Hajimirza on 3/11/25.
//

import Foundation
import XCTest

class UserManagerTests: XCTestCase {
    var fakeDatabaseService: FakeDatabaseService!
    var userManager: UserManager!

    override func setUp() {
        super.setUp()
        fakeDatabaseService = FakeDatabaseService()
        userManager = UserManager(databaseService: fakeDatabaseService)
    }

    func testGetUserData_ReturnsCorrectData() {
        // Arrange
        let userId = "123"

        // Act
        let user = userManager.getUserData(userId: userId)

        // Assert
        XCTAssertEqual(user.id, userId)
        XCTAssertEqual(user.name, "John Doe")
    }
}
