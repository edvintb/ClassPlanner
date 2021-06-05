//
//  Enums.swift
//  ClassPlanner
//
//  Created by Edvin Berhan on 2021-05-15.
//

import Foundation

enum PanelOption: Equatable, Hashable, CaseIterable {
    
    case schedules
    case concentrations
    case courses
    case editor
    case otherPeople
    
    static var symbols: [PanelOption:String] {
        [.editor : "􀈎",
         .courses : "􀧵",
         .concentrations : "􀈥",
         .schedules : "􀈕",
         .otherPeople : "􀝊"]
    }
}

enum EditOption: Equatable, Hashable {
    
    case course(course: Course)
    case category(category: Category)
    case concentration(concentration: Concentration)
    case schedule(schedule: ScheduleVM)
    case none
}
