//
//  ConcentrationVM.swift
//  ClassPlanner
//
//  Created by Edvin Berhan on 2021-05-18.
//

import Foundation
import Combine
import CoreData

class ConcentrationVM: ObservableObject {


    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Managing Current Concentrations

    @Published private (set) var currentConcentrations: [URL]
    
    func moveInsertConcentration(_ concentration: Concentration, at newIndex: Int) {
        if let currentIndex = currentConcentrations.firstIndex(of: concentration.urlID) {
            currentConcentrations.remove(at: currentIndex)
        }
        currentConcentrations.insert(concentration.urlID, at: newIndex)
    }
    
    func removeConcentration(_ concentration: Concentration) {
        if let removeIndex = currentConcentrations.firstIndex(of: concentration.urlID) {
            currentConcentrations.remove(at: removeIndex)
        }
    }
    
    func addConcentration(context: NSManagedObjectContext) {
        let new = Concentration.createEmpty(in: context)
        moveInsertConcentration(new, at: currentConcentrations.count)
    }
    
    // Needed to automatically save & load with User Defaults
    init() {
        
        let concentrationKey = "CurrentConcentrations"
        
        let stringArray = (UserDefaults.standard.stringArray(forKey: concentrationKey))
        let urlIDs = stringArray?.compactMap { URL(string: $0) }
        self.currentConcentrations = urlIDs ?? []
        
        $currentConcentrations.sink { concentrations in
            let stringURL = concentrations.map { $0.absoluteString }
            UserDefaults.standard.setValue(stringURL, forKey: concentrationKey)
        }
        .store(in: &cancellables)
    }
    
    
    
    // MARK: - Dragging

//    @Published private (set) var dragConcentration: Concentration?
//    @Published private (set) var dragCategory: Category?
//
//    private var startIndex: Int?
//    private var dragIndex: Int?
//
//    func setDragConcentration(to concentration: Concentration) {
//        dragConcentration = concentration
//        startIndex = concentration.index
//        dragIndex = concentration.index
//    }
//
//    func setDragCategory(to category: Category) {
//        dragCategory = category
//        startIndex = category.index
//        dragIndex = category.index
//    }
//
////    func categoryDragEnded() {
////        if let category = dragCategory, let index = dragIndex { category.move(to: index) }
////        dragCategory = nil
////    }
//
//    func concentrationDragEnded() {
//        if let concentration = dragConcentration, let index = dragIndex{ concentration.move(to: index) }
//        dragConcentration = nil
//    }
//
//
//
//
//    func hoverOverConcentration(_ concentration: Concentration, entered: Bool) -> Bool {
//        if dragConcentration != nil && dragConcentration != concentration {
//            if entered {
//                print("Dragging over concentration \(concentration.index)")
//                dragIndex = concentration.index
//            }
//            else {
//                 print("Setting back to start position")
//                dragIndex = startIndex
//            }
//            return entered
//        }
//        return false
//    }
//
//    func hoverOverCategory(_ category: Category, entered: Bool) -> Bool {
//        if dragCategory != nil && dragCategory != category {
//            if entered {
//                print("Dragging over category \(category.index)")
//                dragIndex = category.index
//            }
//            else {
//                print("Setting back to start position")
//                dragIndex = startIndex
//            }
//            return entered
//        }
//        return false
//    }
    
}
