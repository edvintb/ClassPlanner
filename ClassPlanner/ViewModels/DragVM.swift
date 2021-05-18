////
////  DragViewModel.swift
////  ClassPlanner
////
////  Created by Edvin Berhan on 2021-05-16.
////
//
//import Foundation
//import SwiftUI
//
//extension CourseVM {
//    
//    // MARK: - Starting Drag
//    func setDragCourse(to course: Course) {
//        print("Setting dragcourse to \(course.name)")
//        self.dragCourse = course
//        self.dragSemester = course.semester
//        self.dragPosition = course.position
//        self.startSemester = course.semester
//        self.startPosition = course.position
//    }
//    
//    func setDragConcentration(to concentration: Concentration) {
//        dragConcentration = concentration
//        startIndex = concentration.index
//        dragIndex = concentration.index
//    }
//    
//    func setDragCategory(to category: Category) {
//        dragCategory = category
//        startIndex = category.index
//        dragIndex = category.index
//    }
//    
//    func drag() { if insideConcentration || draggedPanelToSchedule { objectWillChange.send() } }
//    
//    
//    // MARK: - Ending Drag
//    func courseDragEnded() {
//        if let course = dragCourse, let pos = dragPosition, let semester = dragSemester {
//            if dragSemester == startSemester { course.moveInSemester(to: pos) }
//            else { course.moveToSemester(semester, and: pos) }
//        }
//        insideConcentration = false
//        draggedPanelToSchedule = false
//        dragCourse = nil
//    }
//    
//    func categoryDragEnded() {
//        if let category = dragCategory, let index = dragIndex { category.move(to: index) }
//        dragCategory = nil
//    }
//    
//    func concentrationDragEnded() {
//        if let concentration = dragConcentration, let index = dragIndex{ concentration.move(to: index) }
//        dragConcentration = nil
//    }
//
//    // MARK: - Hovering
//    
//    func setToStart() -> Bool {
//        dragSemester = startSemester
//        dragPosition = startPosition
//        return false
//    }
//    
//    func hoverOverCourse(course: Course, _ entered: Bool) -> Bool {
//        if insideConcentration { return setToStart() }
//        if dragCourse != nil && dragCourse != course {
//            if entered {
//                // print("Dragging over course \(course.position)")
//                dragSemester = course.semester
//                dragPosition = course.position
//                return true
//            }
//            else { return setToStart() }
//        }
//        else { return false }
//    }
//    
//    func hoverOverEmptyCourse(entered: Bool, inCourse: Bool, semester: Int) -> Bool {
//        if insideConcentration { return setToStart() }
//        if let course = dragCourse {
//            if entered, let context = course.managedObjectContext {
//                dragSemester = semester
//                let request = Course.fetchRequest(NSPredicate(format: "semester_ = %@", argumentArray: [semester]))
//                let numberOfCourses = (try? context.count(for: request)) ?? 0
//                dragPosition = numberOfCourses + (semester == course.semester ? -1 : 0)
//                return true
//            }
//            else { return setToStart() }
//        }
//        if entered && inCourse { return true }
//        else { return false }
//    }
//    
//
//    func hoverOverConcentration(_ concentration: Concentration, entered: Bool) -> Bool {
//        if dragConcentration != nil && dragConcentration != concentration {
//            if entered {
//                print("Dragging over concentration \(concentration.index)")
//                dragIndex = concentration.index
//                return true
//            }
//            else {
//                 print("Setting back to start position")
//                dragIndex = startIndex
//                return false
//            }
//        }
//        else { return false }
//    }
//
//    
//    func hoverOverCategory(_ category: Category, entered: Bool) -> Bool {
//        if let course = dragCourse {
//            if entered { (added, _) = category.courses.insert(course) }
//            if added && !entered { category.removeCourse(course); added = false }
//            return entered
//        }
//        if dragCategory != nil && dragCategory != category {
//            if entered {
//                print("Dragging over category \(category.index)")
//                dragIndex = category.index
//            }
//            else {
//                print("Setting back to start position")
//                dragIndex = startIndex
//            }
//            return entered
//        }
//        return false
//    }
//   
//}
