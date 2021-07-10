//
//  PanelView.swift
//  ClassPlanner
//
//  Created by Edvin Berhan on 2021-05-15.
//

import SwiftUI

struct PanelView: View {
    
    @EnvironmentObject var shared: SharedVM
    
    @ObservedObject var scheduleStore: ScheduleStore
    @ObservedObject var courseStore: CourseStore
    @ObservedObject var courseSuggestionVM: CourseSuggestionVM
    @ObservedObject var categorySuggestionVM: CategorySuggestionVM
    @ObservedObject var concentrationVM: ConcentrationVM
    @ObservedObject var schedule: ScheduleVM
    
    @Environment(\.managedObjectContext) var context
    
    var body: some View {
        VStack(spacing: 7) {
            Spacer().frame(height: 5)
            symbolsView
            Divider()
            getPanelContent(shared.currentPanelSelection)
        }
    }
    
    
    var symbolsView: some View {
        HStack {
            Spacer()
            ForEach (PanelOption.allCases, id: \.self) { option in
                Text(PanelOption.symbols[option] ?? "X")
                    .foregroundColor(shared.currentPanelSelection == option ? .blue : nil)
                    .contentShape(Rectangle())
                    .onTapGesture { shared.setPanelSelection(to: option) }
                    .font(.system(size: 16, weight: .regular, design: .default))
                Spacer()
            }
        }
    }
    
    
    @ViewBuilder
    func getPanelContent(_ selection: PanelOption) -> some View {
        switch selection {
            case .editor:
                getEditor(shared.currentEditSelection)
            case .courses:
                CourseStoreView()
            case .concentrations:
                ConcentrationStoreView(concentrationVM: concentrationVM)
            case .schedules:
                ScheduleStoreView(store: scheduleStore)
        }
    }
    
    @ViewBuilder
    func getEditor(_ selection: EditOption) -> some View {
        switch selection {
        case .course(let course):
            VStack(spacing: 0) {
                Text("Course").font(.system(size: 15)).opacity(grayTextOpacity)
                CourseEditorView(course: course, courseSuggestionVM: courseSuggestionVM, context: context)
            }
            
        case .category(let category):
            VStack(spacing: 0) {
                Text("Category").font(.system(size: 15)).opacity(grayTextOpacity)
                CategoryEditorView(category: category, categorySuggestionVM: categorySuggestionVM, context: context)
            }

        case .concentration(let concentration):
            VStack(spacing: 0) {
                Text("Major").font(.system(size: 15)).opacity(grayTextOpacity)
                ConcentrationEditorView(concentration: concentration, concentrationVM: concentrationVM, schedule: schedule)
            }
        case .schedule(let schedule):
            VStack(spacing: 0) {
                Text("Schedule").font(.system(size: 15)).opacity(grayTextOpacity)
                ScheduleEditorView(schedule: schedule, scheduleStore: scheduleStore)
                    .alert(item: $scheduleStore.existingNameAlert) { nameString in
                        Alert(title: Text("Naming Conflict"),
                              message: Text("Existing schedule with name: \(nameString.value) \nPlease pick another name."),
                              dismissButton: .default(Text("OK")))
                    }
            }
                .onDisappear { scheduleStore.setName(schedule.name, for: schedule) }
        case .none:
            VStack {
                Spacer()
                Text("No Selection")
                    .font(.system(size: 15))
                    .opacity(grayTextOpacity)
                Spacer()
            }
            
        }
        
        
    }
}


//            TabView(selection: $viewModel.currentPanelSelection,
//                    content:  {
//                        Text("Tab Content 1").tabItem { /*@START_MENU_TOKEN@*/Text("Tab Label 1")/*@END_MENU_TOKEN@*/ }.tag(1)
//                        Text("Tab Content 2").tabItem { /*@START_MENU_TOKEN@*/Text("Tab Label 2")/*@END_MENU_TOKEN@*/ }.tag(2)
//                    })


//                Group {
//                    Spacer()
//                    Text("Editor")
//                        .foregroundColor(panel.currentPanelSelection == .editor(selection: .none) ? .blue : nil)
//                        .onTapGesture { panel.setPanelSelection(to: .editor(selection: panel.currentEditSelection)) }
//                    Spacer()
//                    Text("Courses")
//                        .foregroundColor(panel.currentPanelSelection == .courses ? .blue : nil)
//                        .onTapGesture { panel.setPanelSelection(to: .courses) }
//                    Spacer()
//                    Text("Concen")
//                        .foregroundColor(panel.currentPanelSelection == .concentrations ? .blue : nil)
//                        .onTapGesture { panel.setPanelSelection(to: .concentrations) }
//                    Spacer()
//                }
//                Group {
//                    Text("Schedules")
//                        .foregroundColor(panel.currentPanelSelection == .schedules ? .blue : nil)
//                        .onTapGesture { panel.setPanelSelection(to: .schedules) }
//                    Spacer()
//                    Text("Other People")
//                        .foregroundColor(panel.currentPanelSelection == .otherPeople ? .blue : nil)
//                        .onTapGesture { panel.setPanelSelection(to: .otherPeople) }
//                    Spacer()
//                }

//struct PanelView_Previews: PreviewProvider {
//    static var previews: some View {
//        PanelView()
//    }
//}
