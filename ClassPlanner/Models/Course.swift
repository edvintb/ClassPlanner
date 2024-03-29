//
//  Class.swift
//  ClassPlanner
//
//  Created by Edvin Berhan on 2021-03-20.
//

import CoreData
import Combine
import AppKit
import SwiftUI


public class Course: NSManagedObject {

    
}


extension Course {
    
    // MARK: - Static functions
    
    static func fetchFromId(context: NSManagedObjectContext, course_id: String) -> Course? {
        let predicate: NSPredicate = NSPredicate(format: "course_id_ == %@", argumentArray: [course_id])
        let request = Course.fetchRequest(predicate)
        let courseArray = (try? context.fetch(request)) ?? []
        return courseArray.first
    }
    
    static func fetchFromName(name: String, context: NSManagedObjectContext) -> Course? {
        let predicate: NSPredicate = NSPredicate(format: "name_ = %@", argumentArray: [name])
        let request = Course.fetchRequest(predicate)
        let courseArray = (try? context.fetch(request)) ?? []
        return courseArray.first
    }
    
    static func create(context: NSManagedObjectContext) -> Course {
        let course = Course(context: context)
        course.grade = Grade.Pass.rawValue
        return course
    }
    
    static func existsWithId(context: NSManagedObjectContext, course_id: String) -> Bool {
        let predicate: NSPredicate = NSPredicate(format: "course_id_ == %@", argumentArray: [course_id])
        let request = Course.fetchRequest(predicate)
        let courseArray = (try? context.fetch(request)) ?? []
        return courseArray.first != nil
    }
    
    // Make this work with id instead -- create a course id
    static func fetchCreate(course_id: String, context: NSManagedObjectContext) -> Course {
        let predicate: NSPredicate = NSPredicate(format: "course_id_ == %@", argumentArray: [course_id])
        let request = Course.fetchRequest(predicate)
        let courseArray = (try? context.fetch(request)) ?? []
        if courseArray.isEmpty {
            let course = Course.create(context: context)
            course.course_id = course_id
            return course
        }
        else {
            return courseArray.first!
        }
    }
    
    static func fetchRequest(_ predicate: NSPredicate) -> NSFetchRequest<Course> {
        let request = NSFetchRequest<Course>(entityName: "Course")
        request.sortDescriptors = [NSSortDescriptor(key: "course_id_", ascending: true), NSSortDescriptor(key: "name_", ascending: true)]
        request.predicate = predicate
        return request
    }
    
    static func deleteFromSchool(context: NSManagedObjectContext, school: School) {
        let predicate = NSPredicate(format: "school_ = %@", argumentArray: [school.rawValue])
        let request = Course.fetchRequest(predicate)
        let courseArray = (try? context.fetch(request)) ?? []
        for course in courseArray {
            course.delete()
        }
    }
    
    static func fromURIs(uri: [URL], context: NSManagedObjectContext) -> [Course] {
        let IDs = uri.map { context.persistentStoreCoordinator?.managedObjectID(forURIRepresentation: $0) }
        let predicate = NSPredicate(format: "SELF IN %@", IDs)
        let request = Course.fetchRequest(predicate)
        let courses = (try? context.fetch(request)) ?? []
        print(courses.count)
        return courses
    }
    
    static func fromCourseURI(uri: URL, context: NSManagedObjectContext) -> Course? {
        let object = NSManagedObject.fromURI(uri: uri, context: context)
        return object as? Course
    }

    
    func delete() {
        if let context = self.managedObjectContext {
            context.delete(self)
            try? context.save()
        }
    }
    
    func insertPrereq(prereq: Course) {
        self.prereqs.insert(prereq)
        safeSave()
    }
    
    func removePrereq(prereq: Course) {
        self.prereqs.remove(prereq)
        safeSave()
    }
    
