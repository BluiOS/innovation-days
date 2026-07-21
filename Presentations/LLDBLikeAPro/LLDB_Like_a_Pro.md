# How to Use LLDB Like a Pro

### Practical debugging for Swift and iOS developers

> Stop guessing. Ask the running program better questions.

---

## The Goal Is Not to Memorize Commands

By the end of this session, you should be able to:

- Turn a vague symptom into a focused search
- Inspect Swift state with the right level of power and risk
- Make breakpoints collect evidence for you
- Trace crashes, state changes, UIKit calls, and async work
- Extend LLDB with aliases, Python, and Chisel

---

## Debugging Is a Search Problem

You know two points in time:

1. The app starts in a valid state
2. Later, something is wrong

Your job is to find the earliest point where reality diverges from expectation.

**A breakpoint is a question:**

> “At this exact point, does the program still satisfy my assumptions?”

---

## Use a Repeatable Debugging Loop

### Run → Break → Inspect → Narrow → Verify

1. Reproduce the smallest reliable symptom
2. Stop near a meaningful state transition
3. Inspect data, control flow, threads, and the stack
4. Remove half the remaining search space
5. Test the final hypothesis before editing code

LLDB becomes powerful when every stop reduces uncertainty.

---

## LLDB Is Already Inside Xcode

When Xcode pauses your iOS app, LLDB is controlling the process.

You can interact with it through:

- Source, symbolic, exception, and test breakpoints
- The variables view and debug navigator
- The LLDB prompt in Xcode's debug console
- Breakpoint conditions and actions
- The command-line `lldb` client for lower-level workflows

The Xcode UI and the LLDB console operate on the same debug session.

---

## LLDB and LLVM Are Parts of the Same Toolchain

```text
Swift / Objective-C source
          │
          ▼
 Swift compiler / Clang
          │
          ├── Machine code
          └── Debug information
                  │
                  ▼
        LLDB + language plugins
          │
          ├── Understand types and symbols
          ├── Map source lines to addresses
          ├── Disassemble through LLVM
          └── Compile debugger expressions
```

LLDB reuses LLVM project components instead of reimplementing a compiler, disassembler, and ABI model.

---

## `expr` Is a Tiny Compile-and-Run Cycle

When you evaluate a non-trivial Swift expression, LLDB can:

1. Reconstruct the current Swift context
2. Parse and type-check the expression
3. Compile it with an embedded Swift compiler
4. Inject and execute it in the paused process
5. Return the result to the debugger

This is why expressions can call methods and mutate state—and why they can fail, block, crash, or cause side effects.

The Swift compiler and debugger must be compatible parts of the same toolchain.

---

## Debug Information Is the Contract

LLDB relies on compiler-produced debug information to connect:

- Source lines ↔ machine addresses
- Variable names ↔ registers or memory
- Swift types ↔ runtime values
- Stack frames ↔ function names

Optimized builds may inline functions, reorder instructions, or remove variables.

For the clearest source-level debugging, reproduce in a Debug configuration with Swift optimization set to `-Onone`.

---

## LLDB Commands Have a Grammar

```text
<noun> <verb> [options] [arguments]
```

```lldb
breakpoint set --file CheckoutViewModel.swift --line 42
thread backtrace
frame variable order
watchpoint set variable retryCount
```

Unique abbreviations work:

```lldb
br s -f CheckoutViewModel.swift -l 42
bt
fr v order
```

Prefer full commands while learning; use short forms when they remain obvious.

---

## Let LLDB Teach You LLDB

```lldb
help
help breakpoint set
help expression
apropos watchpoint
apropos disassemble
```

- `help <command>` explains syntax and options
- `apropos <word>` searches all command help
- Press Tab to complete commands, files, symbols, and options
- Use `--` to end debugger options and begin the raw expression

```lldb
expression -- value - 1
```

---

## The Daily Control Loop

| Intent | Command | Common alias |
|---|---|---|
| Continue | `process continue` | `c` |
| Pause | `process interrupt` | — |
| Step over | `thread step-over` | `n` / `next` |
| Step in | `thread step-in` | `s` / `step` |
| Step out | `thread step-out` | `finish` |
| Backtrace | `thread backtrace` | `bt` |
| Current variables | `frame variable` | `v` |

Start here. Most sessions need only a few more commands.

---

## Inspect Without Running App Code

Use `frame variable`—or `v`—for the safest first look:

