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
    
    var id: UUID
    @Published var name: String
    @Published private var model: ScheduleModel
    @Published var isCourseFrontUp: Bool = true
    
    private let context: NSManagedObjectContext
    
    var url: URL? { didSet { save() }}
    
    private var cancellables = Set<AnyCancellable>()
    
    init(url: URL, context: NSManagedObjectContext) {
        self.context = context
        self.name = url.lastPathComponent
        self.id = UUID()
        self.url = url
        self.model = ScheduleModel(decoder: JSONDecoder(), json: try? Data(contentsOf: url)) ?? ScheduleModel()
        
        // Autosave cancellable
        $model.sink { [unowned self] _ in
            self.save()
        }
        .store(in: &cancellables)
    }
    
    // MARK: - Access to Model
    
    var semesters: [Int] {
        Array(model.schedule.keys.sorted())
    }
    
    var color: Color {
        Color.colorSelection[model.color % Color.colorSelection.count]
    }
    
    var notes: String {
        get { model.notes }
        set { model.notes = newValue }
    }
    
    var courseUrlSet: Set<URL> {
        model.schedule.reduce(into: Set<URL>()) { acc, semester in
            let (_, courseList) = semester
            acc = acc.union(Set(courseList))
        }
    }
    
    var gradeAverage: Double {
        var coursesWithGrade = 0
        let totalGrade = courseUrlSet.reduce(into: 0.0) { acc, url in
                if let course = Course.fromURI(uri: url, context: context) as? Course {
                    if course.enumGrade == .Pass { return }
                    acc += Grade.gradeNumber[course.enumGrade] ?? 0
                    coursesWithGrade += 1
                }
            }
        let averageGrade = totalGrade / Double(max(coursesWithGrade, 1))
        return averageGrade
    }
    
    func getPosition(course: Course) -> CoursePosition? {
        model.getPositionInSchedule(for: course)
    }
    
    func courses(for semester: Int) -> [Course] {
        model.schedule[semester, default: []].compactMap{ uri in
            return Course.fromCourseURI(uri: uri, context: context)
        }
    }
    
    func containsPrereqs(for course: Course) -> Text {
        if course.prereqs.isEmpty { return Text("-") }
        if let coursePos = model.getPositionInSchedule(for: course) {
            let prereqPosSet = course.prereqs.compactMap { model.getPositionInSchedule(for: $0) }
            for prereqPos in prereqPosSet {
                if prereqPos.isAfter(coursePos) { return Text("X").foregroundColor(.red) }
            }
            return Text(courseContainedSymbol).foregroundColor(.green)
        }
        return Text("-")
    }
    
    
    // MARK: - Intents

    func moveCourse(_ course: Course, to newPos: CoursePosition) {
        model.moveCourse(course, to: newPos)
    }

    func removeCourse(_ course: Course) {
        model.removeCourse(course)
    }
    
    func replaceCourse(old: Course, with newCourse: Course) {
        model.replaceCourse(oldCourse: old, with: newCourse)
        save()
    }
    
    func addCourse(_ course: Course, at newPos: CoursePosition) {
        model.moveCourse(course, to: newPos)
        save()
    }
    
    func setColor(to index: Int) {
        model.color = index
    }
    
    func addEmptyCourse(to semester: Int, context: NSManagedObjectContext) {
        let index = model.schedule[semester]?.count ?? 0
        let course = Course.create(context: context)
        let newPos = CoursePosition(semester: semester, index: index)
        do {
            try context.save()
            model.moveCourse(course, to: newPos)
            save()
            
        } catch {
            print("Error saving new course: \(error.localizedDescription)")
        }
    }
    
    func addSemester() {
        model.addSemester()
    }
    
    func turnCourseViews() {
        self.isCourseFrontUp.toggle()
    }
    
    //        print("is temporary: \(course.objectID.isTemporaryID)")
    //        print("is temporary: \(course.objectID.isTemporaryID)")
    //        print(getPosition(course: course))
    //        print(courses(for: semester))
    //        objectWillChange.send() // Do I need this?
    //        save(model)

    
    // MARK: - Supporting functionality

    private func save() {
        if url != nil {
            try? self.model.json?.write(to: url!)
        }
    }
    
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
  
    
    //MARK: - Needed if we want to decode entire courses
//    decoder.userInfo[CodingUserInfoKey.managedObjectContext] = context
    
    
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
