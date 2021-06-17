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
    
    // The state object keeps its state and is not recreated
    @ObservedObject var model: SuggestionsModel<V>
    
    init(text: Binding<String>, suggestionGroups: [SuggestionGroup<V>], suggestionModel: SuggestionsModel<V>) {
        self._text = text
        self.suggestionGroups = suggestionGroups
        self.model = suggestionModel
    }
    
    var body: some View {
        let model = self.model
        if model.suggestionGroups != self.suggestionGroups {
            model.suggestionGroups = self.suggestionGroups
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
                .clipShape(RoundedRectangle(cornerRadius: 8))
                .shadow(color: Color(white: 0, opacity: 0.10),
                        radius: 5, x: 0, y: 2)
            }
    }
}

