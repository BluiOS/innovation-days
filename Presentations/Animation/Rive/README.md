# Rive - Interactive Animation Tool

## Overview
Rive is a real-time interactive animation tool used for creating animations that can respond to user interactions. It's especially popular in UI/UX design and app development for building rich, interactive experiences.

Rive combines:
- Interactive design tool
- Stateful graphics format
- Lightweight multi-platform runtime
- Fast vector renderer

This end-to-end pipeline ensures that what you build in the Rive Editor is exactly what ships in your apps, games, and websites.

[Official Website](https://rive.app)
[Learning Path](https://www.youtube.com/playlist?list=PLujDTZWVDSsFGonP9kzAnvryowW098-p3)

## Key Features
- **Real-Time Interactivity**: Animations respond to input (taps, swipes, hovers) in real time
- **State Machines**: Visual state machine to manage animation transitions
- **Cross-Platform Runtime**: Supports iOS, Android, Web, Flutter, React Native

## Common Use Cases
- Animated icons
- Loading spinners
- Interactive onboarding flows
- In-app mini-games
- Micro-interactions for buttons or toggles

## Runtime Types

### 1. App Runtime
Open-source libraries for loading and controlling animations in apps, games, and websites.

#### Runtime Size
| Target | Download Size | Installed Size |
|--------|--------------|----------------|
| Framework | - | 3.8MB |
| iOS App + RiveRuntime | 1.4MB | 3.9MB |
| App + RiveRuntime | 1.4MB | 4.0MB |

### 2. Game Runtime
Currently in Alpha for Mac and Windows versions of Unreal.

#### Supported Platforms
- Metal on Mac
- Metal on iOS
- Vulkan, D3D11, and D3D12 on Windows
- OpenGL on Android

[Getting Started with Game Runtime](https://rive.app/docs/game-runtimes/unreal/getting-started)

## Swift Implementation

### Basic Setup
```swift
@IBOutlet weak var riveView: RiveView!

var bananaVM = RiveViewModel(
    fileName: "dancing_banana",
    artboardName: "Banana",
)

bananaVM.setView(riveView)
```

### Animation Playback Control
```swift
// Play animation
play(animationName: String? = nil, loop: Loop = .autoLoop, direction: Direction = .autoDirection)

// Control methods
pause()
stop()
reset()
```

### Responsive Layout
```swift
let viewModel = RiveViewModel(fileName: "...")
viewModel.fit = .layout
viewModel.layoutScaleFactor = RiveViewModel.layoutScaleFactorAutomatic // Automatic scaling
viewModel.layoutScaleFactor = 2.0 // Manual scaling
```

## State Machines in Rive

State Machines are a visual way to connect animations and define logic-driven transitions. They enable interactive motion graphics for products, apps, games, or websites, fostering close collaboration between designers and developers throughout the development cycle.

### Anatomy of a State Machine
A basic state machine consists of:

1. **Graph**: Space to add states and connect transitions
2. **States**: Timeline animations used in the machine
3. **Transitions**: Logical connections between states
4. **Inputs**: Control mechanisms for transitions
5. **Layers**: Allow multiple animations to run independently

### Components Explained

#### Graph
The Graph is the visual workspace where you place states and connect them using transitions. It appears when a state machine is selected in the animations list.

#### States
States represent timeline animations. They can be simple (e.g., changing an object’s color) or complex (e.g., blending multiple timelines). For example, a button might include:
- **Idle** – default visual state
- **Hovered** – state when cursor is over it
- **Clicked** – state after a click

##### Default States
Default states are automatically included:
- Entry – Initial state of the machine
- Any State – Can transition to other states regardless of the current state
- Exit – Ends the state machine layer playback

##### Entry State
Starts the machine. Multiple animations can connect here (e.g., a toggle switch starting in "on" or "off").

##### Any State
Transitions from Any State can occur at any time, useful for universal changes (e.g., character skin switch).

##### Exit State
Used when multiple layers are involved to stop the playback.

#### Types of Animation States
- Single Animation State
    1. Based on individual timelines
    2. Can be one-shot, looping, or ping-pong

- Blend States
    Used to blend multiple animations. Two types:
    1. 1D Blend State: Uses a single number input to mix animations (e.g., health bar, loading). Animations ramp up/down based on the input value. Blending is additive, not linear.
    2. Additive Blend State: Uses multiple number inputs to blend animations. Ideal for facial expressions or dynamic poses.

#### Inputs
Inputs are how developers programmatically control the state machine. They define conditions for transitions:
- Boolean – true/false
- Trigger – Temporarily true
- Number – Integer or float values

#### Transitions
Transitions link states, forming the logic map of the state machine. You can have multiple transitions between states, each with different conditions (i.e., supporting “OR” logic).

##### Transition Properties
- Duration – Time to transition between states
- Exit Time – Defines how much of the current animation must complete before transitioning (in time or percentage)
- Pause When Exiting – Pauses the current animation during transition
- Conditions – Set via inputs (e.g., isClicked == true)

#### Layers
Each state machine has at least one layer. Since only one animation can play per layer, multiple layers let you mix animations or separate interactions.

## Events
Events are signals sent from Rive animations to your runtime code, allowing developers to execute specific actions at key moments. They enhance collaboration by enabling designers to pass useful data or intent directly through the animation.

### Why Use Events?
Events allow you to:

1. Open a URL
2. Play a sound
3. Show or hide HTML elements
4. Trigger any custom runtime logic

## Data Binding
- Create reactive connections between editor elements and code
- Bind colors, positions, and other properties
- Enable runtime adjustments
- Universal across runtimes

## Text
Rive allows reading and updating text dynamically at runtime through the ```RiveViewModel``` API.

### Reading Text Values

```
open func getTextRunValue(_ textRunName: String) -> String?
```

#### For a nested artboard, use:

```
open func getTextRunValue(_ textRunName: String, path: String) -> String?
```

### Setting Text Values

```
open func setTextRunValue(_ textRunName: String, textValue: String) throws
```

#### To set a text value in a nested artboard

```
open func setTextRunValue(_ textRunName: String, textValue: String, path: String) throws
```

## Event Handling

To handle Rive events at runtime, implement an event listener method that processes different types of events using the ```RiveEvent``` API:

```swift
@objc func onRiveEventReceived(onRiveEvent riveEvent: RiveEvent) {
    debugPrint("Event Name: \(riveEvent.name())")
    debugPrint("Event Type: \(riveEvent.type())")
    
    if let openUrlEvent = riveEvent as? RiveOpenUrlEvent {
        // Handle Open URL events
    } else if let generalEvent = riveEvent as? RiveGeneralEvent {
        // Handle general or custom events
    }
}
```

Notes:

- Use RiveOpenUrlEvent to capture and process open URL events.
- Use RiveGeneralEvent for custom or general-purpose Rive events.
- You can extract custom data from the event payload if applicable, enabling integration with your app logic.

This event handling system allows your code to respond in real time to interactions or transitions defined within your Rive file.

### Audio
- Embedded assets play automatically
- Platform-specific audio settings may require additional configuration

### Caching
- Load .riv files once for multiple uses
- Improve performance in applications with repeated animations

### Logging
Available log levels:
- Debug: For debugging purposes
- Info: Additional information
- Default: Standard logging
- Error: Error occurrences
- Fault: Critical errors