# LLDB Practice Scenarios for Swift and iOS

This companion lab turns the commands from **How to Use LLDB Like a Pro** into repeatable experiments.

The scenarios are independent. Run one at a time, restart the app after any scenario that mutates state, and remove or disable breakpoints before moving to the next exercise.

---

## Setup: Create a Small Debugging Playground

1. Create a throwaway iOS app in Xcode using SwiftUI and Swift 6.
2. Add a new Swift file named `LLDBLab.swift`.
3. Paste the code below into that file.
4. Replace the root view in your app's `WindowGroup` with `LLDBLabView()`.
5. Run a Debug build in the iOS Simulator.

If your toolchain does not recognize `@DebugDescription`, remove only that annotation. The rest of the scenarios still work; the comparison between debugger summaries becomes a discussion point of its own.

```swift
import SwiftUI
import UIKit

@DebugDescription
struct DebugOrder: Identifiable, CustomDebugStringConvertible {
    enum State: String {
        case created
        case paid
        case failed
    }

    let id: String
    let total: Decimal
    let state: State

    var debugDescription: String {
        "Order(\(id), \(state.rawValue), total: \(total))"
    }
}

@MainActor
final class LLDBLab: ObservableObject {
    var mutationCounter = 0
    private var eventsProcessed = 0

    func inspectValues() {
        let order = DebugOrder(id: "A-1042", total: 79.90, state: .paid)
        let tax = Decimal(string: "7.99")!
        let grandTotal = order.total + tax
        let receipt = ["order": order.id, "total": "\(grandTotal)"]

        print("BREAKPOINT_A", order, grandTotal, receipt) // BREAKPOINT A
    }

    func findPoisonOrder() {
        let orders = [
            DebugOrder(id: "A-100", total: 20, state: .paid),
            DebugOrder(id: "A-101", total: 45, state: .paid),
            DebugOrder(id: "POISON", total: -1, state: .failed),
            DebugOrder(id: "A-103", total: 60, state: .created)
        ]

        for order in orders {
            let accepted = order.total > 0 // BREAKPOINT B
            print("processed", order.id, accepted)
        }
    }

    func testRuntimeMutation() {
        var useNewCheckout = false
        if ProcessInfo.processInfo.arguments.contains("-LLDBLabNewCheckout") {
            useNewCheckout = true
        }
        let order = DebugOrder(id: "A-200", total: 120, state: .created)

        print("BREAKPOINT_C", useNewCheckout, order.id) // BREAKPOINT C

        if useNewCheckout {
            print("new checkout selected")
        } else {
            print("legacy checkout selected")
        }
    }

    func generateEvents() {
        eventsProcessed = 0

        for eventID in 1...5 {
            eventsProcessed += 1
            print("BREAKPOINT_D", eventID, eventsProcessed) // BREAKPOINT D
        }
    }

    func corruptCounter() {
        mutationCounter = 0
        print("BREAKPOINT_E", mutationCounter) // BREAKPOINT E
        mutationCounter += 1
        applyUnexpectedMutation()
        mutationCounter += 1
        print("final counter", mutationCounter)
    }

    private func applyUnexpectedMutation() {
        mutationCounter = 99 // The write we want the watchpoint to find
    }

    func triggerCrash() {
        let values = [10, 20, 30]
        let impossibleIndex = 7
        print(values[impossibleIndex]) // INTENTIONAL CRASH
    }

    func startAsyncWork() {
        AsyncLab.start()
    }
}

enum AsyncLab {
    static func start() {
        Task {
            let result = await loadDashboard()
            print("dashboard result", result)
        }
    }

    static func loadDashboard() async -> String {
        async let profile = loadProfile()
        async let messages = loadMessages()
        return await "\(profile): \(messages.count) messages"
    }

    static func loadProfile() async -> String {
        try? await Task.sleep(for: .milliseconds(250))
        let profile = "Ada"
        print("BREAKPOINT_F", profile) // BREAKPOINT F
        return profile
    }

    static func loadMessages() async -> [String] {
        try? await Task.sleep(for: .milliseconds(400))
        return ["Welcome", "Payment received"]
    }
}

struct LLDBLabView: View {
    @StateObject private var lab = LLDBLab()

    var body: some View {
        NavigationStack {
            List {
                Section("Swift and LLDB") {
                    Button("A — Inspect values") { lab.inspectValues() }
                    Button("B — Find the poison order") { lab.findPoisonOrder() }
                    Button("C — Mutate runtime state") { lab.testRuntimeMutation() }
                    Button("D — Generate events") { lab.generateEvents() }
                    Button("E — Corrupt a counter") { lab.corruptCounter() }
                    Button("F — Start async work") { lab.startAsyncWork() }
                    Button("Crash — Out-of-bounds access", role: .destructive) {
                        lab.triggerCrash()
                    }
                }

                Section("UIKit and Chisel") {
                    ChiselLabContainer()
                        .frame(height: 220)
                }
            }
            .navigationTitle("LLDB Lab")
        }
    }
}

struct ChiselLabContainer: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> ChiselLabViewController {
        ChiselLabViewController()
    }

    func updateUIViewController(
        _ uiViewController: ChiselLabViewController,
        context: Context
    ) {}
}

final class ChiselLabViewController: UIViewController {
    let cardView = UIView()
    let titleLabel = UILabel()
    let updateButton = UIButton(type: .system)

    override func viewDidLoad() {
        super.viewDidLoad()

        cardView.backgroundColor = .secondarySystemBackground
        cardView.layer.cornerRadius = 16
        cardView.accessibilityIdentifier = "debug-card"

        titleLabel.text = "Original UIKit title"
        titleLabel.textAlignment = .center
        titleLabel.accessibilityIdentifier = "debug-title"

        updateButton.setTitle("Update UIKit label", for: .normal)
        updateButton.addTarget(self, action: #selector(updateTitle), for: .touchUpInside)

        [cardView, titleLabel, updateButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }

        view.addSubview(cardView)
        cardView.addSubview(titleLabel)
        cardView.addSubview(updateButton)

        NSLayoutConstraint.activate([
            cardView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            cardView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            cardView.topAnchor.constraint(equalTo: view.topAnchor, constant: 8),
            cardView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -8),

            titleLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 12),
            titleLabel.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -12),
            titleLabel.centerYAnchor.constraint(equalTo: cardView.centerYAnchor, constant: -28),

            updateButton.centerXAnchor.constraint(equalTo: cardView.centerXAnchor),
            updateButton.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20)
        ])
    }

    @objc private func updateTitle() {
        let nextTitle = "Updated at \(Date().formatted(date: .omitted, time: .standard))"
        print("BREAKPOINT_G", nextTitle) // BREAKPOINT G
        titleLabel.text = nextTitle
    }
}
```

