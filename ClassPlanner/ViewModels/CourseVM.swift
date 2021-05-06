//
//  ClassPlannerViewModel.swift
//  ClassPlanner
//
//  Created by Edvin Berhan on 2021-03-22.
//

import SwiftUI
import Foundation
import CoreData
import Combine

class CourseVM: ObservableObject {
    
    @Published var model = ClassPlannerModel()
    
    // MARK: - Access to Model
    
    var semesters: [Int] {
        model.semesters
    }
    
    
    // MARK: - Deleting
    func deleteCourse(_ courseToDelete: Course) {
        if let context = courseToDelete.managedObjectContext {
            context.delete(courseToDelete)
            let request = Course.fetchRequest(NSPredicate(format: "semester_ = %@", argumentArray: [courseToDelete.semester]))
            let courses = (try? context.fetch(request)) ?? []
            for index in 0..<courses.count {
                courses[index].position = index
            }
            try? context.save()
        }
    }
    

    func deleteCategory(category: Category) {
        if let context = category.managedObjectContext, let concentration = category.concentration {
            context.delete(category)
            let request = Category.fetchRequest(NSPredicate(format: "concentration = %@", argumentArray: [concentration]))
            let otherCategories = (try? context.fetch(request)) ?? []
            for index in 0..<otherCategories.count {
                otherCategories[index].index = index
            }
            try? context.save()
        }
    }
    
    func deleteConcentration(concentration: Concentration) {
        if let context = concentration.managedObjectContext{
            context.delete(concentration)
            let request = Concentration.fetchRequest(.all)
            let otherConcentration = (try? context.fetch(request)) ?? []
            for index in 0..<otherConcentration.count {
                otherConcentration[index].index = index
            }
            try? context.save()
        }
    }
    
    // MARK: - Adding
    
    func addEmptyCourse(to semester: Int, context: NSManagedObjectContext) {
        print("VM: Creating empty course")
        let request = Course.fetchRequest(NSPredicate(format: "semester_ = %@", argumentArray: [semester]))
        let existingCourses = (try? context.count(for: request)) ?? 0
        Course.createEmpty(in: semester, at: existingCourses, in: context)
    }

    func addEmptyConcentration(in context: NSManagedObjectContext) {
        print("VM: Creating empty concentration")
        let request = Concentration.fetchRequest(.all)
        let existingConcentrations = (try? context.count(for: request)) ?? 0
        Concentration.createEmpty(at: existingConcentrations, in: context)
    }
    
    
    func addEmptyCategory(to concentration: Concentration, in context: NSManagedObjectContext) {
        print("VM: Creating empty category")
        let request = Category.fetchRequest(NSPredicate(format: "concentration == %@", argumentArray: [concentration]))
        let existingCategories = (try? context.count(for: request)) ?? 0
        Category.createEmpty(concentration: concentration, index: existingCategories, in: context)
    }
    
    
    // MARK: - Dragging
    @Published private (set) var dragCourse: Course?
    private (set) var dragConcentration: Concentration?
    private (set) var dragCategory: Category?
    
    private var startSemester: Int?
    private var startPosition: Int?
    
    private var dragSemester: Int?
    private var dragPosition: Int?
    
    private var startIndex: Int?
    private var dragIndex: Int?
    
    var insideConcentration: Bool = false
    
    // MARK: - Starting Drag
    func setDragCourse(to course: Course) {
        print("Setting dragcourse to \(course.name)")
        self.dragCourse = course
        self.dragSemester = course.semester
        self.dragPosition = course.position
        self.startSemester = course.semester
        self.startPosition = course.position
    }
    
    func setDragConcentration(to concentration: Concentration) {
        dragConcentration = concentration
        startIndex = concentration.index
        dragIndex = concentration.index
    }
    
    func setDragCategory(to category: Category) {
        dragCategory = category
        startIndex = category.index
        dragIndex = category.index
    }
    
    func drag() { if insideConcentration { objectWillChange.send() } }
    
    
    // MARK: - Ending Drag
    func courseDragEnded() {
        if let course = dragCourse, let pos = dragPosition, let semester = dragSemester {
            if dragSemester == startSemester { course.moveInSemester(to: pos) }
            else { course.moveToSemester(semester, and: pos) }
        }
        dragCourse = nil
    }
    
    func categoryDragEnded() {
        if let category = dragCategory, let index = dragIndex { category.move(to: index) }
        dragCategory = nil
    }
    
    func concentrationDragEnded() {
        if let concentration = dragConcentration, let index = dragIndex{ concentration.move(to: index) }
        dragConcentration = nil
    }
    

    // MARK: - Hovering
    
    func setToStart() -> Bool {
        dragSemester = startSemester
        dragPosition = startPosition
        return false
    }
    
