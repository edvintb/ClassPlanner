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
    
    static func createEmpty(concentration: Concentration, index: Int, in context: NSManagedObjectContext) {
//        let category = Category.withName(concentration: concentration, name: "", context: context)
        let category = Category(context: context)
        category.name = ""
        category.concentration = concentration
        category.index = index
        try? context.save()
//        print(category)
    }
    
    static func withName(concentration: Concentration, name: String, context: NSManagedObjectContext) -> Category {
//        let testRequest = Category.fetchRequest(NSPredicate(format: "name_ == %@", argumentArray: [name]))
        let request =  Category.fetchRequest(NSPredicate(format: "ANY concentration_.index_ == %@ AND name_ == %@", argumentArray: [concentration.index_, name]))
        let categories = (try? context.fetch(request)) ?? []
        if let category = categories.first {
            return category
        } else {
            let category = Category(context: context)
            category.name_ = name
            category.concentration = concentration
            print("New category created")
            return category
        }
    }
    
    // MARK: - Instance functions
    
    func move(to index: Int) {
        if self.index == index { return }
        if let context = managedObjectContext {
            let topIndex = max(self.index, index)
            let bottomIndex = min(self.index, index)
            let predicate = NSPredicate(format: "index_ <= %@ AND index_ >= %@ AND SELF != %@", argumentArray: [topIndex, bottomIndex, self])
            let request = Category.fetchRequest(predicate)
            let otherCategories = (try? context.fetch(request)) ?? []
            let down = self.index < index
            otherCategories.forEach(down ? { $0.index -= 1 } : { $0.index += 1 })
            self.index = index
            try? context.save()
        }
    }
    
    
    // MARK: - Property Access
    
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
    
//    static func requestForConcentration(_ concentration: Concentration) -> NSFetchRequest<Category> {
//        Category.fetchRequest(NSPredicate(format: "ANY concentration_.index_ == %@", argumentArray: [concentration.index_]))
//    }
    
    static func fetchRequest(_ predicate: NSPredicate) -> NSFetchRequest<Category> {
        let request = NSFetchRequest<Category>(entityName: "Category")
        request.sortDescriptors = [NSSortDescriptor(key: "index_", ascending: true)]
        request.predicate = predicate
        return request
    }
}
