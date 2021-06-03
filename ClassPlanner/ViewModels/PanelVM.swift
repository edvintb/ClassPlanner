//
//  ConcentrationVM.swift
//  ClassPlanner
//
//  Created by Edvin Berhan on 2021-05-02.
//

import SwiftUI
import CoreData
import Foundation
import Combine

class PanelVM: ObservableObject {
    
    private let shared: SharedVM
    
    @Environment(\.managedObjectContext) var context
    
    @Published var existingCourseEntered: Bool = false
    
    let suggestionModel = SuggestionsModel<Course>()
    private var cancellables = Set<AnyCancellable>()
    
    init(context: NSManagedObjectContext, shared: SharedVM) {
        self.shared = shared
//         If we cancelled searching, we want to check if this name already exists
        suggestionModel.suggestionsCancelled
            .sink { [unowned self] _ in
                let predicate = NSPredicate(format: "name_ =[c] %@", argumentArray: [suggestionModel.textBinding?.wrappedValue ?? ""])
                let request = Course.fetchRequest(predicate)
                let count = (try? context.count(for: request)) ?? 0
                self.existingCourseEntered = count > 1
            }
            .store(in: &cancellables)
        
        suggestionModel.$suggestionConfirmed
            .sink { [unowned self] confirmed in
                if confirmed,
                    let newCourse = suggestionModel.selectedSuggestion?.value,
                    case let .course(oldCourse) = shared.currentEditSelection {
                    // print(oldCourse)
                    // Maybe we won't have access to the old course
                    // Replacing old course
                    shared.replaceCourse(old: oldCourse, new: newCourse)
                    shared.setEditSelection(to: .course(course: newCourse))
                }
                else {
                    print("Not confirmed suggestion")
                }
            }
            .store(in: &cancellables)
        
        suggestionModel.suggestionsCancelled
            .sink { [unowned self] _ in
                let predicate = NSPredicate(format: "name_ =[c] %@", argumentArray: [suggestionModel.textBinding?.wrappedValue ?? ""])
                let request = Course.fetchRequest(predicate)
                let courses = (try? context.fetch(request)) ?? []
                if let newCourse = courses.first,
                   case let .course(oldCourse) = shared.currentEditSelection {
                    shared.replaceCourse(old: oldCourse, new: newCourse)
                    shared.setEditSelection(to: .course(course: newCourse))
                }
            }
            .store(in: &cancellables)
        
//        suggestionModel.$suggestionConfirmed
//            .sink { [unowned self] (confirmed) in
//                    if confirmed, let course = self.suggestionModel.selectedSuggestion?.value {
////                        print("Updating Editoption to \(course.name)")
////                        print(course)
//                        self.setEditSelection(to: .course(course: course))
//                    }
//                }
//            .store(in: &cancelables)
        
        
    }
//    
//    func setPanelSelection(to newSelection: PanelOption) {
//        self.currentPanelSelection = newSelection
//    }
//    
//    func setEditSelection(to newSelection: EditOption) {
//        self.currentEditSelection = newSelection
//        currentPanelSelection = .editor
//    }
//    
//    func stopEdit() {
//        currentEditSelection = .none
//    }
}


    
//    func updateConcentrationIndices(context: NSManagedObjectContext) {
//        let request = Concentration.fetchRequest(.all)
//        let otherConcentration = (try? context.fetch(request)) ?? []
//        for index in 0..<otherConcentration.count {
//            otherConcentration[index].index = index
//        }
//        try? context.save()
//    }
