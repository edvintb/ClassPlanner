//
//  ClassPlanner.swift
//  ClassPlanner
//
//  Created by Edvin Berhan on 2021-03-22.
//

import Foundation
import CoreData

struct CoursePosition: Codable, Hashable, Equatable {
    var semester: Int
    var index: Int
}

struct ScheduleModel: Codable, Hashable, Equatable {
    
    var color: Int
    var notes: String
    
    private (set) var schedule = [Int:[URL]]()
    
    var json: Data? {
        return try? JSONEncoder().encode(self)
    }
    
    func getPositionInSchedule(id: URL) -> CoursePosition? {
        if let (semester, courses) = schedule.first(where: { $1.contains(id) }) {
            let index = courses.firstIndex(of: id)!
            return CoursePosition(semester: semester, index: index)
        }
        return nil
    }
    
    mutating func moveCourse(_ course: Course, to newPos: CoursePosition) {
        let id = course.urlID
        // If we can get the position we have to remove it from there
        if let oldPos = getPositionInSchedule(id: id) {
            remove(at: oldPos)
            insert(id: id, at: newPos)
        }
        // Otherwise we only insert it
        else { insert(id: id, at: newPos) }
    }
    
    mutating func replaceCourse(old: Course, with new: Course) {
        if let pos = getPositionInSchedule(id: old.urlID) {
            schedule[pos.semester]![pos.index] = old.urlID
            if old.isEmpty { old.delete() }
        }
    }
    
    mutating func deleteCourse(_ course: Course) {
        if let pos = getPositionInSchedule(id: course.urlID) {
            remove(at: pos)
        }
    }
    
    private mutating func insert(id: URL, at pos: CoursePosition) {
        schedule[pos.semester, default: []].insert(id, at: pos.index)
    }
    
    private mutating func remove(at pos: CoursePosition) {
        schedule[pos.semester, default: []].remove(at: pos.index)
    }
    
    
    
    // MARK: - Initializing
    
    init() {
        self.color = 0
        self.notes = ""
        [0, 1 ,2, 3, 4, 5, 6, 7].forEach { semester in
            schedule[semester] = []
            schedule[semester]?.reserveCapacity(6)
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





//
//            { semester in
//                if let index = schedule[semester]?.firstIndex(of: id) {
//                    if schedule[newSemester] != nil {
//                        schedule[semester]!.remove(at: index)
//                        schedule[newSemester]!.insert(id, at: newIndex)
//                    }
//                    else {
//                        schedule[newSemester] = [id]
//                    }
//                    print("Moved Course")
//                    return
//
//                }
//                print("Did not move Course")
//            }
//
//    mutating func moveCourse(_ course: Course, newSemester: Int, newIndex: Int) {
//        print("Index: \(newIndex)")
//        print("Semester: \(newSemester)")
//        let id = course.objectID.uriRepresentation()
//        print("Position: \(String(describing: coursePositions[id]))")
//        if let pos = coursePositions[id] {
//            if schedule[newSemester] != nil {
//                schedule[pos.semester]!.remove(at: pos.index)
//                schedule[newSemester]!.insert(id, at: newIndex)
//                // We need to update all the courses in the semester, the way we did before
//                // otherwise we will get these crashes bc of index errors
//                // Or we could try to create a single source of truth
//                // Maybe something other than the things we have
//                coursePositions[id] = Position(semester: newSemester, index: newIndex)
//            }
//            else {
//                schedule[newSemester] = [id]
//                coursePositions[id] = Position(semester: newSemester, index: 0)
//            }
//        }
//    }

//    mutating func addCourse(_ course: Course, semester: Int, index: Int) {
//        let id = course.objectID.uriRepresentation()
//        schedule[semester] == nil ? schedule[semester] = [id] : schedule[semester]!.insert(id, at: index)
//        courseNames.insert(id)
//        coursePositions[id] = Position(semester: semester, index: index)
//    }



