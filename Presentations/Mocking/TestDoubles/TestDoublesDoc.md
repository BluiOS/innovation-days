**Test Doubles** are objects or components that stand in for real dependencies in tests, allowing you to isolate parts of your system and test them independently. They simulate the behavior of real objects and are used to replace real dependencies, particularly in situations where calling real objects would be expensive, unreliable, or involve external systems (e.g., network calls, database queries).

Test doubles come in several forms, and each is used for different purposes. The main types are:

1. **Dummy**: Used when the argument is required but not actually used in the test. It doesn’t affect the test.
2. **Fake**: A simplified version of the real dependency. It behaves like the real thing but doesn't do everything the real dependency does.
3. **Stub**: Provides predefined responses to method calls, allowing you to control the behavior of the dependency during the test.
4. **Mock**: Similar to a stub but with the additional ability to verify interactions. Mocks allow you to verify that specific methods were called, and with which parameters.
5. **Spy**: Tracks method calls to verify interactions during a test but doesn’t replace the behavior. It's typically used when you want to track how the method was called.

### Test Double Types with Examples

Let's break down how each test double is used and provide examples of verifying behavior using mocks.

---

### 1. **Dummy**

A **dummy** is used when an argument is required but not needed for the test. It doesn't affect the outcome of the test.

**Example:**

```swift
protocol Logger {
    func log(message: String)
}

class Service {
    var logger: Logger
    init(logger: Logger) {
        self.logger = logger
    }

    func executeAction() {
        logger.log(message: "Action executed.")
    }
}

class DummyLogger: Logger {
    func log(message: String) {
        // Does nothing
    }
}

let dummyLogger = DummyLogger()
let service = Service(logger: dummyLogger)
service.executeAction() // No verification is needed here
```

The `DummyLogger` class satisfies the `Logger` interface but doesn't do anything. It allows the test to run even though logging behavior isn't the focus.

---

### 2. **Fake**

A **fake** is a simple implementation of an interface that can be used in place of the real object for testing. It’s typically used when you don't want to use a complex real object (e.g., a real database), but you still need some of its behavior.

**Example:**

```swift
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
```

The `FakeDatabase` simulates a database with simple in-memory storage, allowing us to test the behavior of `DataManager` without needing a real database.

---

### 3. **Stub**

A **stub** provides predefined responses to method calls. It allows you to control the behavior of the dependency, such as returning specific values without actually executing the real method.

**Example:**

```swift
import Cuckoo
import XCTest

protocol NetworkService {
    func fetchData(url: String) -> String
}

class DataManager {
    private let networkService: NetworkService
    
    init(networkService: NetworkService) {
        self.networkService = networkService
    }

    func fetchDataFromAPI(url: String) -> String {
        return networkService.fetchData(url: url)
    }
}

// Stubbed NetworkService using Cuckoo
class NetworkServiceTests: XCTestCase {
    var mockNetworkService: MockNetworkService!
    var dataManager: DataManager!
    
    override func setUp() {
        super.setUp()
        mockNetworkService = MockNetworkService()
        dataManager = DataManager(networkService: mockNetworkService)
    }

    func testFetchDataFromAPI_ReturnsMockedData() {
        // Stub the fetchData method
        stub(mockNetworkService) { mock in
            when(mock.fetchData(url: any())).thenReturn("Mocked Data")
        }

        // Call the method under test
        let result = dataManager.fetchDataFromAPI(url: "https://example.com")
        
        // Verify the result
        XCTAssertEqual(result, "Mocked Data")
    }
}
```

In this example, we use **stubbing** to make `fetchData` always return `"Mocked Data"`, regardless of the URL. This allows us to test `fetchDataFromAPI` without actually performing a network request.

---

### 4. **Mock**

A **mock** is a test double that not only provides predefined responses but also allows you to verify that specific methods were called, and with what arguments. It's a powerful tool for **verifying behavior**.

**Example:**

```swift
import Cuckoo
import XCTest

class OrderProcessor {
    var paymentService: PaymentService
    
    init(paymentService: PaymentService) {
        self.paymentService = paymentService
    }
    
    func processOrder(amount: Double) {
        paymentService.chargeUser(for: amount)
    }
}

protocol PaymentService {
    func chargeUser(for amount: Double)
}

class PaymentServiceMock: Mock, PaymentService {
    func chargeUser(for amount: Double) {
        // Mock implementation for testing purposes
    }
}

class OrderProcessorTests: XCTestCase {
    var mockPaymentService: MockPaymentService!
    var orderProcessor: OrderProcessor!
    
    override func setUp() {
        super.setUp()
        mockPaymentService = MockPaymentService()
        orderProcessor = OrderProcessor(paymentService: mockPaymentService)
    }
    
    func testProcessOrder_VerifyPaymentServiceCall() {
        // Act: Call method under test
        orderProcessor.processOrder(amount: 100.0)
        
        // Assert: Verify that chargeUser method was called
        verify(mockPaymentService).chargeUser(for: 100.0)
    }
}
```

In this case, we used a **mock** to verify that the `chargeUser` method was called with the expected argument (`100.0`).

---

### 5. **Spy**

A **spy** is similar to a mock, but instead of replacing the behavior of methods, it **records method calls** and allows you to verify later. It's typically used when you don’t need to mock the behavior but just want to verify the interactions that happened.

**Example:**

```swift
class EmailService {
    func sendEmail(to recipient: String, subject: String) {
        // Sending email logic
    }
}

class EmailServiceSpy: EmailService {
    var emailsSent: [(String, String)] = []
    
    override func sendEmail(to recipient: String, subject: String) {
        emailsSent.append((recipient, subject))
    }
}

class OrderProcessor {
    private let emailService: EmailService
    
    init(emailService: EmailService) {
        self.emailService = emailService
    }
    
    func processOrder() {
        emailService.sendEmail(to: "user@example.com", subject: "Order Confirmation")
    }
}

// Test using EmailServiceSpy
let spyEmailService = EmailServiceSpy()
let orderProcessor = OrderProcessor(emailService: spyEmailService)

orderProcessor.processOrder()

// Verify that the spy recorded the email sent
assert(spyEmailService.emailsSent.count == 1)
assert(spyEmailService.emailsSent[0].0 == "user@example.com")
assert(spyEmailService.emailsSent[0].1 == "Order Confirmation")
```

Here, we use a **spy** to record the `sendEmail` method calls, allowing us to verify that the email was sent to the correct recipient with the expected subject.

---

### Conclusion

- **Test Doubles** are key tools in unit testing that replace real objects with simplified, controlled versions to isolate parts of your code.
  - **Dummy**: Not used in the test but required by the API.
  - **Fake**: A simplified implementation of a dependency.
  - **Stub**: Provides predefined responses to method calls.
  - **Mock**: Provides predefined responses and allows you to verify interactions (method calls).
  - **Spy**: Tracks method calls to verify how many times and with what parameters they were called.

- **Verifying Behavior** (interaction verification) involves checking that specific methods were called with expected arguments, and ensuring that side effects, like network requests or database operations, occurred correctly.

By using test doubles and verifying behavior, you can write more isolated, reliable, and focused unit tests for your Swift applications!
