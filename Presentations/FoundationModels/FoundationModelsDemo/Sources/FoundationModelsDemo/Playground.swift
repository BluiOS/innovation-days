import Foundation
import FoundationModels
import Playgrounds

// Foundation Models presentation demo
// Requirements: macOS 26+, Xcode 26+, and Apple Intelligence enabled.
// Open the Xcode canvas, choose one #Playground block, and run it.

// Example 1: Check whether the on-device model is ready
#Playground("Availability") {
    let model = SystemLanguageModel.default

    switch model.availability {
    case .available:
        print("The on-device model is available.")
        print("Context size: \(model.contextSize) tokens")
        print("English supported: \(model.supportsLocale(Locale(identifier: "en")))")

    case .unavailable(let reason):
        print("The model is unavailable: \(reason)")
        print("Check Apple Intelligence, language, region, and model download status.")
    }
}

// Example 2: Summarize a school announcement for a parent
#Playground("Plain Text") {
    let session = LanguageModelSession(instructions: """
        Summarize school announcements for busy parents.
        Use no more than 1 sentence.
        Keep only the most important actions, times, and cancellations.
        Do not repeat every detail from the announcement.
        """)

    let schoolAnnouncement = """
        Dear families, this Friday the school will close at 12:30 PM because
        teachers have an afternoon training session. Students will follow their
        normal morning timetable, and lunch will be served at 11:45 AM. School
        buses will leave at 12:45 PM. Parents who collect their children should
        arrive at the main entrance between 12:20 and 12:35 PM and bring their
        pickup card. All after-school clubs, sports practices, music lessons,
        and the homework center are cancelled. The library will remain open
        until 2:00 PM for students waiting for an approved adult, but families
        must reserve a place by Thursday morning. Science fair project forms
        are also due to classroom teachers by Thursday at 3:00 PM. The science
        fair itself will take place next Wednesday evening. Please update the
        school office before Friday if your child's usual travel arrangement
        will change.
        """

    let response = try await session.respond(to: schoolAnnouncement)
    print(response.content)
}

// Example 3: Convert a grocery receipt into typed Swift data
#Playground("Guided Generation") {
    let session = LanguageModelSession(instructions: """
        Read grocery receipts and extract only the printed information.
        """)

    let receiptText = """
        FRESH MART
        Milk      $2.80
        Bread     $1.90
        Apples    $4.30
        TOTAL     $9.00
        """

    let response = try await session.respond(
        to: receiptText,
        generating: GroceryReceipt.self
    )

    let receipt = response.content
    print("Store: \(receipt.store)")
    print("Category: \(receipt.category)")

    for item in receipt.items {
        print("- \(item.name): $\(item.price)")
    }

    print("Total: $\(receipt.total)")
}

@Generable
struct GroceryItem {
    @Guide(description: "The product name printed on the receipt")
    var name: String

    @Guide(description: "The product price")
    var price: Double
}

@Generable
struct GroceryReceipt {
    @Guide(description: "The store name printed at the top")
    var store: String

    @Guide(
        description: "The purchase category",
        .anyOf(["groceries", "restaurant", "transport", "other"])
    )
    var category: String

    @Guide(description: "Every purchased product", .minimumCount(1))
    var items: [GroceryItem]

    @Guide(description: "The printed receipt total")
    var total: Double
}

// Example 4: Create a dinner plan with visible constraints
#Playground("Guide Constraints") {
    let session = LanguageModelSession(instructions: """
        Create a practical dinner plan for two people.
        Use common ingredients. Do not suggest pasta.
        """)

    let response = try await session.respond(
        to: "Suggest a quick vegetarian dinner.",
        generating: DinnerPlan.self
    )

    let plan = response.content
    print("Difficulty: \(plan.difficulty)")
    print("Preparation time: \(plan.preparationTime) minutes")
    print("Ingredients: \(plan.ingredients)")
    print("Steps: \(plan.steps)")
    print("Optional sides: \(plan.optionalSides)")
}

@Generable
struct DinnerPlan {
    @Guide(
        description: "How difficult the dinner is to prepare",
        .anyOf(["medium", "challenging"])
    )
    var difficulty: String

    @Guide(description: "Exactly three preparation steps", .count(3))
    var steps: [String]

    @Guide(description: "At least four ingredients", .minimumCount(4))
    var ingredients: [String]

    @Guide(description: "No more than two optional side dishes", .maximumCount(2))
    var optionalSides: [String]

    @Guide(description: "Preparation time in minutes", .range(15...45))
    var preparationTime: Int
}

// Example 5: Stream a customer-support reply as it is created
#Playground("Streaming") {
    let session = LanguageModelSession(instructions: """
        Write polite customer-support replies.
        Acknowledge the problem and offer a clear next step.
        Keep the reply under 80 words.
        """)

    let complaint = """
        My headphones arrived three days late, and the left side does not work.
        I need them for a trip next week. What can you do?
        """

    let stream = session.streamResponse(to: complaint)

    for try await snapshot in stream {
        print(snapshot.content)
    }
}

// Example 6: Remember travel preferences during a conversation
#Playground("Multi-turn Session") {
    let session = LanguageModelSession(instructions: """
        Help plan a simple weekend trip.
        Remember preferences from earlier messages.
        """)

    _ = try await session.respond(to: """
        I am planning a weekend in Istanbul. My activity budget is $200,
        and I prefer vegetarian food and quiet places.
        """)

    let followUp = try await session.respond(
        to: "Suggest a Saturday morning activity and lunch that fit my preferences."
    )

    print(followUp.content)
}

// Example 7: Get package information from a trusted local data source
#Playground("Tool Calling") {
    let session = LanguageModelSession(
        tools: [DeliveryStatusTool()],
        instructions: """
            Answer questions about package deliveries.
            Use the delivery-status tool for trusted order information.
            Say clearly when the tracking number is unknown.
            """
    )

    let response = try await session.respond(
        to: "Where is package PKG-20882, and when should it arrive?"
    )

    print(response.content)
}

struct DeliveryStatusTool: Tool {
    let name = "lookupDeliveryStatus"
    let description = "Looks up trusted delivery information using a tracking number."

    @Generable
    struct Arguments {
        @Guide(description: "The package tracking number")
        var trackingNumber: String
    }

    func call(arguments: Arguments) async throws -> String {
        let deliveries = [
            "PKG-1042": "The package is out for delivery and should arrive today between 2 PM and 5 PM.",
            "PKG-2088": "The package is at the local sorting center and should arrive tomorrow.",
            "PKG-20882": "Gomsho"
        ]

        return deliveries[arguments.trackingNumber]
            ?? "No delivery was found for tracking number \(arguments.trackingNumber)."
    }
}