    func isPrereqSatisfied(prereq: Course, schedule: ScheduleVM?) -> Bool {
        if schedule == nil { return false }
        guard let selfPos = schedule!.getPosition(course: self) else { return false }
        guard let prereqPos = schedule!.getPosition(course: prereq) else { return false }
        return selfPos.isAfterOrSameSemester(prereqPos)
    }
    
    func toggleMonday() {
        self.monday.toggle()
        safeSave()
    }
    
    func toggleTuesday() {
        self.tuesday.toggle()
        safeSave()
    }
    
    func toggleWednesday() {
        self.wednesday.toggle()
        safeSave()
    }
    
    func toggleThursday() {
        self.thursday.toggle()
        safeSave()
    }
    
    func toggleFriday() {
        self.friday.toggle()
        safeSave()
    }
    
    func safeSave() {
        if let context = self.managedObjectContext {
            try? context.save()
            print("Saved")
        }
    }
    
    // MARK: - Property access
    
    var isEmpty: Bool {
        self.name.isEmpty && self.notes.isEmpty && self.workload == 0 && self.enrollment == 0 && self.qscore == 0 && self.fall == false && self.spring == false && self.grade == Grade.Pass.rawValue
    }
    
    var name: String {
        get { self.name_ ?? ""}
        set { self.name_ = newValue }
    }
    
    var course_id: String {
        get { self.course_id_ ?? "" }
        set { self.course_id_ = newValue }
    }
    
    var notes: String {
        get { self.notes_ ?? ""}
        set { self.notes_ = newValue }
    }
    
    var workload: Double {
        get { self.workload_ }
        set { self.workload_ = newValue }
    }
    
    var enrollment: Int {
        get { Int(self.enrollment_) }
        set { self.enrollment_ = Int16(newValue) }
    }
    
    var grade: Int {
        get { Int(self.grade_) }
        set { self.grade_ = Int16(newValue) }
    }
    
    var rating_year: Int {
        get { Int(self.rating_year_) }
        set { self.rating_year_ = Int16(newValue) }
    }
    
    var professorName: String {
        get { self.professorName_ ?? "" }
        set { self.professorName_ = newValue }
    }
    
    var time: Date {
        get { self.time_ ?? Date.init(timeIntervalSinceReferenceDate: 0)}
        set { self.time_ = newValue }
    }
    
    var timeInterval: DateInterval {
        if let stopTime = self.stopTime_ {
            if self.time < stopTime {
                return DateInterval(start: self.time, end: stopTime)
            }
        }
        return DateInterval(
            start: self.time,
            duration: 60 * UserDefaults.standard.double(forKey: courseLengthKey)
        )
    }
    
    var idName: String {
        self.course_id.isEmpty ? self.name : "\(self.course_id) - \(self.name)"
    }
    
    var idOrName: String {
        self.course_id.isEmpty ? self.name : self.course_id
    }
    
    var enumGrade: Grade {
        Grade.init(rawValue: grade) ?? Grade.Pass
    }
    
    var school: School {
        get { School.init(rawValue: Int(self.school_)) ?? .other }
        set { self.school_ = Int16(newValue.rawValue) }
    }
    
    var colorOption: ColorOption {
        get { ColorOption(rawValue: Int(self.color_)) ?? .primary }
        set { self.color_ = Int16(newValue.id) }
    }
    
    func getColor() -> Color {
        return self.colorOption.color
    }
    
    var prereqs: Set<Course> {
        get { (self.prereqs_ as? Set<Course>) ?? [] }
        set { self.prereqs_ = newValue as NSSet}
    }
    
    var nameSortedPrereqs: Array<Course> {
        self.prereqs.sorted(by: {$0.name < $1.name})
    }
    
    var concentrations: Set<Concentration> {
        get { (self.concentrations_ as? Set<Concentration> ?? [])}
        set { self.concentrations_ = newValue as NSSet}
    }
    
    var categories: Set<Category> {
        get { (self.categories_ as? Set<Category> ?? [])}
        set { self.categories_ = newValue as NSSet}
    }
    
