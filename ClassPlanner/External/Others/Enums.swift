//
//  Enums.swift
//  ClassPlanner
//
//  Created by Edvin Berhan on 2021-05-15.
//

import Foundation

enum PanelOption: Equatable, Hashable, CaseIterable {
    
    case editor
    case courses
    case concentrations
    case schedules
    case otherPeople
    
    static var symbols: [PanelOption:String] {
        [.editor : "Editor",
         .courses : "Courses",
         .concentrations : "Concentrations",
         .schedules : "Schedules",
         .otherPeople : "Other People"]
    }
}

enum EditOption: Equatable, Hashable {
    
    case course(course: Course)
    case category(category: Category)
    case concentration(concentration: Concentration)
    case schedule(schedule: ScheduleVM)
    case none
}
