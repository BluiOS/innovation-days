import Foundation

//// ASCII Example
//let asciiString = "Hello, ASCII!"
//let asciiData = asciiString.data(using: .ascii)!
//
//print("ASCII String: \(asciiString)")
//print("ASCII String Count: \(asciiString.count)")
//print("ASCII Data: \(asciiData as NSData)")
//print("ASCII Bytes: \(asciiData.map { $0 })")
//
//// ISO-8859-1 Example
//let isoString = "Café au lait"
//let isoData = isoString.data(using: .isoLatin1)!
//
//print("\nISO-8859-1 String: \(isoString)")
//print("ISO-8859-1 String Count: \(isoString.count)")
//print("ISO-8859-1 Data: \(isoData as NSData)")
//print("ISO-8859-1 Bytes: \(isoData.map { $0 })")
//
//// UTF-8 Example
//let unicodeString = "Hello, 🌍!"
//let utf8Data = unicodeString.data(using: .utf8)!
//
//print("\nUTF-8 String: \(unicodeString)")
//print("UTF-8 String Count: \(unicodeString.count)")
//print("UTF-8 String scalar: \(unicodeString.unicodeScalars.map({ $0 }))")
//print("UTF-8 String scalar: \(unicodeString.unicodeScalars.map({ $0.value }))")
//print("UTF-8 Data: \(utf8Data as NSData)")
//print("UTF-8 Bytes: \(utf8Data.map { $0 })")

// UTF-16 Example
//let utf16Data = unicodeString.data(using: .utf16BigEndian)!
//
//print("\nUTF-16 String: \(unicodeString)")
//print("UTF-16 String Count: \(unicodeString.count)")
//print("UTF-16 Data: \(utf16Data as NSData)")
//print("UTF-16 Bytes: \(utf16Data.map { $0 })")
//
//// UTF-32 Example
//let utf32Data = unicodeString.data(using: .utf32BigEndian)!
//
//print("\nUTF-32 String: \(unicodeString)")
//print("UTF-32 String Count: \(unicodeString.count)")
//print("UTF-32 Data: \(utf32Data as NSData)")
//print("UTF-32 Bytes: \(utf32Data.map { $0 })\n")
//
//
//let string = "Hello, 🌍!"
//
//// Access the unicodeScalars view
//for scalar in string.unicodeScalars {
//    print("Scalar: \(scalar), Value: \(scalar.value), Hex: 0x\(String(format: "%04X", scalar.value))")
//}


let string2 = "s"
print(string2.localizedCompare("س") == .orderedSame)
print(string2.unicodeScalars.map({ $0.value }))
print(string2.decomposedStringWithCanonicalMapping.unicodeScalars.map({ $0.value }))
print(string2.precomposedStringWithCanonicalMapping.unicodeScalars.map({ $0.value }))

//let string3 = "\u{200F}Cafe\u{301} 🍎"
//print(string3)
//print(string2 == string3)
//
//print("\nCharacter: \(string2.map({ $0 })) - Count is \(string2.count)") // 6
//print("Unicode scalar:  \(string2.unicodeScalars.map({ $0.value })) - Count is \(string2.unicodeScalars.count)") // 7
//
//// https://www.ssec.wisc.edu/~tomw/java/unicode.html
//
//let scalars: [Unicode.Scalar] = [
//    Unicode.Scalar(0x0048)!, // H
//    Unicode.Scalar(0x0069)!, // i
//    Unicode.Scalar(0x1F44B)!, // 👋
//]
//
//let newString = String(scalars.map { Character($0) })
//print("\n\(newString)") // "Hi👋"
//
//let airplane = Unicode.Scalar(9992)!
//print(airplane)
