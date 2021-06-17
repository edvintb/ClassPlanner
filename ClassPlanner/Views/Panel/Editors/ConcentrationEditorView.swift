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
    @ObservedObject var concentrationVM: ConcentrationVM
    @ObservedObject var schedule: ScheduleVM
    
    private var categories: [Category] { concentration.categories.sorted(by: { $0.index < $1.index }) }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            EditorHeader(title: concentration.name, notes: concentration.notes, color: concentration.getColor())
            Form {
                NameEditor(entryView: nameField)
                NoteEditor(text: $concentration.notes) { concentration.save() }
                Spacer().frame(height: 30)
                Section(header: Text("Click to Remove").opacity(grayTextOpacity)) {
                    categoriesView
                }
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
    
    var categoriesView: some View {
        ZStack {
            RoundedRectangle(cornerRadius: frameCornerRadius).stroke().opacity(emptyOpacity)
            GeometryReader { geo in
                ScrollView {
                    Columns(categories, numberOfColumns: 2, moreView: EmptyView()) { category in
                        categoryView(category)
                    }
                }.cornerRadius(frameCornerRadius)
            }
        }
    }
    
    func categoryView(_ category: Category) -> some View {
        CategoryView(category: category, schedule: schedule)
        .padding(10)
        .contentShape(Rectangle())
        .onTapGesture {
            withAnimation {
                concentration.removeCategory(category)
            }
        }
    }
    
    func deleteAction() {
        shared.stopEdit()
        concentrationVM.removeConcentration(concentration)
        concentration.delete()
        concentration.save()
    }
    
    var bottomButtons: some View {
        HStack {
            EditorButtons(deleteAction: deleteAction, closeAction: shared.stopEdit)
            Spacer()
            addRemoveButton
        }
    }
    
    var addRemoveButton: some View {
        if concentrationVM.currentConcentrations.contains(concentration.urlID) {
            return
                Button("Remove from current") {
                    withAnimation {
                        concentrationVM.removeConcentration(concentration)
                        // concentration.save()
                    }
                }
        }
        else {
            return
                Button("Add to current") {
                    withAnimation {
                        concentrationVM.moveInsertConcentration(concentration, at: 0)
                    }
                }
        }
    }
}
