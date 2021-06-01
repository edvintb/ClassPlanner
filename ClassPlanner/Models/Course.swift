//
//  Class.swift
//  ClassPlanner
//
//  Created by Edvin Berhan on 2021-03-20.
//

import CoreData
import Combine
import AppKit

extension CodingUserInfoKey {
  static let managedObjectContext = CodingUserInfoKey(rawValue: "managedObjectContext")!
}

enum DecoderConfigurationError: Error {
  case missingManagedObjectContext
}


public class Course: NSManagedObject, Codable {
    
    enum CodingKeys: CodingKey {
       case name, workload, enrollment, qscore, spring, fall, notes, color
     }

     required convenience public init(from decoder: Decoder) throws {
        
        guard let context = decoder.userInfo[CodingUserInfoKey.managedObjectContext] as? NSManagedObjectContext else {
          throw DecoderConfigurationError.missingManagedObjectContext
        }
        
        self.init(context: context)
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.name = try container.decode(String.self, forKey: .name)
        self.workload = try container.decode(Double.self, forKey: .workload)
        self.enrollment = try container.decode(Int.self, forKey: .enrollment)
        self.qscore = try container.decode(Double.self, forKey: .qscore)
        self.spring = try container.decode(Bool.self, forKey: .spring)
        self.fall = try container.decode(Bool.self, forKey: .fall)
        self.notes = try container.decode(String.self, forKey: .notes)
        self.color = try container.decode(Int.self, forKey: .color)
        
    }
    
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: .name)
        try container.encode(workload, forKey: .workload)
        try container.encode(enrollment, forKey: .enrollment)
        try container.encode(qscore, forKey: .qscore)
        try container.encode(spring, forKey: .spring)
        try container.encode(fall, forKey: .fall)
        try container.encode(notes, forKey: .notes)
        try container.encode(color, forKey: .color)
    }
    
}


extension Course {
    
    // MARK: - Static functions
    
    static func createEmpty(in semester: Int, at position: Int, in context: NSManagedObjectContext){
        let course = Course(context: context)
        course.name = ""
        course.semester = semester
        course.position = position
        course.fall = false
        course.spring = false
//        print(course)
        try? context.save()
    }
    
    static func fetchRequest(_ predicate: NSPredicate) -> NSFetchRequest<Course> {
        let request = NSFetchRequest<Course>(entityName: "Course")
        request.sortDescriptors = [NSSortDescriptor(key: "name_", ascending: true)]
        request.predicate = predicate
        return request
    }
    
    static func withName(_ name: String, context: NSManagedObjectContext) -> Course {
         // lookup name in Core Data
        let request = NSFetchRequest<Course>(entityName: "Course")
        request.predicate = NSPredicate(format: "name_ == %@", name)
        request.sortDescriptors = [NSSortDescriptor(key: "position_", ascending: true)]
        let courses = (try? context.fetch(request)) ?? []
        if courses.count > 1 { print("More than one course with the name found") }
        if let course = courses.first {
            try? context.save()
            return course
        } else {
            let course = Course(context: context)
            course.name_ = name
            try? context.save()
            return course
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
    
    static func fromURI(uri: URL, context: NSManagedObjectContext) -> Course? {
        let id = context.persistentStoreCoordinator?.managedObjectID(forURIRepresentation: uri)
        if id == nil { return nil }
        let object = try? context.existingObject(with: id!)
        if object == nil { return nil }
        let course = object as? Course
        return course
    }
    
    
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
    
    func delete() {
        if let context = self.managedObjectContext {
            context.delete(self)
            try? context.save()
        }
    }
    
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
    
    var isEmpty: Bool {
        self.notes == "" && self.workload == 0 && self.enrollment == 0 && self.qscore == 0 && self.color == 0
    }
    
    // MARK: - Property access

    // Removing nil values
    var name: String {
        get { self.name_ ?? ""}
        set { self.name_ = newValue }
    }
    
    var notes: String {
        get { self.notes_ ?? ""}
        set { self.notes_ = newValue }
    }
    
    // Type Changing
    var position: Int {
        get { Int(self.position_) }
        set { self.position_ = Int32(newValue) }
    }
    
    var semester: Int {
        get { Int(self.semester_) }
        set { self.semester_ = Int16(newValue) }
    }
    
    var workload: Double {
        get { self.workload_ }
        set { self.workload_ = newValue }
    }
    
    var enrollment: Int {
        get { Int(self.enrollment_) }
        set { self.enrollment_ = Int16(newValue) }
    }
    
    var color: Int {
        get { Int(self.color_) }
        set { self.color_ = Int16(newValue) }
    }
    
}



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
