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
                Section(header: categorySectionHeader) {
                    categoriesView
                }
                EditorColorGrid { concentration.color = $0; concentration.save() }
                bottomButtons
            }
            .padding(editorPadding)
        }
    }
    
    var nameField: some View {
        TextField("Name", text: $concentration.name, onCommit: { concentration.save()} )
            .cornerRadius(textFieldCornerRadius)
    }
    
    var categorySectionHeader: some View {
        HStack {
            Text("Categories")
            Spacer()
            Text("Click to Remove")
        }
        .opacity(grayTextOpacity)
    }
    
    var categoriesView: some View {
        ZStack {
            RoundedRectangle(cornerRadius: frameCornerRadius).stroke().opacity(emptyOpacity)
            GeometryReader { geo in
                ScrollView {
                    Columns(categories, numberOfColumns: 2, moreView: EmptyCategoryView(concentration: concentration)) { category in
                        categoryView(category)
                    }
                    .frame(width: geo.size.width)
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
                category.delete()
            }
        }
    }
    
    func deleteAction() {
        shared.stopEdit()
        concentrationVM.removeConcentration(concentration)
        concentration.delete()
        concentration.save()
        shared.setPanelSelection(to: .concentrations)
    }
    
    func closeAction() {
        shared.stopEdit()
        shared.setPanelSelection(to: .concentrations)
    }
    
    var bottomButtons: some View {
        HStack {
            EditorButtons(deleteAction: deleteAction, closeAction: closeAction)
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
