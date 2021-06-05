//
//  ConcenterationEditorView.swift
//  ClassPlanner
//
//  Created by Edvin Berhan on 2021-06-04.
//

import SwiftUI

struct ConcentrationEditorView: View {
    
    @EnvironmentObject var shared: SharedVM
    @ObservedObject var concentration: Concentration
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            EditorHeader(title: concentration.name, notes: concentration.notes, color: concentration.getColor())
            Form {
                NameEditor(entryView: nameField)
                NoteEditor(text: $concentration.notes) { concentration.save() }
                EditorColorGrid { concentration.color = $0; concentration.save() }
                EditorButtons(deleteAction: deleteAction, closeAction: shared.stopEdit)
            }
            .padding(editorPadding)
        }
    }
    
    var nameField: some View {
        TextField("Name", text: $concentration.name, onCommit: { concentration.save()} )
            .cornerRadius(textFieldCornerRadius)
    }
    
    func deleteAction() {
        shared.stopEdit()
        concentration.delete()
    }
}
