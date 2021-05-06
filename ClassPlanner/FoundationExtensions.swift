//
//  FoundationExtensions.swift
//  ClassPlanner
//
//  Created by Edvin Berhan on 2021-03-21.
//

import Foundation
import SwiftUI
import CoreData
//import UIKit

extension NSPredicate {
    static var all = NSPredicate(format: "TRUEPREDICATE")
    static var none = NSPredicate(format: "FALSEPREDICATE")
}

extension GeometryProxy {
    func convert(_ point: CGPoint, from coordinateSpace: CoordinateSpace) -> CGPoint {
        let frame = self.frame(in: coordinateSpace)
        return CGPoint(x: point.x-frame.origin.x, y: point.y-frame.origin.y)
    }
}

extension Array {
    
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

