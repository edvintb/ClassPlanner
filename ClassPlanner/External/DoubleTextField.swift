//
//  NumberTextField.swift
//  ClassPlanner
//
//  Created by Edvin Berhan on 2021-05-14.
//

import SwiftUI
import Combine

struct DoubleTextField: View {

    private var placeholder: String
    private var onCommit: () -> ()
    
    @Binding private var number: Double
    @State private var string: String
    @State private var addedSeparator: Bool = false
    
    init(_ placeholder: String, double: Binding<Double>, onCommit: @escaping () -> ()) {
        self._number = double
        self._string = State(wrappedValue: String(double.wrappedValue))
        self.placeholder = placeholder
        self.onCommit = onCommit
    }
    
    var body: some View {
        TextField(placeholder, text: numberProxy, onCommit: onCommit)
            .cornerRadius(textFieldCornerRadius)
    }
    
    var numberFormatter: NumberFormatter {
        let numberFormatter = NumberFormatter()
        numberFormatter.maximumIntegerDigits = maxIntegers
        numberFormatter.maximumFractionDigits = maxDecimals
        numberFormatter.maximumSignificantDigits = maxSignificant
        numberFormatter.localizesFormat = true
        return numberFormatter
    }
    
    var numberProxy: Binding<String> {
        Binding<String>(
            get: {
                if number == 0 { return "" }
                return ((numberFormatter.string(from: NSNumber(value: number)) ?? "")
                        + (addedSeparator ? (Locale.current.decimalSeparator ?? ".") : ""))
            },
            set: { input in
                if let numeric = input.numericValue(allowDecimalSeparator: true, maxDigits: maxSignificant) {
                    if (numeric.last == "." || numeric.last == ",") { addedSeparator = true }
                    else { addedSeparator = false }
                    if let value = numberFormatter.number(from: numeric) {
                        number = value.doubleValue
                    }
                }
                else { number = 0 }
            }
        )
    }
    
//    func numberChanged(newValue: String) {
//        if let numeric = newValue.numericValue(allowDecimalSeparator: true, maxDigits: maxSignificant) {
//            if newValue != numeric {
//                string = numeric
//            }
//            if let value = numberFormatter.number(from: string) {
//                number = value.doubleValue
//            }
//            else { number = 0 }
//        }
//
//    }
    
    
}

//struct DoubleTextField_Previews: PreviewProvider {
//    static var previews: some View {
//        DoubleTextField(number: .constant(3))
//    }
//}

//                if let last = input.last {
//                    var output = input
//                    if output.filter({ $0.isNumber }).count > maxSignificant { output.removeLast() }
//                    if last == "." || last == "," {
//                        if input.dropLast().contains(".") { output.removeLast() }
//                        else if input.dropLast().contains(",") { output.removeLast() }
//                        else { addedSeparator = true }
//                    }
//                    else if !last.isNumber { output.removeLast() }
//                    else { addedSeparator = false }
//                    if output == "" { number = 0 }
//                    if let value = numberFormatter.number(from: output) {
//                        number = value.doubleValue
//                    }
//
//                }
//                else { number = 0 }
                
//                if $0 == "" { number = 0; return }
//                var string = $0.filter { $0.isNumber }
//                if let index = $0.firstIndex(where: { char in char == "." || char == "," }) {
//                    string.insert(contentsOf: (Locale.current.decimalSeparator ?? ""), at: index)
//                    if string.last == "." || string.last == "," {
//                        addSeparator = true
//                        print("Setting separtor to \(addSeparator)")
//                        string.removeLast(1)
//                    }
//                    else { addSeparator = false }
//                }
//                else { addSeparator = false }
//                if let value = numberFormatter.number(from: string) {
//                    course.qscore = value.doubleValue
//                }
//                else {
//                    print("Could not convert value: \(string)")
//                }
//            }
//        )
//    }
//
//            .onReceive(Just(string)) { newValue in
//                numberChanged(newValue: newValue)
//            }
