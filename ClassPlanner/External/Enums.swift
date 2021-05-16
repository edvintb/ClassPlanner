//
//  Enums.swift
//  ClassPlanner
//
//  Created by Edvin Berhan on 2021-05-15.
//

import Foundation

enum PanelOption: Equatable {

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
    
    case courses
    case concentrations
    case editor(selection: EditOption)
    case schedules
    case otherPeople
}

enum EditOption: Equatable {
    
    case course(course: Course)
    case category(category: Category)
    case concentration(concentration: Concentration)
    case none
}
