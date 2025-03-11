//
//  PartialMockingTest.swift
//  MockDataPresentation
//
//  Created by Hossein Hajimirza on 3/11/25.
//

import Foundation
import Cuckoo
import XCTest

class OrderProcessorTests: XCTestCase {
    var mockPaymentService: MockPaymentService!
    var mockNotificationService: MockNotificationService!
    var orderProcessor: OrderProcessor!

    override func setUp() {
        super.setUp()

        // Create mocks for services
        mockPaymentService = MockPaymentService()
        mockNotificationService = MockNotificationService()

        // Create the real OrderProcessor instance with the mocked services
        orderProcessor = OrderProcessor(paymentService: mockPaymentService, notificationService: mockNotificationService)
    }

    func testProcessOrder_UpdatesOrderStatus() {
        // Arrange: Create an order
        let user = User(name: "John Doe")
        var order = Order(amount: 100.0, user: user, status: .pending)

        // Stub the methods we want to mock
        stub(mockPaymentService) { mock in
            when(mock.chargeUser(for: any())).thenDoNothing()
        }

        stub(mockNotificationService) { mock in
            when(mock.sendOrderConfirmation(to: any())).thenDoNothing()
        }

        // Act: Process the order
        orderProcessor.processOrder(order: order)

        // Assert: The order status should be updated to 'processed'
        XCTAssertEqual(order.status, .processed)

        // Verify that the mocked methods were called
        verify(mockPaymentService).chargeUser(for: order.amount)
        verify(mockNotificationService).sendOrderConfirmation(to: order.user)
    }
}
