//
//  Enums.swift
//  ClassPlanner
//
//  Created by Edvin Berhan on 2021-05-15.
//

import Foundation
import SwiftUI

enum PanelOption: Equatable, Hashable, CaseIterable {
    
    case schedules
    case concentrations
    case courses
    case editor
    
//    static var symbols: [PanelOption:String] {
//         [.schedules : "􀈕",
//          .concentrations : "􀈥",
//          .courses : "􀧵",
//          .editor : "􀈎"]
//    }
    
    static var symbols: [PanelOption:String] {
         [.schedules : "Schedules",
          .concentrations : "Majors",
          .courses : "Classes",
          .editor : "Editor"]
    }
}

enum EditOption: Equatable, Hashable {
    
    case course(course: Course)
    case category(category: Category)
    case concentration(concentration: Concentration)
    case schedule(schedule: ScheduleVM)
    case none
    
}


enum Grade: Int, Equatable, CaseIterable, Identifiable {
    
    var id: Int { self.rawValue }
    
//    case APlus
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
    
    static var gradeString: [Grade:String] {
        [
//            APlus: "A+",
            A: "A",
            AMinus: "A-",
            BPlus: "B+",
            B: "B",
            BMinus: "B-",
            CPlus: "C+",
            C :"C",
            CMinus: "C-",
            Pass: "SAT",
            Fail: "-"
        ]
    }
    
    static var gradeNumber: [Grade:Double] {
        [
//            APlus: 4,
            A: 4,
            AMinus: 3.67,
            BPlus: 3.33,
            B: 3.00,
            BMinus: 2.67,
            CPlus: 2.33,
            C: 2,
            CMinus: 1.67,
            Pass: 0,
            Fail: 0
        ]
    }
    
    static var color: [Grade:Color] {
        [
//            APlus: .green,
            A: .green,
            AMinus: .green,
            BPlus: .orange,
            B: .orange,
            BMinus: .orange,
            CPlus: .red,
            C: .red,
            CMinus: .red,
        ]
    }
}
