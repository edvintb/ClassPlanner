//
//  SharedVM.swift
//  ClassPlanner
//
//  Created by Edvin Berhan on 2021-06-03.
//

import Foundation

class SharedVM: ObservableObject {
    
    // Does this need to be optional?
    // Yes, the schedule could get deleted.
    // Do we have a default if that happens?
    // What happens in the contentView method? Create new one I think
    @Published private (set) var currentSchedule: ScheduleVM?

    func setCurrentSchedule(to schedule: ScheduleVM) {
        self.currentSchedule = schedule
    }
    
    func replaceCourseInCurrent(old: Course, new: Course) {
        if let schedule = currentSchedule {
            schedule.replaceCourse(old: old, with: new)
        }
    }
    
    
    
    
    @Published private (set) var currentEditSelection: EditOption = .none
    @Published private (set) var currentPanelSelection: PanelOption = .schedules
    
    func setPanelSelection(to newSelection: PanelOption) {
        self.currentPanelSelection = newSelection
    }
    
    func setEditSelection(to newSelection: EditOption) {
        self.currentEditSelection = newSelection
        currentPanelSelection = .editor
    }
    
    func stopEdit() { currentEditSelection = .none }
}
