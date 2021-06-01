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

class ScheduleVM: ObservableObject, Hashable, Equatable, Identifiable {
        
    @Published var name: String
    
    @Published private var model: ScheduleModel
    
    private let context: NSManagedObjectContext
    
    // MARK: - Access to Model
    
    var semesters: [Int] {
        Array(model.schedule.keys.sorted())
    }
    
    var color: Color {
        Color.colorSelection[model.color]
    }
    
    var notes: String {
        get { model.notes }
        set { model.notes = newValue }
    }
    
    var courseURLs: Set<URL> {
        model.schedule.reduce(into: Set<URL>()) { acc, schedule in
            let (_, courses) = schedule
            acc = acc.union(Set(courses))
        }
    }
    
    func getPosition(course: Course) -> CoursePosition? {
        let id = course.objectID.uriRepresentation()
        let pos = model.getPositionInSchedule(id: id) // ?? Position(semester: 0, index: 0)
        return pos
    }
    
    func courses(for semester: Int) -> [Course] {
        model.schedule[semester, default: []].map {
            Course.fromURI(uri: $0, context: context) ?? nil
        }
        .compactMap { $0 }
    }
    

    
    // MARK: - Intents

    func moveCourse(_ course: Course, to semester: Int, index: Int) {
        // Position earlier??
        let newPosition = CoursePosition(semester: semester, index: index)
        model.moveCourse(course, to: newPosition)
    }

    func deleteCourse(_ course: Course) {
        model.deleteCourse(course)
    }
    
    func replaceCourse(old: Course, with new: Course) {
        model.replaceCourse(old: old, with: new)
    }
    
    func addCourse(_ course: Course, semester: Int, index: Int) {
        // Make it into a position??
        try? context.save() // Why is this here??
        model.addCourse(course, semester: semester, index: index)
        
    }
    
    func addEmptyCourse(to semester: Int, context: NSManagedObjectContext) {
        let index = model.schedule[semester]?.count ?? 0
        let course = Course(context: context)
        print("is temporary: \(course.objectID.isTemporaryID)")
        try? context.save()
        print("is temporary: \(course.objectID.isTemporaryID)")
        model.addCourse(course, semester: semester, index: index)
//        print(getPosition(course: course))
//        print(courses(for: semester))
//        objectWillChange.send() // Do I need this?
//        save(model)
    }
    
    func setColor(to index: Int) {
        model.color = index
    }
    

    

    
    
    // MARK: - Init
    
    private var cancellables = Set<AnyCancellable>()

    var url: URL? { didSet { save() }}
    
    init(context: NSManagedObjectContext, url: URL, panel: PanelVM) {
        self.name = url.lastPathComponent
        self.context = context
        self.panel = panel
        self.id = UUID()
        self.url = url
        let decoder = JSONDecoder()
        decoder.userInfo[CodingUserInfoKey.managedObjectContext] = context
        self.model = ScheduleModel(decoder: decoder, json: try? Data(contentsOf: url)) ?? ScheduleModel()
        
        $model.sink { scheduleModel in
            self.save()
        }
        .store(in: &cancellables)
    }
    
    private func save() {
        if url != nil {
            try? self.model.json?.write(to: url!)
            print("Saved")
        }
    }
    
    // MARK: - Editing
    
    // Should this be related to the Course View somehow?
    // Only used there to open editor
    private var panel: PanelVM
    
    func setEditCourse(_ course: Course) {
        panel.setEditSelection(to: .course(course: course))
    }
    
    var id: UUID
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: ScheduleVM, rhs: ScheduleVM) -> Bool {
        lhs.id == rhs.id
    }

    // MARK: - Deleting
//
//    func deleteCourse(_ course: Course) { course.delete() }
//
//    func deleteCategory(_ category: Category) { category.delete() }
//
//    func deleteConcentration(_ concentration: Concentration) { concentration.delete() }
    
    
    
    
    
//    func addEmptyCourse(to semester: Int, context: NSManagedObjectContext) {
//        print("VM: Creating empty course")
//        let request = Course.fetchRequest(NSPredicate(format: "semester_ = %@", argumentArray: [semester]))
//        let existingCourses = (try? context.count(for: request)) ?? 0
//        print(existingCourses)
//        Course.createEmpty(in: semester, at: existingCourses, in: context)
//    }
    
//    func courses(for semester: Int) -> [Course?] {
//        model.schedule[semester]?.map { id in
//            if let objectID = context.persistentStoreCoordinator?.managedObjectID(forURIRepresentation: id) {
//                let course = context.registeredObject(for: objectID)
//                return course as? Course
//            }
//            return nil
//        } ?? []
//    }
    
//
//    var numberFormatter: NumberFormatter {
//        let numberFormatter = NumberFormatter()
//        numberFormatter.maximumIntegerDigits = maxIntegers
//        numberFormatter.maximumFractionDigits = maxDecimals
//        numberFormatter.maximumSignificantDigits = maxSignificant
//        numberFormatter.roundingMode = .down
//        numberFormatter.zeroSymbol = ""
//        numberFormatter.localizesFormat = true
//        return numberFormatter
//    }
    
    
    
    //    var schedule: [Int:[Course]] {
    //        model.schedule.mapValues {
    //            Course.fromURIs(uri: $0, context: context)
    //        }
    //    }
        
    //    func courses(for semester: Int) -> [Course?] {
    //        model.coursePositions.reduce(into: []) { (result, dict) -> () in
    //            let (url, pos) = dict
    //            if pos.semester == semester {
    //                result.append(Course.fromURI(uri: url, context: context))
    //            }
    //        }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    // MARK: - Dragging
//
//    @Published private (set) var dragCourse: Course?
//
//    private var startSemester: Int?
//    private var startPosition: Int?
//
//    private var dragSemester: Int?
//    private var dragPosition: Int?
//
//    @Published var insideConcentration: Bool = false
//    @Published var draggedPanelToSchedule: Bool = false
//
//    var window: NSWindow?
//    var mouseLocation: (() -> NSPoint)?
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
//    func drag() { if insideConcentration || draggedPanelToSchedule { objectWillChange.send() } }
    
    
    // MARK: - Ending Drag
//    func courseDragEnded() {
//        if let course = dragCourse, let pos = dragPosition, let semester = dragSemester {
//            if dragSemester == startSemester { course.moveInSemester(to: pos) }
//            else { course.moveToSemester(semester, and: pos) }
//        }
//        insideConcentration = false
//        draggedPanelToSchedule = false
//        dragCourse = nil
//    }
    


    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    // MARK: - Hovering
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
//
//
//    func hoverOverEmptyCourse(entered: Bool, inCourse: Bool, semester: Int) -> Bool {
//        if insideConcentration { return setToStart() }
//        if let course = dragCourse {
//            if entered, let context = course.managedObjectContext {
//                dragSemester = semester
//                let pos = courseCountInSemester(semester, context: context)
//                dragPosition = pos + (semester == course.semester ? -1 : 0)
//                return true
//            }
//            else { return setToStart() }
//        }
//        if entered && inCourse { return true }
//        else { return false }
//    }
    

    
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
    
    
    // MARK: - Handling Popovers
//
//    private (set) var hasCoursePopover: Bool = false
//
//    func toggleCoursePopover() { hasCoursePopover.toggle() }
//

    
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