```lldb
v
v order
v order.customer.name
v self.viewModel.state
```

It reads values using debug information and LLDB's formatters. It does not compile a Swift expression or call your methods.

**Best for:** locals, stored properties, arguments, and reliable inspection when expression evaluation is slow or broken.

---

## Choose `v`, `p`, `po`, or `expr` Intentionally

| Command | Use it for | May execute code? |
|---|---|---|
| `v value` | Read a variable or stored-property path | No expression evaluation |
| `p value` | “Do what I mean” printing; simple values or expressions | Yes, when an expression is needed |
| `po object` | Print an object's debug description | Yes |
| `expr -- code` | Evaluate Swift and deliberately change state | Yes |

Modern Swift LLDB uses `dwim-print` behind `p` and `po`, avoiding the compiler for simple cases when possible.

**Rule:** begin with the least powerful command that can answer the question.

---

## Expressions Let You Test a Hypothesis Live

```lldb
expr -- featureFlags.newCheckout = true
expr -- retryCount = 0
expr -- viewModel.state = .loaded(mockOrders)
expr -- UIView.setAnimationsEnabled(false)
```

You can also keep a debugger-only value:

```lldb
expr -- let $targetID = order.id
p $targetID
```

This can validate a fix or force a rare branch without rebuilding.

**Warning:** method calls and property accessors can have side effects. You are modifying the current run, not changing the built app.

---

## The Stack Explains How You Got Here

```lldb
bt
thread backtrace all
frame info
frame select 3
up
down
source list
```

Use the stack to answer:

- Which user action or callback started this path?
- Did we cross a framework, actor, or queue boundary?
- Is this the first bad frame—or only where the damage became visible?

Inspect callers, not only the highlighted line.

---

## Threads Explain What Else Is Happening

```lldb
thread list
thread info
thread select 4
thread backtrace
thread backtrace all
```

Useful for:

- Main-thread hangs
- Deadlocks and lock contention
- Callbacks arriving on the wrong queue
- A crash whose interesting work began on another thread

For a hang, pause the app and inspect every thread before continuing.

---

## Breakpoints Are Search Predicates

```lldb
# File and line
breakpoint set -f CheckoutViewModel.swift -l 42

# Exact symbol
breakpoint set -n "-[UILabel setText:]"

# Every matching symbol
breakpoint set -r 'checkout|purchase|payment'

# Inspect what resolved
breakpoint list
breakpoint list --verbose
```

A logical breakpoint can resolve to multiple code locations—and can resolve later when a framework or dynamic library loads.

---

## Stop Only on the Interesting Hit

```lldb
# Add a Swift condition to breakpoint 1
breakpoint modify -c 'order.id == "POISON"' 1

# Ignore the first 99 hits
breakpoint modify -i 99 1

# Delete itself after the first hit
breakpoint modify --one-shot true 1

# Temporarily turn it off
breakpoint disable 1
```

In Xcode, the breakpoint editor exposes the same ideas: condition, ignore count, actions, and automatic continuation.

---

## Breakpoint Actions Turn Stops into Instruments

```lldb
breakpoint command add 1
> p "order=\(order.id), state=\(state)"
> bt
> continue
> DONE
```

This breakpoint now records evidence and continues automatically.

Use actions to:

- Replace temporary `print` statements
- Capture a backtrace only when an event occurs
- Mutate a feature flag every time a path runs
- Create a later one-shot breakpoint at the right moment

---

## High-Firing Breakpoints Need a Cheaper Strategy

A condition that evaluates Swift code may run thousands of times.

Before adding a complex condition:

1. Move the breakpoint closer to the suspicious state change
2. Use an ignore count when the hit number is predictable
3. Filter with a simple scalar comparison
4. Use a breakpoint action that logs and auto-continues
5. Create a one-shot breakpoint from an earlier, lower-frequency event

The best breakpoint is not merely correct; it is cheap enough to use.

---

## Watchpoints Answer “Who Changed This?”

```lldb
watchpoint set variable retryCount
watchpoint list
watchpoint modify -c 'retryCount > 3' 1
watchpoint disable 1
watchpoint delete 1
```

A watchpoint pauses when a memory location is read or written, depending on its configuration.

Use it when a value is correct now but corrupted later.

**Limits:** hardware watchpoints are scarce, the value needs stable storage, and computed properties do not have a directly watchable address.

---

