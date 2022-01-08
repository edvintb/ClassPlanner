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
    @ObservedObject var courseStoreVM: CourseStoreVM
    @ObservedObject var concentrationVM: ConcentrationVM
    @ObservedObject var courseSuggestionVM: CourseSuggestionVM
    @ObservedObject var categorySuggestionVM: CategorySuggestionVM
    @ObservedObject var prereqSuggestionVM: PrereqSuggestionVM
    
    
    
    // For onboarding
    @State private var isShowingOnboarding: Bool = false
    private func setContentOnboarding(show: Bool) {
        self.isShowingOnboarding = show
        if show {
            shared.showOnboarding()
        }
    }
    
    @State private var isShowingWelcomeNotice: Bool = !UserDefaults.standard.bool(forKey: welcomeOnboardingKey)
    private func setWelcomeOnboarding(show: Bool, showOtherOnboarding: Bool) {
        self.isShowingWelcomeNotice = show
        UserDefaults.standard.setValue(true, forKey: welcomeOnboardingKey)
        setContentOnboarding(show: showOtherOnboarding)
    }
    
    var body: some View {
        HSplitView {
            PanelView(scheduleStore: scheduleStore,
                      courseStoreVM: courseStoreVM,
                      courseSuggestionVM: courseSuggestionVM,
                      categorySuggestionVM: categorySuggestionVM,
                      concentrationVM: concentrationVM,
                      prereqSuggestionVM: prereqSuggestionVM,
                      schedule: schedule)
                .frame(minWidth: editorWidth*1.1, maxWidth: 500, alignment: .top)
                VSplitView {
                    ScheduleView(store: scheduleStore, schedule: schedule)
                        .frame(minHeight: scheduleMinHeight, idealHeight: 400)
                        .popover(isPresented: $isShowingOnboarding, attachmentAnchor: .point(.top), arrowEdge: .top){
                            ScheduleOnboardingView(
                                setScheduleOnboarding: setContentOnboarding
                            )
                        }
                    ConcentrationContainerView(schedule: schedule, concentrationVM: concentrationVM)
                        .frame(minHeight: concentrationsMinHeight, idealHeight: 150)
                        .popover(isPresented: $isShowingOnboarding) {
                            ConcentrationOnboardingView()
                        }
                }
            }
            .sheet(isPresented: $isShowingWelcomeNotice) {
                WelcomeOnboarding(setWelcomeOnboarding: setWelcomeOnboarding)
            }
            .onReceive(shared.$isShowingWelcomeSheet.dropFirst()) { show in
                setWelcomeOnboarding(show: show, showOtherOnboarding: false)
            }

    }
    
    private var schedule: ScheduleVM {
        if let schedule = shared.currentSchedule {
            return schedule
        }
        else if let schedule = scheduleStore.schedules.first(where: { schedule in schedule.name == UserDefaults.standard.string(forKey: currentScheduleKey)} ) {
            shared.setCurrentSchedule(to: schedule)
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