App entry point:

```swift
@main
struct LLDBPracticeApp: App {
    var body: some Scene {
        WindowGroup {
            LLDBLabView()
        }
    }
}
```

---

## Scenario 1: Inspect the Same Value Four Ways

### Goal

Learn when `v`, `p`, and `po` produce different work and different output.

### Steps

1. Set a breakpoint on `BREAKPOINT A`.
2. Tap **A — Inspect values**.
3. Run:

```lldb
v
v order
v order.state
p grandTotal
p receipt["order"]
po order
help frame variable
help dwim-print
```

### Questions

- Which commands use the `@DebugDescription` or `CustomDebugStringConvertible` representation?
- Which command still works if a more complex expression fails?
- Does the variables view show the same summary as `p order`?

### Success condition

You can explain why `v order`, `p order`, and `po order` are not interchangeable—even if their output looks similar in this example.

---

## Scenario 2: Find One Bad Item with a Conditional Breakpoint

### Goal

Stop only when the loop reaches the corrupt order.

### Steps

1. Set a breakpoint on `BREAKPOINT B`.
2. Edit the breakpoint and add this condition:

```swift
order.id == "POISON"
```

3. Tap **B — Find the poison order**.
4. At the stop, run:

```lldb
p order
p order.total
bt
breakpoint list
```

5. Repeat with the behavior-based condition:

```swift
order.total < 0
```

### Experiment

Remove the condition and use an ignore count of `2`. Compare “the third hit” with “the invalid order.”

### Success condition

You can choose between a semantic condition and a hit count based on what is stable in the bug report.

---

## Scenario 3: Replace Temporary Prints with a Logpoint

### Goal