    var nameSortedConcentrations: Array<Concentration> {
        self.concentrations.sorted(by: {$0.name < $1.name})
    }
    
}


// MARK: - Code to make Course Codable -- neded for sharing

//extension CodingUserInfoKey {
//  static let managedObjectContext = CodingUserInfoKey(rawValue: "managedObjectContext")!
//}
//
//enum DecoderConfigurationError: Error {
//  case missingManagedObjectContext
//}



//    enum CodingKeys: CodingKey {
//       case name, workload, enrollment, qscore, spring, fall, notes, color
//     }
//
//     required convenience public init(from decoder: Decoder) throws {
//
//        guard let context = decoder.userInfo[CodingUserInfoKey.managedObjectContext] as? NSManagedObjectContext else {
//          throw DecoderConfigurationError.missingManagedObjectContext
//        }
//
//        self.init(context: context)
//
//        let container = try decoder.container(keyedBy: CodingKeys.self)
//        self.name = try container.decode(String.self, forKey: .name)
//        self.workload = try container.decode(Double.self, forKey: .workload)
//        self.enrollment = try container.decode(Int.self, forKey: .enrollment)
//        self.qscore = try container.decode(Double.self, forKey: .qscore)
//        self.spring = try container.decode(Bool.self, forKey: .spring)
//        self.fall = try container.decode(Bool.self, forKey: .fall)
//        self.notes = try container.decode(String.self, forKey: .notes)
//        self.color = try container.decode(Int.self, forKey: .color)
//
//    }
//
//
//    public func encode(to encoder: Encoder) throws {
//        var container = encoder.container(keyedBy: CodingKeys.self)
//        try container.encode(name, forKey: .name)
//        try container.encode(workload, forKey: .workload)
//        try container.encode(enrollment, forKey: .enrollment)
//        try container.encode(qscore, forKey: .qscore)
//        try container.encode(spring, forKey: .spring)
//        try container.encode(fall, forKey: .fall)
//        try container.encode(notes, forKey: .notes)
//        try container.encode(color, forKey: .color)
//    }

//    static func withName(_ name: String, context: NSManagedObjectContext) -> Course {
//         // lookup name in Core Data
//        let request = NSFetchRequest<Course>(entityName: "Course")
//        request.predicate = NSPredicate(format: "name_ == %@", name)
//        request.sortDescriptors = [NSSortDescriptor(key: "position_", ascending: true)]
//        let courses = (try? context.fetch(request)) ?? []
//        if courses.count > 1 { print("More than one course with the name found") }
//        if let course = courses.first {
//            try? context.save()
//            return course
//        } else {
//            let course = Course(context: context)
//            course.name_ = name
//            try? context.save()
//            return course
//        }
//    }


//    func moveInSemester(to position: Int) {
//        if let context = managedObjectContext {
//            let request = Course.fetchRequest(NSPredicate(format: "semester_ == %@", argumentArray: [self.semester]))
//            let courses = (try? context.fetch(request)) ?? []
//            if (self.position < position) {
//                for index in (self.position + 1)...position {
//                    courses[index].position = index - 1
//                }
//            }
//            else if (self.position > position) {
//                for index in position..<(self.position) {
//                    courses[index].position = index + 1
//                }
//            }
//            self.position = position
//            try? context.save()
//        }
//    }



//    static func createFrom(_ info: CourseInfo, in context: NSManagedObjectContext, at position: Int) {
//        if info.name != "" {
//            let course = self.withName(info.name, context: context)
//            course.name_ = info.name
//            course.workload = Double(info.workload.replacingOccurrences(of: ",", with: ".")) ?? 0
//            course.semester = info.semester
//            course.enrollment = Int(info.enrollment) ?? 0
//            course.score = "\(Double(info.score) ?? 0)"
//            course.position = Int(position)
//            try? context.save()
//        }
//    }

