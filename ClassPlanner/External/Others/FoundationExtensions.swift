//
//  FoundationExtensions.swift
//  ClassPlanner
//
//  Created by Edvin Berhan on 2021-03-21.
//

import Foundation
import SwiftUI
import CoreData
import CoreImage.CIFilterBuiltins

extension Date {
    static var oneDayRange: ClosedRange<Date> = {
        Date.init(timeIntervalSinceReferenceDate: 0)
            ...
        Date.init(timeIntervalSinceReferenceDate: 24 * 3600)
    }()
    
    var minute: Int {
        var calendar = Calendar.current
        if let newTimeZone = TimeZone(secondsFromGMT: 0) {
            calendar.timeZone = newTimeZone
        }
        return calendar.component(.minute, from: self)
    }
}

extension DateFormatter {
    
    static var courseTime: DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = .short
        dateFormatter.dateStyle = .none
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        return dateFormatter
    }
}

extension NumberFormatter {
    
    static var courseFormat: NumberFormatter {
        let numberFormatter = NumberFormatter()
        numberFormatter.maximumIntegerDigits = maxIntegers
        numberFormatter.maximumFractionDigits = maxDecimals
        numberFormatter.maximumSignificantDigits = maxSignificant
        numberFormatter.roundingMode = .down
        numberFormatter.zeroSymbol = " - "
        numberFormatter.localizesFormat = true
        return numberFormatter
    }
}

enum ColorOption: Int, Identifiable, Equatable {
    
    case primary
    case white
    case lightBlue
    case darkBlue
    case oliveGreen
    case jungleGreen
    case brown
    case yellow
    case orange
    case red
    case lightPink
    case purple
    case darkPink
    
    var id: Int { self.rawValue }
    
    var color: Color {
        switch self {
            case .primary: return .primary
            case .white: return .white
            case .lightBlue: return .brighterBlue
            case .darkBlue: return .darkerBlue
            case .oliveGreen: return .oliveGreen
            case .jungleGreen: return .jungleGreen
            case .brown: return .brown
            case .yellow: return .yellow
            case .orange: return .newOrange
            case .red: return .red
            case .lightPink: return .pink
            case .purple: return .newPurple
            case .darkPink: return .wildStrawberry
        }
    }
}

extension StringProtocol {
    subscript(offset: Int) -> Character {
        self[index(startIndex, offsetBy: offset)]
    }
}

extension Color {
    
    init(r: Int, g: Int, b: Int) {
        let doubleDivider: Double = 255.0
        let redDouble = Double(r) / doubleDivider
        let greenDouble = Double(g) / doubleDivider
        let blueDouble = Double(b) / doubleDivider
        self.init(red: redDouble, green: greenDouble, blue: blueDouble)
    }
    
    static var darkerBlue = Color.init(r: 29, g: 172, b: 241)
    static var brighterBlue = Color.init(r: 128, g: 218, b: 235)
    
    static var jungleGreen = Color.init(r: 59, g: 176, b: 143)
    static var oliveGreen = Color.init(r: 186, g: 184, b: 108)
    
    static var newRed = Color.init(r: 255, g: 73, b: 52)
    static var newOrange = Color.init(r: 255, g: 163, b: 67)
    
    static var brown = Color.init(r: 180, g: 103, b: 77)
    static var pink = Color.init(r: 252, g: 180, b: 213)
    static var newPurple = Color.init(r: 157, g: 129, b: 200)
    
    static var wildStrawberry = Color.init(r: 255, g: 92, b: 203)
    
//    static var colorSelection: [Color] {
//        [.primary, .white, brighterBlue, darkerBlue, newPurple, pink, wildStrawberry, newRed, .yellow, newOrange, brown, oliveGreen, jungleGreen]
//    }
}

// MARK: the third way
extension Binding {
    func onChange(_ handler: @escaping (Value) -> Void) -> Binding<Value> {
        return Binding(
            get: { self.wrappedValue },
            set: { selection in
                self.wrappedValue = selection
                handler(selection)
        })
    }
}

extension NSManagedObject {
    
    static func fromURI(uri: URL, context: NSManagedObjectContext) -> NSManagedObject? {
        let id = context.persistentStoreCoordinator?.managedObjectID(forURIRepresentation: uri)
        if id == nil { return nil }
        let object = try? context.existingObject(with: id!)
        return object
    }
    
    var stringID: String {
        self.objectID.uriRepresentation().absoluteString
    }
    
    var urlID: URL {
        self.objectID.uriRepresentation()
    }
    
    func save() {
        if let context = self.managedObjectContext {
            do {
                // self.objectWillChange.send()
                try context.save()
            } catch {
                print("Unexpected Error when saving managed object")
            }
        }
    }
    
}

