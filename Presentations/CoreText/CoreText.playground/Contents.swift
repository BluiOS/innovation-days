import Foundation
import CoreText
import UIKit

let fontName: CFString = "Helvetica Bold" as CFString
let fontSize: CGFloat = 100
let fontSize20: CGFloat = 20.0

let ctFont = CTFontCreateWithName(fontName, fontSize, nil)

let uiFont = ctFont as UIFont
print(uiFont)

// Getting Information of Font
print("Font name:", CTFontCopyFullName(ctFont))
print("Point size:", CTFontGetSize(ctFont))
print("Ascent:", CTFontGetAscent(ctFont))
print("XHeight:", CTFontGetXHeight(ctFont))
print("CapHeight:", CTFontGetCapHeight(ctFont))
print("Font Family:", CTFontCopyFamilyName(ctFont))
print("Matrix:", CTFontGetMatrix(ctFont))
print("Supported Language:", CTFontCopySupportedLanguages(ctFont))


// indicate to getting index for character at Specefic font
// متنی که می‌خواهیم تبدیل کنیم
let text = "Hello KLAHaha!"
let characters = Array(text.utf16) // [UniChar]

import PlaygroundSupport

let label = UILabel()
label.font = uiFont
label.text = text
label.frame = .init(x: 0, y: 0, width: 700, height: 200)

PlaygroundPage.current.liveView = label
