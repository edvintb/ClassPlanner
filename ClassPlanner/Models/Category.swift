//
//  Category.swift
//  ClassPlanner
//
//  Created by Edvin Berhan on 2021-05-02.
//

import Foundation
import CoreData

extension Category {
    
    // MARK: - Static functions
    
    
    // MARK: - Instance functions
    
    func addCourse(_ course: Course) {
        if course.name == "" { return }
        if let context = managedObjectContext {
            self.courses.insert(course)
            try? context.save()
        }

    }
    
    func removeCourse(_ course: Course) {
        if let context = managedObjectContext {
            self.courses.remove(course)
            try? context.save()
        }

    }
    
    func move(to index: Int) {
        if self.index == index { return }
        if let context = managedObjectContext, let concentration = self.concentration {
            let topIndex = max(self.index, index)
            let bottomIndex = min(self.index, index)
            let predicate = NSPredicate(format: "concentration == %@ AND index_ <= %@ AND index_ >= %@ AND SELF != %@",
                                        argumentArray: [concentration, topIndex, bottomIndex, self])
            let request = Category.fetchRequest(predicate)
            let otherCategories = (try? context.fetch(request)) ?? []
            let down = self.index < index
            otherCategories.forEach(down ? { $0.index -= 1 } : { $0.index += 1 })
            self.index = index
            try? context.save()
        }
    }
    
    func delete() {
        if let context = self.managedObjectContext, let concentration = self.concentration {
            context.delete(self)
            let request = Category.fetchRequest(NSPredicate(format: "concentration = %@", argumentArray: [concentration]))
            let otherCategories = (try? context.fetch(request)) ?? []
            for index in 0..<otherCategories.count {
                otherCategories[index].index = index
            }
            try? context.save()
        }
    }
    
    
    
    // MARK: - Property Access
    
    func coursesSortedBySchedule(schedule: ScheduleVM) -> [Course] {
        let urls = schedule.courseURLs
        let sorted = self.courses.sorted(by: {
            let firstURL = $0.objectID.uriRepresentation()
            let secondURL = $1.objectID.uriRepresentation()
            let firstContained = urls.contains(firstURL)
            let secondContained = urls.contains(secondURL)
            if firstContained == secondContained {
                // If both in or out order by name
                return $0.name < $1.name
            }
            return firstContained
        })
        return sorted
    }
    
    func coursesSorted() -> [Course] {
        self.courses.sorted(by: { $0.name < $1.name })
    }
    
    
    var index: Int {
        get { Int(self.index_) }
        set { self.index_ = Int16(newValue) }
    }
    
    var numberOfRequired: Int {
        get { Int(self.numberOfRequired_) }
        set { self.numberOfRequired_ = Int16(newValue) }
    }
    
    var name: String {
        get { self.name_ ?? ""}
        set { self.name_ = newValue }
    }
    
    var courses: Set<Course> {
        get { (self.courses_ as? Set<Course>) ?? [] }
        set { self.courses_ = newValue as NSSet}
    }
    
    var color: Int {
        get { Int(self.color_) }
        set { self.color_ = Int16(newValue) }
    }
    
    var notes: String {
        get { self.notes_ ?? ""}
        set { self.notes_ = newValue }
    }
    

    
    static func fetchRequest(_ predicate: NSPredicate) -> NSFetchRequest<Category> {
        let request = NSFetchRequest<Category>(entityName: "Category")
        request.sortDescriptors = [NSSortDescriptor(key: "index_", ascending: true)]
        request.predicate = predicate
        return request
    }
}

//    static func requestForConcentration(_ concentration: Concentration) -> NSFetchRequest<Category> {
//        Category.fetchRequest(NSPredicate(format: "ANY concentration_.index_ == %@", argumentArray: [concentration.index_]))
//    }

//
//static func withName(concentration: Concentration, name: String, context: NSManagedObjectContext) -> Category {
//////        let testRequest = Category.fetchRequest(NSPredicate(format: "name_ == %@", argumentArray: [name]))
////        let request =  Category.fetchRequest(NSPredicate(format: "ANY concentration_.index_ == %@ AND name_ == %@", argumentArray: [concentration.index_, name]))
////        let categories = (try? context.fetch(request)) ?? []
////        if let category = categories.first {
////            return category
////        } else {
////            let category = Category(context: context)
////            category.name_ = name
////            category.concentration = concentration
////            print("New category created")
////            return category
////        }
////    }
