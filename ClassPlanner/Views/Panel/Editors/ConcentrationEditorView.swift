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
    
    @Binding var isShowingOnboarding: Bool
    private func setConcEditorOnboarding(show: Bool) {
        withAnimation {
            self.isShowingOnboarding = show
            UserDefaults.standard.setValue(!show, forKey: concentrationEditorOnboardingKey)
        }
    }
    
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
                .opacity(grayTextOpacity)
            Spacer()
            Button(action: { withAnimation { let _ = concentration.addCategory() }}, label: {
                if #available(macOS 11.0, *) {
                    Image(systemName: "plus")
                } else {
                    Text("+")
                }
            })
        }
        
    }
    
    var categoriesView: some View {
        ZStack(alignment: .topLeading) {
            RoundedRectangle(cornerRadius: frameCornerRadius).stroke().opacity(emptyOpacity)
            ScrollView {
                Columns(categories, moreView: EmptyView()) { category in
                    categoryView(category)
                        .frame(minHeight: 100)
                }
                .cornerRadius(frameCornerRadius)
            }
        }.popover(isPresented: $isShowingOnboarding) {
            CategoryOnboardingView(
                isShowingOnboarding: $isShowingOnboarding,
                setCategoryOnboarding: setConcEditorOnboarding
            )
        }
    }
    
    func categoryView(_ category: Category) -> some View {
        CategoryView(category: category, schedule: schedule)
        .padding(10)
        .contentShape(Rectangle())
    }
    
    func deleteAction() {
        shared.stopEdit()
        concentrationVM.removeFromCurrentConcentrations(concentration)
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
                        concentrationVM.removeFromCurrentConcentrations(concentration)
                        // concentration.save()
                    }
                }
        }
        else {
            return
                Button("Add to current") {
                    withAnimation {
                        concentrationVM.moveInsertCurrentConcentration(concentration, at: 0)
                    }
                }
        }
    }
}


//                        VStack {
//                            ForEach(0..<maxIndex, id: \.self) { index in
//                                HStack(alignment: .top) {
//                                    categoryView(categories[2*index])
//                                    if (index == (maxIndex - 1) && categories.count % 2 == 1) {
//                                        Spacer()
//                                    }
//                                    else {
//                                        categoryView(categories[2*index + 1]).frame(alignment: .topLeading)
//                                    }
//                                }
//                            }
//                        }
