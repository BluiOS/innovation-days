//
//  OrderProcessor.swift
//  MockDataPresentation
//
//  Created by Hossein Hajimirza on 3/11/25.
//

import Foundation

protocol PaymentService {
    func chargeUser(for amount: Double)
}

protocol NotificationService {
    func sendOrderConfirmation(to user: User)
}

struct Order {
    var amount: Double
    var user: User
    var status: OrderStatus
}

struct User {
    var name: String
}

enum OrderStatus {
    case pending, processed
}


class OrderProcessor {
    private let paymentService: PaymentService
    private let notificationService: NotificationService

    init(paymentService: PaymentService, notificationService: NotificationService) {
        self.paymentService = paymentService
        self.notificationService = notificationService
    }

    func processOrder(order: Order) {
        // Step 1: Charge user (we want to mock this part in our test)
        paymentService.chargeUser(for: order.amount)

        // Step 2: Send notification (we also want to mock this part)
        notificationService.sendOrderConfirmation(to: order.user)

        // Step 3: Update internal order status (this we want to test normally)
//        order.status = .processed
    }
}
