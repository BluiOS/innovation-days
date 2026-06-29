Matrix Transformations

# Table of Contents

1. Introduction
2. Point
3. Line
4. Vector
5. Why Do We Need Matrices?
6. What Is a Matrix?
7. Matrix × Vector
8. Scale Matrix
9. Rotation Matrix
10. The Translation Problem
11. Homogeneous Coordinates
12. Translation Matrix
13. Combining Transformations
14. Order Matters
15. Understanding CGAffineTransform
    * Identity Transform
    * Scale Transform
    * Translation Transform
    * Rotation Transform
    

### Introduction

When we create animations in iOS, we usually write code like this:

```swift
view.transform = CGAffineTransform(
    translationX: 100,
    y: 50
)
```

or

```swift
UIView.animate(withDuration: 1.0) {
    view.transform = CGAffineTransform(
        rotationAngle: .pi / 4
    )
}
```

But what actually happens behind the scenes?

To understand animations, we need to start from the basics and gradually move toward matrices, transformations.

<br/>

### Point

    A point is the smallest geometric element.

    A point in 2D space is represented by:

```swift
P = (x, y)
```

Example:

```swift
P = (3, 5)
```

This means:

```swift
X = 3
Y = 5
```

A point only represents a location.

In iOS:

```swift
let point = CGPoint(x: 100, y: 200)
```

<br/>


### Line

A line is created by connecting two points.

Example:

```swift
A = (1, 1)
B = (4, 5)
```

The segment between A and B forms a line.

Everything we draw on screen is ultimately built from points and lines.

Even complex shapes are made from multiple lines.

<br/>

### Vector

Many developers confuse points and vectors.

A point describes a position.

A vector describes:

* Direction
* Magnitude

Example:

```swift
A = (1, 1)
B = (4, 5)
```

The vector from A to B is:

```swift
AB = (3, 4)
```

This means:

* Move 3 units on X
* Move 4 units on Y

Vectors are heavily used in animation and graphics.

<br/>

### Why Do We Need Matrices?

Imagine a square with four corners.

If we want to:

* Scale it
* Rotate it
* Move it

We could calculate every point manually.

This works for four points.

But what about:

* 1,000 points?
* 100,000 points?
* Millions of vertices in a 3D model?

We need a more efficient solution.

That solution is the matrix.

<br/>

### What Is a Matrix?

A matrix is a collection of numbers that describes a transformation.

Example:

```swift
| 1  0 |
| 0  1 |
```

This matrix is called the Identity Matrix.

It means:

“Do not change anything.”

In iOS:

```swift
CGAffineTransform.identity
```

represents the same idea.

<br/>

### Matrix × Vector

The core idea of computer graphics is:

Matrix × Vector

Example:

```swift
M = | 2  0 |
    | 0  2 |

V = | 3 |
    | 4 |
```

Result:

```swift
R = | 6 |
    | 8 |
```

The vector has been transformed.

This operation happens millions of times per second inside the GPU.

<br/>

### Scale Matrix

Scaling changes size.

Scale matrix:

```swift
| Sx  0  |
| 0   Sy |
```

Example:

```swift
Sx = 2
Sy = 2
```

Everything becomes twice as large.

In iOS:

```swift
view.transform =
    CGAffineTransform(
        scaleX: 2,
        y: 2
    )
```

<br/>

Non-uniform Scale

Example:

```swift
Sx = 2
Sy = 1
```

The object becomes stretched horizontally.

<br/>

### Rotation Matrix

Rotation changes orientation.

Rotation matrix:

```swift
| cosθ  -sinθ |
| sinθ   cosθ |
```

Example:

```swift
θ = 45°
```

Values:

```swift
cos(45°) = 0.707
sin(45°) = 0.707
```

Matrix:

```swift
| 0.707  -0.707 |
| 0.707   0.707 |
```

In iOS:

```swift
view.transform =
    CGAffineTransform(
        rotationAngle: .pi / 4
    )
```

<br/>

### The Translation Problem

Scaling and rotation work well with a 2×2 matrix.

Translation is different.

Example:

Move right 100
Move down 50

A standard 2×2 matrix cannot represent translation.

We need a new approach.

<br/>

### Homogeneous Coordinates

To support translation, we add an extra coordinate.

Instead of:

```swift
(x, y)
```

We use:

```swift
(x, y, 1)
```

Example:

```swift
(3, 4)
```

becomes

```swift
(3, 4, 1)
```

The extra value allows translation to be represented using matrix multiplication.

This is one of the most important concepts in computer graphics.

<br/>

11. Translation Matrix

Translation matrix:

```swift
| 1  0  tx |
| 0  1  ty |
| 0  0   1 |
```

Example:

```swift
tx = 100
ty = 50
```

Matrix:

```swift
| 1  0  100 |
| 0  1   50 |
| 0  0    1 |
```

In iOS:

```swift
view.transform =
    CGAffineTransform(
        translationX: 100,
        y: 50
    )
```

<br/>

### Combining Transformations

Real-world animations rarely use only one transformation.

Usually we:

1. Scale
2. Rotate
3. Translate

The final matrix becomes:

```swift
M = T × R × S
```

This is called a Composite Transform.

<br/>

### Order Matters

Matrix multiplication is not commutative.

This means:

```swift
T × R
```

is not equal to

```swift
R × T
```

Example:

Case A

Rotate first, then translate.

Case B

Translate first, then rotate.

The final result is completely different.

This is a very important concept when debugging animations.

<br/>

### Understanding CGAffineTransform

Internally, CGAffineTransform stores only six numbers:

```swift
public struct CGAffineTransform {
    var a: CGFloat
    var b: CGFloat
    var c: CGFloat
    var d: CGFloat
    var tx: CGFloat
    var ty: CGFloat
}
```

These values represent:

```swift
| a   c   tx |
| b   d   ty |
| 0   0    1 |
```

<br/>

Identity Transform

```swift
a = 1
b = 0
c = 0
d = 1
tx = 0
ty = 0
```

No transformation occurs.

<br/>

Scale Transform

```swift
CGAffineTransform(
    scaleX: 2,
    y: 3
)
```

Produces:

```swift
a = 2
d = 3
```

<br/>

Translation Transform

```swift
CGAffineTransform(
    translationX: 100,
    y: 50
)
```

Produces:

```swift
tx = 100
ty = 50
```

<br/>

Rotation Transform

For a 45° rotation:

```swift
a = 0.707
b = 0.707
c = -0.707
d = 0.707
```

These values come directly from sine and cosine.

<br/>