Collect loop evidence without stopping on every event or editing source.

### Steps in Xcode

1. Set a breakpoint on `BREAKPOINT D`.
2. Edit the breakpoint.
3. Add a **Debugger Command** action:

```lldb
p "event=\(eventID), processed=\(eventsProcessed)"
```

4. Enable **Automatically continue after evaluating actions**.
5. Tap **D — Generate events**.

### Equivalent console setup

After creating the breakpoint, find its ID with `breakpoint list`, then:

```lldb
breakpoint command add <breakpoint-id>
> p "event=\(eventID), processed=\(eventsProcessed)"
> continue
> DONE
```

### Questions

- Does the app visibly pause?
- Is the log produced before or after `eventsProcessed` is incremented?
- What changes if the breakpoint moves one line earlier?

### Success condition

You can gather targeted runtime evidence without leaving debug-only logging in source control.

---

## Scenario 4: Test a Branch Without Rebuilding

### Goal

Use an expression to validate a feature-path hypothesis in the current process.

### Steps

1. Set a breakpoint on `BREAKPOINT C`.
2. Tap **C — Mutate runtime state**.
3. Confirm the original value:

```lldb
v useNewCheckout
```

4. Change it:

```lldb
expr -- useNewCheckout = true
v useNewCheckout
continue
```

5. Observe which branch prints to the console.

### Extend it

Configure the breakpoint with this debugger-command action and automatic continuation:

```lldb
expr -- useNewCheckout = true
```

Now every tap takes the new path without source changes.

### Success condition

You can demonstrate the suspected behavior change, then restart the app and reproduce again without mutation before treating the result as final evidence.

---

## Scenario 5: Catch the Exact Write with a Watchpoint

### Goal

Find the method that unexpectedly changes `mutationCounter` to `99`.

### Steps

1. Set a breakpoint on `BREAKPOINT E`.
2. Tap **E — Corrupt a counter**.
3. In Xcode's variables view, expand `self`, right-click `mutationCounter`, and choose **Watch “mutationCounter”**.
4. Or try the console form:

```lldb
watchpoint set variable mutationCounter
watchpoint list
continue
```

5. Each time the watchpoint stops, inspect:

```lldb
v mutationCounter
bt
continue
```

### Questions

- Does the stop occur before or after the write?
- Which stack first shows `applyUnexpectedMutation()`?
- Why would a computed property be a poor watchpoint target?

### Success condition

You identify `applyUnexpectedMutation()` from runtime evidence rather than a text search for every assignment.

---

## Scenario 6: Catch a UIKit API Call at the Framework Boundary

### Goal

Find who changes a label even when the stop lands inside UIKit assembly.

### Steps

1. Set a regular breakpoint on `BREAKPOINT G`.
2. Tap **Update UIKit label**.
3. At the stop, create a one-shot symbolic breakpoint:

```lldb
breakpoint set --one-shot true -n "-[UILabel setText:]"
continue
```

4. LLDB should stop inside `-[UILabel setText:]` for the next assignment.
5. Inspect the Objective-C call:

```lldb
po $arg1
p (SEL)$arg2
po $arg3
bt
```

6. Select the first app-owned frame above UIKit.

### Why one-shot?

`UILabel` instances update frequently during launch and layout. Creating the symbolic breakpoint immediately before the suspicious assignment narrows the search and avoids unrelated hits.

### Success condition

You can identify both the target label and the new string, then navigate from UIKit back to `updateTitle()`.

---

## Scenario 7: Triage an Intentional Swift Crash

### Goal

Build a consistent first-minute crash routine.

### Steps

1. Disable unrelated breakpoints.
2. Tap **Crash — Out-of-bounds access**.
3. When the process stops, do not immediately continue.
4. Run:

```lldb
thread list
bt
thread backtrace all
frame info
up
down
source list
```

5. Select the first frame in your app, then inspect:

```lldb
v values
v impossibleIndex
p values.count
```

### Questions

- What does LLDB report as the stop reason?
- Which frame is the failure mechanism inside the Swift runtime?
- Which frame contains the invalid business input?

### Success condition

You can distinguish the runtime trap from the app-owned line that supplied the invalid index.

---

## Scenario 8: Inspect an Async Call Chain

### Goal