## Symbolic Breakpoints Cross Framework Boundaries

When you know what happened but not who requested it, stop in the API:

```lldb
breakpoint set -n "-[UILabel setText:]"
breakpoint set -n "-[UIViewController presentViewController:animated:completion:]"
breakpoint set -n objc_exception_throw
```

Then move up the stack until you reach your code.

In Xcode, also use dedicated breakpoints for:

- Swift errors
- Objective-C exceptions
- Runtime issues
- Constraint errors

---

## Inspect Objective-C Calls with Portable Pseudo-Registers

Stopped inside an Objective-C method:

```lldb
po $arg1          # receiver: self
p  (SEL)$arg2     # selector: _cmd
po $arg3          # first explicit method argument
bt
```

`$arg1`, `$arg2`, and `$arg3` save you from memorizing the ARM64 calling convention.

This is particularly useful when a UIKit symbolic breakpoint lands in assembly and source is unavailable.

---

## Crash Triage Starts with Context, Not the Top Line

At a crash or exception stop:

```lldb
thread list
bt
thread backtrace all
frame info
v
source list
```

Ask:

- What is the stop reason?
- Which thread crashed?
- What is the first frame owned by the app?
- What inputs reached that frame?
- Is the top frame the cause, or only the failure mechanism?

Exception and Swift-error breakpoints often stop closer to the original failure than the final crash.

---

## Symbols Connect an Address Back to Code

```lldb
image list -o -f
image lookup -n checkout
image lookup -r -n 'payment.*failed'
image lookup -a `$pc`
disassemble --frame --mixed
register read pc sp fp
```

Use these when:

- A backtrace contains raw addresses
- A breakpoint is unresolved
- You are inside optimized or framework code
- Source-level stepping no longer matches execution

The dSYM UUID must match the binary UUID for reliable symbolication.

---

## Swift Concurrency Changes the Shape, Not the Method

Async work can resume on another thread, so a thread is not the same thing as a task.

At an async breakpoint:

```lldb
bt
thread list
thread backtrace all
p Task<Never, Never>.isCancelled
```

Look for:

- The reconstructed async call chain
- Actor or executor hops
- A task waiting on work that can never resume
- Cancellation that was ignored

Treat async debugging as state-transition debugging: stop before and after each suspension point.

---

## Make Your Swift Types Debugger-Friendly

For `po`, provide a useful programmatic description:

```swift
struct Order: CustomDebugStringConvertible {
    let id: String
    let total: Decimal

    var debugDescription: String {
        "Order(id: \(id), total: \(total))"
    }
}
```

Swift 6 also provides `@DebugDescription` so LLDB and Xcode's variables view can show a concise summary without calling arbitrary code.

Good descriptions expose identity and state—not every stored property.

---

## LLDB Can Debug UIKit Without Rebuilding

```lldb
po self.view.recursiveDescription()
expr -- self.titleLabel.text = "Injected by LLDB"
expr -- self.problemView.isHidden = true
expr -- self.problemView.layer.borderWidth = 3
expr -- self.problemView.layer.borderColor = UIColor.systemPink.cgColor
expr -- CATransaction.flush()
```

Use live mutation to test layout and state hypotheses.

Prefer Xcode's View Debugger when you need a complete spatial hierarchy; prefer LLDB when you need fast, scriptable experiments.

---

## Chisel Packages iOS Debugging Shortcuts

