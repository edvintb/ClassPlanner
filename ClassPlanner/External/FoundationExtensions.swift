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

//import UIKit

extension NSPredicate {
    static var all = NSPredicate(format: "TRUEPREDICATE")
    static var none = NSPredicate(format: "FALSEPREDICATE")
}

extension GeometryProxy {
    func convert(_ point: CGPoint, from coordinateSpace: CoordinateSpace) -> CGPoint {
        let frame = self.frame(in: coordinateSpace)
        return CGPoint(x: point.x-frame.origin.x, y: frame.height - point.y + frame.origin.y )
    }
}

extension CGPoint {
    static func -(lhs: Self, rhs: Self) -> CGSize {
        CGSize(width: lhs.x - rhs.x, height: lhs.y - rhs.y)
    }
    static func +(lhs: Self, rhs: CGSize) -> CGPoint {
        CGPoint(x: lhs.x + rhs.width, y: lhs.y + rhs.height)
    }
    static func -(lhs: Self, rhs: CGSize) -> CGPoint {
        CGPoint(x: lhs.x - rhs.width, y: lhs.y - rhs.height)
    }
    static func *(lhs: Self, rhs: CGFloat) -> CGPoint {
        CGPoint(x: lhs.x * rhs, y: lhs.y * rhs)
    }
    static func /(lhs: Self, rhs: CGFloat) -> CGPoint {
        CGPoint(x: lhs.x / rhs, y: lhs.y / rhs)
    }
}

extension CGSize {
    static func +(lhs: Self, rhs: Self) -> CGSize {
        CGSize(width: lhs.width + rhs.width, height: lhs.height + rhs.height)
    }
    static func -(lhs: Self, rhs: Self) -> CGSize {
        CGSize(width: lhs.width - rhs.width, height: lhs.height - rhs.height)
    }
    static func *(lhs: Self, rhs: CGFloat) -> CGSize {
        CGSize(width: lhs.width * rhs, height: lhs.height * rhs)
    }
    static func /(lhs: Self, rhs: CGFloat) -> CGSize {
        CGSize(width: lhs.width/rhs, height: lhs.height/rhs)
    }
}

extension CGImage {
  // width is for total, ratio is second stripe relative to full width
  static func stripes(colors: (NSColor, NSColor), width: CGFloat, ratio: CGFloat) -> CGImage {
    let filter = CIFilter.stripesGenerator()
    filter.color0 = CIColor(color: colors.0) ?? .black
    filter.color1 = CIColor(color: colors.1) ?? .white
    filter.width = Float(width-width*ratio)
    filter.center = CGPoint(x: width, y: 0)
    let size = CGSize(width: width+width*ratio, height: 1)
    let bounds = CGRect(origin: .zero, size: size)
    // keep a reference to a CIContext if calling this often
    return CIContext().createCGImage(filter.outputImage!.clamped(to: bounds), from: bounds)!
  }
}

public extension String {
    func numericValue(allowDecimalSeparator: Bool, maxDigits: Int = 42) -> String? {
        var hasFoundDecimal = false
        var numbersFound = 0
        if self.first?.isNumber != true { return nil }
        var numeric = self.filter {
            print("Filter called")
            if $0.isWholeNumber {
                numbersFound += 1
                return true
            } else if allowDecimalSeparator && ($0 == "." || $0 == ",") {
                defer { print("Defered call"); hasFoundDecimal = true }
                print("Returned")
                return !hasFoundDecimal
            }
            return false
        }
        print("Exited filter")
        if numbersFound > maxDigits { numeric.removeLast(numbersFound - maxDigits) }
        return numeric
    }
}

extension Int {
    init(_ bool: Bool) {
        if bool { self = 1 }
        else { self = 0 }
    }
}

extension NSPoint {
    
}

extension Array {
    
}


struct MultilineTextField: NSViewRepresentable {
    
    typealias NSViewType = NSTextView
    private let textView = NSTextView()
    @Binding var text: String
    
    func makeNSView(context: Context) -> NSTextView {
        textView.delegate = context.coordinator
        let color = textView.backgroundColor
        let allows = textView.allowsDocumentBackgroundColorChange
        textView.allowsDocumentBackgroundColorChange = true
        print(allows)
        print(color)
        textView.changeDocumentBackgroundColor(NSColor.systemRed)
        return textView
    }
    func updateNSView(_ nsView: NSTextView, context: Context) {
        nsView.string = text
    }
    func makeCoordinator() -> Coordinator {
        return Coordinator(self)
    }
    class Coordinator: NSObject, NSTextViewDelegate {
        let parent: MultilineTextField
        init(_ textView: MultilineTextField) {
            parent = textView
        }
        func textDidChange(_ notification: Notification) {
            guard let textView = notification.object as? NSTextView else { return }
            self.parent.text = textView.string
        }
    }
}

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