See how a Swift task's logical call path differs from a physical thread.

### Steps

1. Set a breakpoint on `BREAKPOINT F`.
2. Tap **F — Start async work**.
3. At the stop, run:

```lldb
bt
thread info
thread list
thread backtrace all
p Task<Never, Never>.isCancelled
```

4. Find frames related to `loadProfile()`, `loadDashboard()`, and the task closure.
5. Continue and repeat with a breakpoint inside `loadMessages()`.

### Questions

- Did both async functions execute on the same physical thread?
- Which parts of the logical async path does LLDB reconstruct?
- Where would you place breakpoints to investigate a cancellation bug?

### Success condition

You stop treating “thread” and “task” as synonyms and can inspect both views of concurrent execution.

---

## Scenario 9: Connect Source, Symbols, and Machine Code

### Goal

See the LLVM side of the debugging toolchain.

### Steps

1. Stop on any app-owned breakpoint.
2. Run:

```lldb
frame info
image list -o -f
image lookup -a `$pc`
register read pc sp fp
disassemble --frame --mixed
```

3. Step one machine instruction:

```lldb
thread step-inst
```

4. Return to source-level stepping:

```lldb
next
```

### Questions

- Which source line maps to the program counter?
- Can one source line produce multiple instructions?
- Does optimized code preserve the same simple mapping?

### Success condition

You can explain why LLDB needs compiler debug information, an ABI model, a disassembler, and symbols to present one highlighted Swift line.

---

## Scenario 10: Explore the UIKit Hierarchy with Chisel

### Goal

Use packaged LLDB commands to inspect and modify visible UI.

### Prerequisite

Install and import Chisel as described in the presentation. Restart Xcode and verify `help pviews` works.

### Steps

1. Pause on `BREAKPOINT G`.
2. Run:

```lldb
pviews
pvc
fv UILabel
fvc ChiselLabViewController
border self.titleLabel
presponder self.titleLabel
visualize self.cardView
```

3. Test temporary UI changes:

```lldb
hide self.titleLabel
show self.titleLabel
border --color magenta --width 3 self.cardView
caflush
```

4. Use `help border`, `help fv`, and `help visualize` to discover available options in your installed version.

### Questions

- Which Chisel commands work cleanly with this UIKit subtree?
- What does the surrounding SwiftUI hosting hierarchy look like in `pviews` and `pvc`?
- When is Xcode's View Debugger clearer than text output?

### Success condition

You can locate a UIKit object, prove which pixels it owns, and experiment with it without rebuilding.

---

## Scenario 11: Build a Small Personal LLDB Toolkit

### Goal

Turn a repeated manual workflow into a safe, discoverable command.

### Steps

1. During a paused session, create an alias:

```lldb
command alias bfl breakpoint set -f %1 -l %2
help bfl
```

2. Try it with a real file and line:

```lldb
bfl LLDBLab.swift 42
breakpoint list
```

3. Add a harmless UI refresh alias:

```lldb
command alias flush expression -- CATransaction.flush()
```

4. If the aliases are genuinely useful, place them in `~/.lldbinit-Xcode`.

### Guardrail

Do not copy unknown LLDB initialization scripts blindly. These files can import Python and execute commands with your user permissions.

### Success condition

You save only commands you understand, can explain, and expect to reuse.

---

## Suggested Live-Demo Sequence

For a compact demonstration during the presentation:

1. **Scenario 1** — establish `v`, `p`, and `po`
2. **Scenario 2** — narrow a noisy loop with a condition
3. **Scenario 4** — mutate a branch without rebuilding
4. **Scenario 5** — let a watchpoint find the writer
5. **Scenario 6** — cross from UIKit assembly back to Swift
6. **Scenario 10** — finish with visible Chisel UI changes

Keep the crash and async scenarios as deeper follow-up exercises.

---

## Reset Checklist Between Scenarios

```lldb
breakpoint list
watchpoint list
breakpoint disable <id>
watchpoint delete <id>
```

Then:

- Stop and relaunch after state mutation
- Re-enable only the breakpoint needed for the next scenario
- Confirm the selected scheme uses a Debug configuration
- Keep the debug console visible
- Record the hypothesis before running the command

Clean experiments produce trustworthy conclusions.