[Facebook Chisel](https://github.com/facebook/chisel) is a collection of Python-powered LLDB commands for iOS debugging.

It builds on LLDB rather than replacing it:

```text
Chisel command
      ▼
Python + LLDB API
      ▼
Objective-C / UIKit / Core Animation expressions
      ▼
Your paused app
```

Chisel is strongest in UIKit and mixed UIKit/SwiftUI apps because many commands inspect Objective-C runtime objects.

---

## High-Value Chisel Commands

| Command | What it answers |
|---|---|
| `pviews` | What is the recursive view hierarchy? |
| `pvc` | What is the view-controller hierarchy? |
| `fv <regex>` | Where is a view whose class matches this pattern? |
| `fvc <regex>` | Where is a matching view controller? |
| `border <view>` | Which on-screen region belongs to this view? |
| `show` / `hide` | What changes if this view is visible or hidden? |
| `visualize <object>` | What does this image, view, layer, or color look like? |
| `presponder <object>` | What is this object's responder chain? |
| `bmessage` | Who sends a method to this object? |
| `wivar` | Who mutates this Objective-C instance variable? |

Use `help <command>` because exact options differ by command.

---

## Install Chisel Deliberately

```bash
brew install chisel
brew --prefix chisel
```

Then import `fbchisellldb.py` from that prefix in `~/.lldbinit` or the Xcode-specific `~/.lldbinit-Xcode`:

```lldb
# Apple Silicon Homebrew default
command script import /opt/homebrew/opt/chisel/libexec/fbchisellldb.py
```

Restart Xcode, pause an app, then verify:

```lldb
help pviews
```

Chisel is third-party tooling. Test it with your current Xcode/Python environment, and expect some runtime-dependent commands to need maintenance.

---

## Turn Repetition into Your Own Command Set

LLDB reads startup commands from files such as `~/.lldbinit-Xcode` and `~/.lldbinit`.

```lldb
command alias bfl breakpoint set -f %1 -l %2
command alias flush expression -- CATransaction.flush()
settings set target.load-cwd-lldbinit false
command script import ~/Developer/lldb/commands.py
```

Use:

- Aliases for one-line command composition
- Command files for reusable sessions
- Python and the LLDB API for real logic
- Breakpoint names for reusable breakpoint behavior

Automation is the final step: first understand the manual workflow.

---

## When an Expression Fails, Fall Back Methodically

1. Confirm you selected the correct thread and frame
2. Try `v value` before compiling an expression
3. Use a fully qualified type or module name
4. Check whether the value was optimized out
5. Inspect `image list` and `breakpoint list --verbose`
6. Verify the loaded binary and dSYM belong together
7. Reproduce with `-Onone` and current build products

An expression error is often a missing context problem—not proof that the app value is invalid.

---

## Powerful Debugging Requires Guardrails

- `expr` and `po` can run arbitrary app code
- Calling UI code from the wrong thread is still unsafe
- A paused process can deadlock when an expression waits on another thread
- Runtime mutations can invalidate later observations
- Never use real customer secrets in debugger commands or logs
- Treat project-local `.lldbinit` files as executable code

When evidence matters, restart and reproduce without mutations before declaring the root cause.

---

## A Practical Path to “Pro”

### Level 1 — Control

`c`, `n`, `s`, `finish`, `bt`, `v`

### Level 2 — Search

Conditions, ignore counts, symbolic breakpoints, watchpoints

### Level 3 — Experiment

`p`, `po`, `expr`, runtime mutation, one-shot breakpoints

### Level 4 — Automate

Breakpoint actions, `.lldbinit-Xcode`, Python commands, Chisel

Master each level by using it on a real bug.

---

## The Professional Debugging Habit

Before typing a command, finish this sentence:

> “If my hypothesis is correct, this command should show ______.”

Then:

- Prefer evidence over intuition
- Inspect callers and competing threads
- Use the least invasive command first
- Automate only repeated questions
- Restart after experiments that changed state
- Add a regression test when the root cause is known

The “pro” skill is not command recall. It is disciplined control of the search space.

---

## Practice Next

Use the companion document:

### `LLDB_Practice_Scenarios.md`

It contains runnable Swift/iOS exercises for:

- Value inspection and debugger descriptions
- Conditional breakpoints and logpoints
- Runtime mutation and watchpoints
- Symbolic UIKit breakpoints
- Crash and async-stack investigation
- Chisel view-hierarchy commands
- Symbol, register, and disassembly inspection

---

## References

- [LLDB Tutorial](https://lldb.llvm.org/use/tutorial.html)
- [LLDB Architecture Overview](https://lldb.llvm.org/resources/overview.html)
- [LLDB Command Map](https://lldb.llvm.org/use/map.html)
- [Swift.org: REPL and Debugger](https://www.swift.org/documentation/lldb/)
- [Swift.org: Debugging Improvements in Swift 5.9](https://www.swift.org/blog/whats-new-swift-debugging-5.9/)
- [WWDC24: Run, Break, Inspect](https://developer.apple.com/videos/play/wwdc2024/10198/)
- [WWDC22: Debug Swift Debugging with LLDB](https://developer.apple.com/videos/play/wwdc2022/110370/)
- [WWDC18: Advanced Debugging with Xcode and LLDB](https://developer.apple.com/videos/play/wwdc2018/412/)
- [Facebook Chisel](https://github.com/facebook/chisel)
