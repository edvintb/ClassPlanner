//
//  ClassPlanner.swift
//  ClassPlanner
//
//  Created by Edvin Berhan on 2021-03-22.
//

import Foundation

struct ScheduleModel: Codable, Hashable, Equatable {
    
    private (set) var semesters: Array<Int> = [1 ,2, 3, 4, 5, 6, 7, 8]
    
    private (set) var schedule: [Int:[Course]]
    
    var json: Data? {
        return try? JSONEncoder().encode(self)
    }
    
    init() {
        self.schedule = [:]
        semesters.forEach { semester in
            schedule[semester] = []
        }
    }
    
    init? (decoder: JSONDecoder, json: Data?) {
        if json != nil, let newSchedule = try? decoder.decode(ScheduleModel.self, from: json!) {
            self = newSchedule
        }
        else {
            return nil
        }
    }
    
    
}
