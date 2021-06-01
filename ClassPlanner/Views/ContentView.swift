//
//  ContentView.swift
//  ClassPlanner
//
//  Created by Edvin Berhan on 2021-04-24.
//

import SwiftUI

struct ContentView: View {
    
    @EnvironmentObject var panel: PanelVM
    
    @ObservedObject var scheduleStore: ScheduleStore
    @ObservedObject var courseStore: CourseStore
    @ObservedObject var concentration: ConcentrationVM
    
//    @Environment(\.managedObjectContext) var context
    
//    @ObservedObject var model: SearchModel
    
    let suggestionModel = SuggestionsModel<Course>()

    var body: some View {
        NavigationView {
//            EditorView(viewModel: vm).frame(minWidth: editorWidth*1.1, idealWidth: editorWidth*1.2, maxWidth: .infinity, alignment: .top).padding(5)
//            HSplitView {
            PanelView(scheduleStore: scheduleStore, courseStore: courseStore, panel: panel)
                    .frame(minWidth: editorWidth*1.1, alignment: .top)
                VSplitView {
                    ScheduleView(store: scheduleStore, schedule: schedule)
                        .frame(minHeight: scheduleMinHeight, idealHeight: 400)
                    ConcentrationContainerView(concentrationVM: concentration)
                        .frame(minHeight: concentrationsMinHeight, idealHeight: 150)
                }
                .frame(minWidth: mainMinWidth, idealWidth: 600)
            }
//        }
    }
    
//    var body: some View {
//        SuggestionInput(text: $model.currentText, suggestionGroups: model.suggestionGroups, suggestionModel: suggestionModel)
//    }
    
    
    private var schedule: ScheduleVM {
        if let schedule = scheduleStore.currentSchedule {
            return schedule
        }
        else if let schedule = scheduleStore.schedules.first {
            scheduleStore.setCurrentSchedule(to: schedule)
            return schedule
        }
        else {
            scheduleStore.addSchedule()
            let newSchedule = scheduleStore.schedules.first!
            scheduleStore.setCurrentSchedule(to: newSchedule)
            return newSchedule
        }
    }
}

//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        ContentView()
//    }
//}
