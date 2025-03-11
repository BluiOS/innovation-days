### What is **Partial Mocking**?

**Partial Mocking** is a technique where only **some methods** of a class are replaced by mocks, while others remain with their real implementations. 

This is useful when you want to **mock** or **stub** specific methods of a class, but you want **other methods to still run normally** (i.e., you don't want to replace the whole class's behavior, just part of it).

In Swift, **partial mocking** is typically used when you have a class with some logic that you want to test in isolation, but other methods of the same class should execute normally without modification.

### Why Use Partial Mocking?

Partial mocking comes into play when:
1. You have a class with complex logic where mocking the entire class is unnecessary, but you still want to isolate specific methods to control or verify their behavior.
2. You want to test **only a portion of a class's behavior** without altering the rest.

It allows you to focus on just the part of the class you're testing and **avoid unnecessary mocking** of parts that you don't need to change for the test.

### Example Use Case for Partial Mocking

Let's imagine you have a **complex class** where some methods are difficult to test in isolation because they depend on external systems (like a network call or database). You may want to mock only those parts that are external dependencies and keep the rest of the class's logic intact for testing.

### Example: Partial Mocking in Action

Consider a class called `OrderProcessor` that processes orders. It calls an external service to **charge a user’s account** and **send a notification** after an order is successfully processed. However, we want to **test the core logic** of processing an order without actually charging the user or sending a notification (since those operations involve external dependencies).

Here’s how we could use partial mocking to mock only certain parts of the `OrderProcessor` class while allowing others to run normally.

### Step 1: Define the `OrderProcessor` class

```swift
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
        order.status = .processed
    }
}
```

### Step 2: Define the supporting services (`PaymentService` and `NotificationService`)

```swift
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
```

### Step 3: Partial Mocking in a Test

We want to test that `processOrder` updates the order status to `.processed`, **but we don't want to actually charge the user or send a notification**. So, we **partially mock** the `PaymentService` and `NotificationService` methods, but we allow the `OrderProcessor`'s internal logic to run.

```swift
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
```

### Explanation of the Example

1. **Partial Mocking**: 
   - In the test, we only stub the `chargeUser(for:)` and `sendOrderConfirmation(to:)` methods from the `PaymentService` and `NotificationService`, respectively. These are the external calls we don't want to actually execute.
   - The rest of the `processOrder` method (`order.status = .processed`) **runs normally**, because we're not mocking it.
   
2. **Test Focus**:
   - We focus on verifying that the `OrderProcessor` **correctly updates the order's status** after calling the services. This tests the **core logic** of the method, while isolating the external dependencies.
   
3. **Mocking External Dependencies**:
   - We're only mocking the external dependencies (`paymentService` and `notificationService`) so that we don't make real payments or send real notifications during testing.
   
4. **Assertions**:
   - We assert that the order's status is set to `.processed` after calling `processOrder`.
   - We also verify that the `chargeUser` and `sendOrderConfirmation` methods were indeed called.

---

### When to Use Partial Mocking

- **Realistic but Controlled Tests**: You want to test the **internal logic** of a method but don't want to execute the real external code (like making network requests, writing to a database, etc.).
- **When some parts of the class are too complex to test directly**: For example, if the class does many things, and you only care about testing one part, partial mocking allows you to mock the parts that are external or complex.
- **When you don’t want to fully mock the class**: If you want some parts of the class to behave as normal while replacing only a subset of methods, partial mocking is ideal.

### Key Takeaways:
- **Partial mocking** allows you to mock only specific methods of a class, leaving others to execute their real behavior.
- It's used when you don't need to mock the entire class but want to isolate specific functionality or interactions in your tests.
  
In Swift, **partial mocking** can be tricky because Swift is a value-oriented language, and mocking frameworks (like Cuckoo) may not fully support this as easily as in other languages like Java or Python. However, when partial mocking is necessary, it's usually possible with the right mocking framework or by combining techniques like dependency injection and test doubles.
