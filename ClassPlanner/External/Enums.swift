//
//  Enums.swift
//  ClassPlanner
//
//  Created by Edvin Berhan on 2021-05-15.
//

import Foundation

enum PanelOption: Equatable, Hashable, CaseIterable {
    
    static func == (lhs: PanelOption, rhs: PanelOption) -> Bool {
        switch (lhs, rhs) {
        case (.courses, .courses):
            return true
        case (.concentrations, .concentrations):
            return true
        case (.editor, .editor):
            return true
        case(.schedules, schedules):
            return true
        case (.otherPeople, .otherPeople):
            return true
        default:
            return false
        }
    }
    
    case editor
    case courses
    case concentrations
    case schedules
    case otherPeople
    
    // Used to iterate in creating the PanelView
    static var symbols: [PanelOption:String] {
        [editor: "Editor",
         courses : "Courses",
         concentrations : "Concentrations",
         schedules : "Schedules",
         otherPeople : "Other People"]
    }
}

enum EditOption: Equatable, Hashable {
    
    case course(course: Course)
    case category(category: Category)
    case concentration(concentration: Concentration)
    case schedule(schedule: ScheduleVM)
    case none
}