// MARK: - Moving functions
//
//    func moveInSemester(to position: Int) {
//        if self.position == position { return }
//        if let context = managedObjectContext {
//            let topPosition = max(self.position, position)
//            let bottomPosition = min(self.position, position)
//            let predicate = NSPredicate(format:
//                "semester_ == %@ AND position_ <= %@ AND position_ >= %@ AND SELF != %@",
//                argumentArray: [self.semester, topPosition, bottomPosition, self])
//            let request = Course.fetchRequest(predicate)
//            let otherCourses = (try? context.fetch(request)) ?? []
//            let down = self.position < position
//            otherCourses.forEach(down ? { $0.position -= 1 } : { $0.position += 1 })
//            self.position = position
//            try? context.save()
//        }
//    }
//
//    func moveToSemester(_ semester: Int, and position: Int) {
//        if let context = managedObjectContext {
//            let requestForNew = Course.fetchRequest(NSPredicate(format: "semester_ == %@ and position_ >= %@", argumentArray: [semester, position]))
//            let newCourses = (try? context.fetch(requestForNew)) ?? []
//            newCourses.forEach { course in course.position += 1 }
//
//            let requestForOld = Course.fetchRequest(NSPredicate(format: "semester_ == %@ and position_ > %@", argumentArray: [self.semester, self.position]))
//            let oldCourses = (try? context.fetch(requestForOld)) ?? []
//            oldCourses.forEach { course in course.position -= 1 }
//
//            self.semester = semester
//            self.position = position
//            try? context.save()
//        }
//    }
//
//    func delete() {
//        if let context = self.managedObjectContext {
//            let request = Course.fetchRequest(NSPredicate(format: "semester_ = %@", argumentArray: [self.semester]))
//            let courses = (try? context.fetch(request)) ?? []
//            for index in 0..<courses.count {
//                courses[index].position = index
//            }
//            context.delete(self)
//            try? context.save()
//        }
//    }

//    static func createEmpty(in semester: Int, at position: Int, in context: NSManagedObjectContext){
//        let course = Course(context: context)
//        course.name = ""
//        course.fall = false
//        course.spring = false
////        print(course)
//        try? context.save()
//    }

// Type Changing
//    var position: Int {
//        get { Int(self.position_) }
//        set { self.position_ = Int32(newValue) }
//    }
//
//    var semester: Int {
//        get { Int(self.semester_) }
//        set { self.semester_ = Int16(newValue) }
//    }

//extension Course: UTType {
//
//}


// func createDummy() -> Course? {
//        if let context = managedObjectContext {
//            let dummyCourse = Course(context: context)
//            dummyCourse.name = "Dummy"
//            dummyCourse.moveToSemester(self.semester, and: self.position)
//            return dummyCourse
//        }
//        return nil
//    }
//
//    func moveLast() {
//        if let context = managedObjectContext {
//            let request = Course.fetchRequest(NSPredicate(format: "semester == %@ and position > %@", argumentArray: [self.semester, self.position]))
//            let courses = (try? context.fetch(request)) ?? []
//            if let last = courses.last {
//                for course in courses {
//                    course.position -= 1
//                }
//                self.position = last.position + 1
//            }
//
//
//        }
//    }


//    static func update(from info: AirportInfo, context: NSManagedObjectContext) {
//        if let icao = info.icao {
//            let airport = self.withICAO(icao, context: context)
//            airport.latitude = info.latitude
//            airport.longitude = info.longitude
//            airport.name = info.name
//            airport.location = info.location
//            airport.timezone = info.timezone
//            airport.objectWillChange.send()
//            airport.flightsTo.forEach { $0.objectWillChange.send() }
//            airport.flightsFrom.forEach { $0.objectWillChange.send() }
//            try? context.save()
//        }
//    }

//static func empty(in context: NSManagedObjectContext) -> Course {
//    let empty = Course(context: context)
//    return empty
//}
//
//func isEmpty() -> Bool {
//    if let context = managedObjectContext {
//        return Course.empty(in: context) == self
//    }
//    else {
//        return false
//    }
//}