extension Animation {
    
    static var courseAnimation: Animation {
        self.linear(duration: 3)
    }
}



extension Int {
    init(_ bool: Bool) {
        if bool { self = 1 }
        else { self = 0 }
    }
}

struct IdentifiableString: Identifiable {
    var id = UUID()
    var value: String
}

extension String {
    // returns ourself without any duplicate Characters
    // not very efficient, so only for use on small-ish Strings
    func uniqued() -> String {
        var uniqued = ""
        for ch in self {
            if !uniqued.contains(ch) {
                uniqued.append(ch)
            }
        }
        return uniqued
    }
    // returns ourself but with numbers appended to the end
    // if necessary to make ourself unique with respect to those other Strings
    func uniqued<StringCollection>(withRespectTo otherStrings: StringCollection) -> String
        where StringCollection: Collection, StringCollection.Element == String {
        var unique = self
        while otherStrings.contains(unique) {
            unique = unique.incremented
        }
        return unique
    }
    
    // if a number is at the end of this String
    // this increments that number
    // otherwise, it appends the number 1
    var incremented: String  {
        let prefix = String(self.reversed().drop(while: { $0.isNumber }).reversed())
        if let number = Int(self.dropFirst(prefix.count)) {
            return "\(prefix)\(number+1)"
        } else {
            return "\(self) 1"
        }
    }
}

extension NSPredicate {
    static var all = NSPredicate(format: "TRUEPREDICATE")
    static var none = NSPredicate(format: "FALSEPREDICATE")
}

public extension String {
    func numericValue(allowDecimalSeparator: Bool, maxDigits: Int = 42) -> String? {
        var hasFoundDecimal = false
        var numbersFound = 0
        if self.first?.isNumber != true { return nil }
        var numeric = self.filter {
            if $0.isWholeNumber {
                numbersFound += 1
                return true
            } else if allowDecimalSeparator && ($0 == "." || $0 == ",") {
                defer { hasFoundDecimal = true }
                return !hasFoundDecimal
            }
            return false
        }
        if numbersFound > maxDigits { numeric.removeLast(numbersFound - maxDigits) }
        return numeric
    }
}

struct MyButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .background(configuration.isPressed ? Color.blue : Color.gray)
    }
}

extension Array where Element == NSItemProvider {
    func loadObjects<T>(ofType theType: T.Type, firstOnly: Bool = false, using load: @escaping (T) -> Void) -> Bool where T: NSItemProviderReading {
        if let provider = first(where: { $0.canLoadObject(ofClass: theType) }) {
            print(provider)
            provider.loadObject(ofClass: theType) { object, error in
                if let value = object as? T {
                    DispatchQueue.main.async {
                        load(value)
                    }
                }
            }
            return true
        }
        return false
    }
    func loadObjects<T>(ofType theType: T.Type, firstOnly: Bool = false, using load: @escaping (T) -> Void) -> Bool where T: _ObjectiveCBridgeable, T._ObjectiveCType: NSItemProviderReading {
        if let provider = first(where: { $0.canLoadObject(ofClass: theType) }) {
            let _ = provider.loadObject(ofClass: theType) { object, error in
                if let value = object {
                    DispatchQueue.main.async {
                        load(value)
                    }
                }
            }
            return true
        }
        return false
    }
    func loadFirstObject<T>(ofType theType: T.Type, using load: @escaping (T) -> Void) -> Bool where T: NSItemProviderReading {
        loadObjects(ofType: theType, firstOnly: true, using: load)
    }
    func loadFirstObject<T>(ofType theType: T.Type, using load: @escaping (T) -> Void) -> Bool where T: _ObjectiveCBridgeable, T._ObjectiveCType: NSItemProviderReading {
        loadObjects(ofType: theType, firstOnly: true, using: load)
    }
}

//extension Concentration {
//
//    func getColor(dark: Bool) -> Color {
//        if self.color == 0 { return (dark ? .white : .black) }
//        return Color.colorSelection[self.color]
//    }
//}


//extension GeometryProxy {
//    func convert(_ point: CGPoint, from coordinateSpace: CoordinateSpace) -> CGPoint {
//        let frame = self.frame(in: coordinateSpace)
//        return CGPoint(x: point.x-frame.origin.x, y: frame.height - point.y + frame.origin.y )
//    }
//}

