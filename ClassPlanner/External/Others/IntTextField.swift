//
//  IntTextField.swift
//  ClassPlanner
//
//  Created by Edvin Berhan on 2021-05-14.
//

import SwiftUI

struct IntTextField: View {
    
    private var placeholder: String
    private var onCommit: () -> ()
    
    @Binding private var number: Int
    @State private var string: String
    @State private var addedSeparator: Bool = false
    
    init(_ placeholder: String, integer: Binding<Int>, onCommit: @escaping () -> ()) {
        self._number = integer
        self._string = State(wrappedValue: String(integer.wrappedValue))
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
        numberFormatter.localizesFormat = true
        return numberFormatter
    }
    
    var numberProxy: Binding<String> {
        Binding<String>(
            get: {
                if number == 0 { return "" }
                return numberFormatter.string(from: NSNumber(value: number)) ?? ""
            },
            set: { input in
                if let numeric = input.numericValue(allowDecimalSeparator: false, maxDigits: maxSignificant) {
                    if let value = numberFormatter.number(from: numeric) {
                        number = value.intValue
                    }
                }
                else { number = 0 }
            }
        )
    }
}
