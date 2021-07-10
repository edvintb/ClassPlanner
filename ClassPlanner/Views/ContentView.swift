//
//  ContentView.swift
//  ClassPlanner
//
//  Created by Edvin Berhan on 2021-04-24.
//

import SwiftUI

struct ContentView: View {
    
    @EnvironmentObject var shared: SharedVM
    
    @ObservedObject var scheduleStore: ScheduleStore
    @ObservedObject var courseStore: CourseStore
    @ObservedObject var concentrationVM: ConcentrationVM
    @ObservedObject var courseSuggestionVM: CourseSuggestionVM
    @ObservedObject var categorySuggestionVM: CategorySuggestionVM

    var body: some View {
        HSplitView {
            PanelView(scheduleStore: scheduleStore,
                      courseStore: courseStore,
                      courseSuggestionVM: courseSuggestionVM,
                      categorySuggestionVM: categorySuggestionVM,
                      concentrationVM: concentrationVM,
                      schedule: schedule)
                .frame(minWidth: editorWidth*1.1, maxWidth: 500, alignment: .top)
                VSplitView {
                    ScheduleView(store: scheduleStore, schedule: schedule)
                        .frame(minHeight: scheduleMinHeight, idealHeight: 400)
                    ConcentrationContainerView(schedule: schedule, concentrationVM: concentrationVM)
                        .frame(minHeight: concentrationsMinHeight, idealHeight: 150)
                }
            }
    }
    
    private var schedule: ScheduleVM {
        if let schedule = shared.currentSchedule {
            return schedule
        }
        else if let schedule = scheduleStore.schedules.first {
            shared.setCurrentSchedule(to: schedule)
            return schedule
        }
        else {
            scheduleStore.addSchedule()
            let newSchedule = scheduleStore.schedules.first!
            shared.setCurrentSchedule(to: newSchedule)
            return newSchedule
        }
    }
}

//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        ContentView()
//    }
//}
