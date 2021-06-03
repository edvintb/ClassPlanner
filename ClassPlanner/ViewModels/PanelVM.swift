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
    
    let shared: SharedVM
    
    @Environment(\.managedObjectContext) var context
    
    let suggestionModel = SuggestionsModel<Course>()
    private var cancellables = Set<AnyCancellable>()
    
    init(shared: SharedVM) {
        self.shared = shared
        // Replacing if name exists when cancelling search
        // We could find any remaining suggestion, but not sure how solid?
        // Would eliminate need for context
        suggestionModel.suggestionsCancelled
            .sink { [unowned self] _ in
                let predicate = NSPredicate(format: "name_ =[c] %@", argumentArray: [suggestionModel.textBinding?.wrappedValue ?? ""])
                let request = Course.fetchRequest(predicate)
                let courses = (try? context.fetch(request)) ?? []
                if let new = courses.first, case let .course(oldCourse) = shared.currentEditSelection {
                    shared.replaceCourseInCurrent(old: oldCourse, new: new)
                    setEditSelection(to: .course(course: new))
                }
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
                    shared.replaceCourseInCurrent(old: oldCourse, new: newCourse)
                    setEditSelection(to: .course(course: newCourse))
                }
                else {
                    print("Not confirmed suggestion")
                }
            }
            .store(in: &cancellables)
    }
    
    
    func setPanelSelection(to newSelection: PanelOption) {
        shared.setPanelSelection(to: newSelection)
    }
    
    func setEditSelection(to newSelection: EditOption) {
        shared.setEditSelection(to: newSelection)
        shared.setPanelSelection(to: .editor)
    }
    
    func stopEdit() { shared.setEditSelection(to: .none) }
}



// Is this the right place for all these subscriptions??
// They have to be in classes... should they be in the panel??
//        $currentEditSelection
//            .map { (option) -> Course? in
//                switch option {
//                case .course(let course):
//                    print(course.objectID)
//                    return course
//                default:
//                    return nil
//                }
//            }
//            .assign(to: \.currentEditCourse, on: self)
//            .store(in: &cancellables)

//         If we cancelled searching, we want to check if this name already exists

//        // Alerting if name exists when cancelling

//    @Published var existingCourseEntered: Bool = false
//        suggestionModel.suggestionsCancelled
//            .sink { [unowned self] _ in
//                let predicate = NSPredicate(format: "name_ =[c] %@", argumentArray: [suggestionModel.textBinding?.wrappedValue ?? ""])
//                let request = Course.fetchRequest(predicate)
//                let count = (try? context.count(for: request)) ?? 0
//                self.existingCourseEntered = count > 1
//            }
//            .store(in: &cancellables)

//        suggestionModel.$suggestionConfirmed
//            .sink { [unowned self] (confirmed) in
//                    if confirmed, let course = self.suggestionModel.selectedSuggestion?.value {
////                        print("Updating Editoption to \(course.name)")
////                        print(course)
//                        self.setEditSelection(to: .course(course: course))
//                    }
//                }
//            .store(in: &cancelables)


    
//    func updateConcentrationIndices(context: NSManagedObjectContext) {
//        let request = Concentration.fetchRequest(.all)
//        let otherConcentration = (try? context.fetch(request)) ?? []
//        for index in 0..<otherConcentration.count {
//            otherConcentration[index].index = index
//        }
//        try? context.save()
//    }
