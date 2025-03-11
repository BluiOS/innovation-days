### Difference Between **Mock** and **Stub**

**Mocks** and **Stubs** are both types of **test doubles** used in unit testing to replace real dependencies with controlled versions. They help isolate the unit under test, ensuring that your tests focus only on the behavior you intend to test, not on external systems or complex dependencies. While they are both used to **simulate dependencies**, their **purpose** and **usage** are quite different.

### Key Differences

1. **Purpose**:
   - **Stub**: A **stub** is primarily used to **return predefined responses** when certain methods are called. It doesn't care about **how** or **when** a method is called. Its main purpose is to simulate a controlled behavior for the dependencies so that the test can run.
   - **Mock**: A **mock** is not just used for **predefined responses**, but also for **verifying interactions**. You use mocks to verify **if certain methods were called** and with **what arguments**. Mocks are used for **interaction-based testing** where the focus is on ensuring that the unit under test interacts with its dependencies in the correct way.

2. **Behavior Verification**:
   - **Stub**: A stub is passive and doesn't care about the interactions. It's simply there to return a value or perform a simple action.
     - **Example**: You can use a stub to return a fixed value when a method is called (e.g., return `10` when a function `add(a, b)` is called).
   - **Mock**: A mock is active and **verifies interactions**. It tracks the **method calls**, their arguments, and can ensure that a certain method was called **exactly as expected**.
     - **Example**: You can use a mock to verify if the method `add(a, b)` was called with specific arguments, such as `(2, 3)`.

3. **Test Focus**:
   - **Stub**: The focus of a test that uses stubs is typically on the **state** or **output** of the system under test. The stub ensures the method behaves consistently and returns predictable data.
   - **Mock**: The focus of a test that uses mocks is on the **behavior** and **interactions** between components. Mocks ensure the system under test interacts with its dependencies as expected.

4. **State vs. Interaction Testing**:
   - **Stub**: Stubs are useful when you're interested in testing **how the system behaves in response to specific data or conditions** (i.e., **state-based testing**).
   - **Mock**: Mocks are useful when you're interested in **how the system interacts with its dependencies** (i.e., **interaction-based testing**).

5. **Example Scenarios**:
   - **Stub**: You are testing a method that depends on a database call. You stub the database method to always return a fixed result, so you can test the method without connecting to the database.
   - **Mock**: You are testing a service that calls an API to fetch data. You mock the API client to ensure it is called with the correct parameters, and you verify that the service behaves correctly when the mock API returns the expected data.

---

### Example: Stub vs Mock in Swift

#### 1. **Using a Stub**

Let's say you have a service that fetches data from a network. You might use a stub to simulate the network response.

```swift
protocol NetworkService {
    func fetchData(url: String) -> String
}

class NetworkServiceStub: NetworkService {
    func fetchData(url: String) -> String {
        return "Stubbed data"
    }
}

class DataManager {
    private let networkService: NetworkService
    
    init(networkService: NetworkService) {
        self.networkService = networkService
    }
    
    func getDataFromAPI() -> String {
        return networkService.fetchData(url: "https://example.com")
    }
}

// Test using NetworkServiceStub
let stubNetworkService = NetworkServiceStub()
let dataManager = DataManager(networkService: stubNetworkService)

let result = dataManager.getDataFromAPI()
print(result)  // Output: "Stubbed data"
```

**In this example**:
- The `NetworkServiceStub` provides a simple implementation of the `fetchData(url:)` method and always returns `"Stubbed data"`, regardless of the input.
- The test is **not concerned with** verifying whether `fetchData(url:)` was called or with the parameters. It just wants to ensure the system behaves correctly when the method returns a fixed value.

#### 2. **Using a Mock**

Now, let's use a **mock** to verify the interactions between the `DataManager` and the `NetworkService`. We want to verify that the `fetchData(url:)` method was called with the correct URL.

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
    
    func getDataFromAPI() -> String {
        return networkService.fetchData(url: "https://example.com")
    }
}

// Test using a mock with interaction verification
class DataManagerTests: XCTestCase {
    var mockNetworkService: MockNetworkService!
    var dataManager: DataManager!
    
    override func setUp() {
        super.setUp()
        mockNetworkService = MockNetworkService()
        dataManager = DataManager(networkService: mockNetworkService)
    }
    
    func testFetchDataFromAPI_CallsNetworkServiceWithCorrectURL() {
        // Stub the fetchData method to return a fake response
        stub(mockNetworkService) { mock in
            when(mock.fetchData(url: any())).thenReturn("Mocked data")
        }
        
        // Call the method under test
        let result = dataManager.getDataFromAPI()
        
        // Assert the result
        XCTAssertEqual(result, "Mocked data")
        
        // Verify the interaction: Check that fetchData was called with the correct URL
        verify(mockNetworkService).fetchData(url: "https://example.com")
    }
}
```

**In this example**:
- The `mockNetworkService` is a mock object that can track interactions, and we verify that the `fetchData(url:)` method is called with the URL `"https://example.com"`.
- **Behavior verification** is the primary goal. The test not only checks that the `getDataFromAPI` method produces the expected result but also ensures that the method interacts correctly with the `NetworkService` (i.e., calling `fetchData(url:)` with the right URL).

---

### Key Points:

- **Stub**:
  - Focuses on **providing predefined responses** to method calls.
  - Used for **state-based testing**: Testing how the system behaves when given specific data.
  - It does not verify whether a method was called, or how many times.
  
- **Mock**:
  - Focuses on **verifying interactions**: Ensuring that specific methods were called with the correct arguments, and checking the number of times they were called.
  - Used for **interaction-based testing**: Testing whether the system interacts with its dependencies correctly.
  - Can be used to **verify behavior**: Did the method `fetchData(url:)` get called with the correct parameters?

---

### Summary of Key Differences

| Feature                      | **Stub**                               | **Mock**                                 |
|------------------------------|----------------------------------------|------------------------------------------|
| **Purpose**                   | Provides predefined responses         | Verifies interactions (method calls)     |
| **Behavior**                  | Passive (returns fixed values)        | Active (tracks and verifies calls)       |
| **Verification**              | No verification of method calls       | Verifies method calls (e.g., parameters, call counts) |
| **Test Focus**                | Focuses on **state-based testing**    | Focuses on **interaction-based testing** |
| **Example Usage**             | Returning fixed data for a service call | Ensuring a method is called with the right parameters |