    func hoverOverCourse(course: Course, _ entered: Bool) -> Bool {
        if insideConcentration { return setToStart() }
        if dragCourse != nil && dragCourse != course {
            if entered {
                // print("Dragging over course \(course.position)")
                dragSemester = course.semester
                dragPosition = course.position
                return true
            }
            else { return setToStart() }
        }
        else { return false }
    }
    
    func hoverOverEmptyCourse(entered: Bool, inCourse: Bool, semester: Int) -> Bool {
        if insideConcentration { return setToStart() }
        if let course = dragCourse {
            if entered, let context = course.managedObjectContext {
                dragSemester = semester
                let request = Course.fetchRequest(NSPredicate(format: "semester_ = %@", argumentArray: [semester]))
                let numberOfCourses = (try? context.count(for: request)) ?? 0
                dragPosition = numberOfCourses + (semester == course.semester ? -1 : 0)
                return true
            }
            else { return setToStart() }
        }
        if entered && inCourse { return true }
        else { return false }
    }
    

    func hoverOverConcentration(_ concentration: Concentration, entered: Bool) -> Bool {
        if dragConcentration != nil && dragConcentration != concentration {
            if entered {
                print("Dragging over concentration \(concentration.index)")
                dragIndex = concentration.index
                return true
            }
            else {
                 print("Setting back to start position")
                dragIndex = startIndex
                return false
            }
        }
        else { return false }
    }
    
    func hoverOverCategory(_ category: Category, entered: Bool) -> Bool {
        if dragCategory != nil && dragCategory != category {
            if entered {
                print("Dragging over category \(category.index)")
                dragIndex = category.index
                return true
            }
            else {
                print("Setting back to start position")
                dragIndex = startIndex
                return false
            }
        }
        else if dragCourse != nil {
            return entered
        }
        else { return false }
    }
    
    //    func deleteAll(from context: NSManagedObjectContext) {
    //        let request = Course.fetchRequest(.all)
    //        let courses = (try? context.fetch(request)) ?? []
    //        for course in courses {
    //            context.delete(course)
    //        }
    //        try? context.save()
    //        print("Courses deleted")
    //    }
    //    func removeCourseFrom(_ semester: Int, at position: Int, in context: NSManagedObjectContext) {
    //        let request = Course.fetchRequest(NSPredicate(format: "semester_ = %@ and position_ = %@", argumentArray: [semester, position]))
    //        let courses = (try? context.fetch(request)) ?? []
    //        if let course = courses.first {
    //            context.delete(course)
    //        }
    //    }
    
    // MARK: - Adding Courses
    
//    @Published var addingCourse: [Bool] = [Bool](repeating: false, count: 10)
//    
//    var isAdding: Bool { addingCourse.contains(true) }
//    
    
//    func deleteCourseIn(_ semester: Int, at position: Int) {
//        if let context = 
//    }
    
    
//    func setFrame(to rect: CGRect, for semester: Int, at position: Int32) {
//        let pos = Int(position)
//        self.courseFrames[semester][pos] = rect
//    }
//
//    func removeFrame(at index: Int) {
//        self.courseFrames.remove(at: index)
//    }
//
//    func removeSemesterFrames(for semester: Int) {
//        self.courseFrames[semester].removeAll()
//    }
    
}


// func courseEntered() {
//        if let course = dragCourse, let pos = dragPosition, let sem = dragSemester {
////            if course.semester == sem {
////                course.moveInSemester(to: pos)
////                print("Moved in same semester")
////                return
////                // print(repositionOffset)
////            }
////            if let dummy = dummyCourse {
////                if dummy.semester == sem {
////                    print("Dummy moved IN semester")
////                    dummy.moveInSemester(to: pos)
////                }
////                else {
////                    print("Dummy moved TO semester")
////                    dummy.moveToSemester(sem, and: pos)
////                }
////                return
////                // print("Dragging in different semester")
////                // course.moveToSemester(dragSemester ?? course.semester, and: dragPosition ?? course.position)
////            }
////            else {
////                dummyCourse = course.createDummy()
////                dummyCourse?.moveToSemester(sem, and: pos)
////            }
//        }
//        else {
//            print("Course Entered without dragCourse")
//        }
//    }


//    @Published var isDragging: Bool = false

// var coursePublisher: ManagedObjectChangesPublisher<Course>

//    init(request: NSFetchRequest<Course>, in context: NSManagedObjectContext) {
//        self.coursePublisher = ManagedObjectChangesPublisher(fetchRequest: request, context: context)
//    }

//    init() {
//        self.courseFrames = Dictionary(minimumCapacity: 10)
//        for semester in 0..<10 {
//            courseFrames.updateValue([CGRect](repeating: .zero, count: 10), forKey: semester)
//        }
//    }
//
//    // TODO: - Limit number of courses per semester to 10, and take care of adding semesters
//    var courseFrames: [Int:[CGRect]]
//    var semesterFrames: [CGRect] = [CGRect](repeating: .zero, count: 10)
