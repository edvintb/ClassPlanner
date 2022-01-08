//
//  Enums.swift
//  ClassPlanner
//
//  Created by Edvin Berhan on 2021-05-15.
//

import Foundation
import SwiftUI

enum Day: Equatable, Hashable {
    case monday
    case tuesday
    case wednesday
    case thursday
    case friday
}

enum PanelOption: Equatable, Hashable, CaseIterable {
    
    case schedules
    case courses
    case concentrations
    case editor
    
    var string: String {
        switch self {
            case .schedules: return "Schedules"
            case .courses: return "Courses"
            case .concentrations: return "Majors"
            case .editor: return "Editor"
        }
    }
}

enum EditOption: Equatable, Hashable {
    
    case course(course: Course)
    case category(category: Category)
    case concentration(concentration: Concentration)
    case schedule(schedule: ScheduleVM)
    case none
}


enum SortOrder: CaseIterable {
    
    case ascending
    case descending
    
    var description: String {
        switch self {
            case .ascending: return "▼"
            case .descending: return "▲"
        }
    }
}

enum SortOption: CaseIterable {
    
    case alphabetic
    case score
    case workload
    case enrollment
    
    var description: String {
        switch self {
            case .alphabetic: return "A-Z"
            case .score: return qscoreSymbol
            case .workload: return workloadSymbol
            case .enrollment: return enrollmentSymbol
        }
    }
}


enum Grade: Int, Equatable, CaseIterable, Identifiable {
    
    var id: Int { self.rawValue }
    
    case A
    case AMinus
    case BPlus
    case B
    case BMinus
    case CPlus
    case C
    case CMinus
    case Pass
    case Fail
    
    var string: String {
        switch self {
            case .A: return "A"
            case .AMinus: return "A-"
            case .BPlus: return "B+"
            case .B: return "B"
            case .BMinus: return "B-"
            case .CPlus: return "C+"
            case .C : return "C"
            case .CMinus: return "C-"
            case .Pass: return "SAT"
            case .Fail: return "F"
        }
    }
    
    var value: Double {
        switch self {
            case .A: return 4
            case .AMinus: return 3.67
            case .BPlus: return 3.33
            case .B: return 3.00
            case .BMinus: return 2.67
            case .CPlus: return 2.33
            case .C: return 2
            case .CMinus: return 1.67
            case .Pass: return 0
            case .Fail: return 0
        }
    }

    var color: Color {
        switch self {
            case .A: return .green
            case .AMinus: return .green
            case .BPlus: return .orange
            case .B: return .orange
            case .BMinus: return .orange
            case .CPlus: return .red
            case .C: return .red
            case .CMinus: return .red
            case .Pass: return .white
            case .Fail: return .red
        }
    }
}
