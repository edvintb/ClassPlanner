//
//  Concentration.swift
//  ClassPlanner
//
//  Created by Edvin Berhan on 2021-04-24.
//

import Foundation
import CoreData
import SwiftUI

extension Concentration {
    
    // MARK: - Static functions
    
    static func createEmpty(in context: NSManagedObjectContext) -> Concentration{
        let concentration = Concentration(context: context)
        try? context.save()
        return concentration
    }
    
    static func fetchRequest(_ predicate: NSPredicate) -> NSFetchRequest<Concentration> {
        let request = NSFetchRequest<Concentration>(entityName: "Concentration")
        request.sortDescriptors = [NSSortDescriptor(key: "index_", ascending: true)]
        request.predicate = predicate
        return request
    }
    
    // MARK: - Instance functions
    
    func move(to index: Int) {
        if self.index == index { return }
        if let context = managedObjectContext {
            let topIndex = max(self.index, index)
            let bottomIndex = min(self.index, index)
            let predicate = NSPredicate(format: "index_ <= %@ AND index_ >= %@ AND SELF != %@", argumentArray: [topIndex, bottomIndex, self])
            let request = Concentration.fetchRequest(predicate)
            let otherConcentrations = (try? context.fetch(request)) ?? []
            let down = self.index < index
            otherConcentrations.forEach(down ? { $0.index -= 1 } : { $0.index += 1 })
            self.index = index
            try? context.save()
        }
    }
    
    func delete() {
        if let context = managedObjectContext{
            context.delete(self)
            let request = Concentration.fetchRequest(.all)
            let otherConcentration = (try? context.fetch(request)) ?? []
            for index in 0..<otherConcentration.count {
                otherConcentration[index].index = index
            }
            try? context.save()
        }
    }
    
    func addCategory() {
        if let context = managedObjectContext {
            let category = Category(context: context)
            category.concentration = self
            category.name = ""
            category.index = self.categories.count
            try? context.save()
        }
    }
    
    func removeCategory(_ category: Category) {
        if let context = managedObjectContext {
            self.categories.remove(category)
            try? context.save()
        }
    }
    
    // MARK: - Property Access
    
    var index: Int {
        get { Int(self.index_) }
        set { self.index_ = Int16(newValue) }
    }
    
    var name: String {
        get { self.name_ ?? "Unknown Concentration"}
        set { self.name_ = newValue }
    }
    
    var notes: String {
        get { self.notes_ ?? ""}
        set { self.notes_ = newValue }
    }
    
    var categories: Set<Category> {
        get { (self.categories_ as? Set<Category>) ?? [] }
        set { self.categories_ = newValue as NSSet}
    }
    
    var courses: Set<Course> {
        get { (self.courses_ as? Set<Course>) ?? [] }
        set { self.courses_ = newValue as NSSet}
    }
    
    var color: Int {
        get { Int(self.color_) }
        set { self.color_ = Int16(newValue) }
    }
    
    func getColor() -> Color {
        Color.colorSelection[self.color % Color.colorSelection.count]
    }

    
}


//
////    static func withName(_ name: String, context: NSManagedObjectContext) -> Concentration {
////         // lookup name in Core Data
////        let request = Concentration.fetchRequest(NSPredicate(format: "name_ == %@", name))
////        let concentrations = (try? context.fetch(request)) ?? []
////        if let concentration = concentrations.first {
////            return concentration
////        } else {
////            let concentration = Concentration(context: context)
////            concentration.name_ = name
////            return concentration
////        }
////    }
//
//    static func createWith(_ name: String, and notes: String, in context: NSManagedObjectContext) {
//        let concentration = Concentration.withName(name, context: context)
//        concentration.notes_ = notes
//        try? context.save()
//    }
