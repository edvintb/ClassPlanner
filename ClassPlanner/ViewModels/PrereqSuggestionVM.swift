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

class PrereqSuggestionVM: ObservableObject {
    
    @ObservedObject var shared: SharedVM
    
    let suggestionModel = SuggestionsModel<Course>()
    
    private var cancellables = Set<AnyCancellable>()
    
    init(shared: SharedVM) {
        self.shared = shared
        
        suggestionModel.$suggestionConfirmed
            .sink { [unowned self] confirmed in
                if confirmed,
                let selectedCourse = self.suggestionModel.selectedSuggestion?.value,
                case let .course(currentCourse) = shared.currentEditSelection {
                    withAnimation {
                        currentCourse.insertPrereq(prereq: selectedCourse)
                    }
                }
            }
            .store(in: &cancellables)
    }
    
    //        suggestionModel.$suggestionConfirmed
    //            .sink { [unowned self] (confirmed) in
    //                    if confirmed, let course = self.suggestionModel.selectedSuggestion?.value {
    ////                        print("Updating Editoption to \(course.name)")
    ////                        print(course)
    //                        self.setEditSelection(to: .course(course: course))
    //                    }
    //                }
    //            .store(in: &cancelables)
    
    //         If we cancelled searching, we want to check if this name already exists
    //        suggestionModel.suggestionsCancelled
    //            .sink { [unowned self] _ in
    //                let predicate = NSPredicate(format: "name_ =[c] %@", argumentArray: [suggestionModel.textBinding?.wrappedValue ?? ""])
    //                let request = Course.fetchRequest(predicate)
    //                let count = (try? context.count(for: request)) ?? 0
    //                self.existingCourseEntered = count > 1
    //            }
    //            .store(in: &cancellables)
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