//
//struct MultilineTextField: NSViewRepresentable {
//
//    typealias NSViewType = NSTextView
//    private let textView = NSTextView()
//    @Binding var text: String
//
//    func makeNSView(context: Context) -> NSTextView {
//        textView.delegate = context.coordinator
//        let color = textView.backgroundColor
//        let allows = textView.allowsDocumentBackgroundColorChange
//        textView.allowsDocumentBackgroundColorChange = true
//        print(allows)
//        print(color)
//        textView.changeDocumentBackgroundColor(NSColor.systemRed)
//        return textView
//    }
//    func updateNSView(_ nsView: NSTextView, context: Context) {
//        nsView.string = text
//    }
//    func makeCoordinator() -> Coordinator {
//        return Coordinator(self)
//    }
//    class Coordinator: NSObject, NSTextViewDelegate {
//        let parent: MultilineTextField
//        init(_ textView: MultilineTextField) {
//            parent = textView
//        }
//        func textDidChange(_ notification: Notification) {
//            guard let textView = notification.object as? NSTextView else { return }
//            self.parent.text = textView.string
//        }
//    }
//}


//extension CGPoint {
//    static func -(lhs: Self, rhs: Self) -> CGSize {
//        CGSize(width: lhs.x - rhs.x, height: lhs.y - rhs.y)
//    }
//    static func +(lhs: Self, rhs: CGSize) -> CGPoint {
//        CGPoint(x: lhs.x + rhs.width, y: lhs.y + rhs.height)
//    }
//    static func -(lhs: Self, rhs: CGSize) -> CGPoint {
//        CGPoint(x: lhs.x - rhs.width, y: lhs.y - rhs.height)
//    }
//    static func *(lhs: Self, rhs: CGFloat) -> CGPoint {
//        CGPoint(x: lhs.x * rhs, y: lhs.y * rhs)
//    }
//    static func /(lhs: Self, rhs: CGFloat) -> CGPoint {
//        CGPoint(x: lhs.x / rhs, y: lhs.y / rhs)
//    }
//}
//
//extension CGSize {
//    static func +(lhs: Self, rhs: Self) -> CGSize {
//        CGSize(width: lhs.width + rhs.width, height: lhs.height + rhs.height)
//    }
//    static func -(lhs: Self, rhs: Self) -> CGSize {
//        CGSize(width: lhs.width - rhs.width, height: lhs.height - rhs.height)
//    }
//    static func *(lhs: Self, rhs: CGFloat) -> CGSize {
//        CGSize(width: lhs.width * rhs, height: lhs.height * rhs)
//    }
//    static func /(lhs: Self, rhs: CGFloat) -> CGSize {
//        CGSize(width: lhs.width/rhs, height: lhs.height/rhs)
//    }
//}

//extension CGImage {
//  // width is for total, ratio is second stripe relative to full width
//  static func stripes(colors: (NSColor, NSColor), width: CGFloat, ratio: CGFloat) -> CGImage {
//    let filter = CIFilter.stripesGenerator()
//    filter.color0 = CIColor(color: colors.0) ?? .black
//    filter.color1 = CIColor(color: colors.1) ?? .white
//    filter.width = Float(width-width*ratio)
//    filter.center = CGPoint(x: width, y: 0)
//    let size = CGSize(width: width+width*ratio, height: 1)
//    let bounds = CGRect(origin: .zero, size: size)
//    // keep a reference to a CIContext if calling this often
//    return CIContext().createCGImage(filter.outputImage!.clamped(to: bounds), from: bounds)!
//  }
//}

//struct NumberTextField<V>: UIViewRepresentable where V: Numeric & LosslessStringConvertible {
//    @Binding var value: V
//
//    typealias UIViewType = UITextField
//
//    func makeUIView(context: UIViewRepresentableContext<NumberTextField>) -> UITextField {
//        let editField = UITextField()
//        editField.delegate = context.coordinator
//        return editField
//    }
//
//    func updateUIView(_ editField: UITextField, context: UIViewRepresentableContext<NumberTextField>) {
//        editField.text = String(value)
//    }
//
//    func makeCoordinator() -> NumberTextField.Coordinator {
//        Coordinator(value: $value)
//    }
//
//    class Coordinator: NSObject, UITextFieldDelegate {
//        var value: Binding<V>
//
//        init(value: Binding<V>) {
//            self.value = value
//        }
//
//        func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange,
//                       replacementString string: String) -> Bool {
//
//            let text = textField.text as NSString?
//            let newValue = text?.replacingCharacters(in: range, with: string)
//
//            if let number = V(newValue ?? "0") {
//                self.value.wrappedValue = number
//                return true
//            } else {
//                if nil == newValue || newValue!.isEmpty {
//                    self.value.wrappedValue = 0
//                }
//                return false
//            }
//        }
//
//        func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
//            if reason == .committed {
//                textField.resignFirstResponder()
//            }
//        }
//    }
//}

//extension FetchedResults: PreferenceKey where Result == Course {
//    public typealias Value = <#type#>
//    
//    public typealias Value = Course
//  
//    
//}


