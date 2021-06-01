//
//  SuggestionInput.swift
//  SuggestionsDemo
//
//  Created by Stephan Michels on 13.12.20.
//

import SwiftUI

struct Suggestion<V: Equatable>: Equatable {
    var text: String = ""
    var value: V
    
    static func ==(_ lhs: Suggestion<V>, _ rhs: Suggestion<V>) -> Bool {
        return lhs.value == rhs.value
    }
}

struct SuggestionGroup<V: Equatable>: Equatable {
    var title: String?
    var suggestions: [Suggestion<V>]
    
    static func ==(_ lhs: SuggestionGroup<V>, _ rhs: SuggestionGroup<V>) -> Bool {
        return lhs.suggestions == rhs.suggestions
    }
}

struct SuggestionInput<V: Equatable>: View {
    
    @Binding var text: String
    var suggestionGroups: [SuggestionGroup<V>]
    
    // Workaround might be to create it outside and pass it in?
    // The state object keeps its state and is not recreated
    @ObservedObject var model: SuggestionsModel<V>
    
    init(text: Binding<String>, suggestionGroups: [SuggestionGroup<V>], suggestionModel: SuggestionsModel<V>) {
        self._text = text
        self.suggestionGroups = suggestionGroups
        self.model = suggestionModel
//        print("Input Init for text: \(text.wrappedValue)")
        
//        print(suggestionGroups)
    }
    
    var body: some View {
        let model = self.model
        if model.suggestionGroups != self.suggestionGroups {
            model.suggestionGroups = self.suggestionGroups
//            print("Updating model suggestions to \(model.suggestionGroups.first?.suggestions.first?.text ?? "nil")")
            model.selectedSuggestion = nil
        }
        
        model.textBinding = self.$text
        
        return SuggestionTextField(text: self.$text, model: model)
            .borderlessWindow(isVisible: Binding<Bool>(get: { model.suggestionsVisible && !model.suggestionGroups.isEmpty }, set: { model.suggestionsVisible = $0 }),
                              behavior: .transient,
                              anchor: .bottomLeading,
                              windowAnchor: .topLeading,
                              windowOffset: CGPoint(x: 0, y: 0)) {
                SuggestionPopup(model: model)
                    .frame(width: model.width)
                    .background(VisualEffectBlur(material: .popover, blendingMode: .behindWindow, cornerRadius: 8))
//                    .visualEffect(.adaptive(.windowBackground))
                .clipShape(RoundedRectangle(cornerRadius: 8))
//                .overlay(RoundedRectangle(cornerRadius: 8)
//                            .stroke(lineWidth: 1)
//                            .foregroundColor(Color(white: 0.6, opacity: 0.2))
//                )
                .shadow(color: Color(white: 0, opacity: 0.10),
                        radius: 5, x: 0, y: 2)
//                .padding(20)
                    .onAppear { print("Popup appeared")}
            }
    }
}

struct SuggestionInput_Previews: PreviewProvider {
    static var previews: some View {
        let text = Binding.constant("CS")
        let suggestion = Suggestion<String>(text: "CS50", value: "CS50")
        let suggestionGroup = SuggestionGroup(title: "Courses", suggestions: [suggestion])
        let model = SuggestionsModel<String>()
        
        SuggestionInput(text: text, suggestionGroups: [suggestionGroup], suggestionModel: model)
    }
}
