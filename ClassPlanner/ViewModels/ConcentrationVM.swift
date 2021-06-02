//
//  ConcentrationVM.swift
//  ClassPlanner
//
//  Created by Edvin Berhan on 2021-05-18.
//

import Foundation

class ConcentrationVM: ObservableObject {
    
    @Published var scheduleStore: ScheduleStore
    
    init(panel: PanelVM, scheduleStore: ScheduleStore) {
        self.panel = panel
        self.scheduleStore = scheduleStore
    }
    
    // MARK: - Editing
    
    private var panel: PanelVM
    
    func setEditCategory(_ category: Category) {
        panel.setEditSelection(to: .category(category: category))
    }
    
    // MARK: - Dragging

    @Published private (set) var dragConcentration: Concentration?
    @Published private (set) var dragCategory: Category?
    
    private var startIndex: Int?
    private var dragIndex: Int?
    
    func setDragConcentration(to concentration: Concentration) {
        dragConcentration = concentration
        startIndex = concentration.index
        dragIndex = concentration.index
    }
    
    func setDragCategory(to category: Category) {
        dragCategory = category
        startIndex = category.index
        dragIndex = category.index
    }
    
    func categoryDragEnded() {
        if let category = dragCategory, let index = dragIndex { category.move(to: index) }
        dragCategory = nil
    }
    
    func concentrationDragEnded() {
        if let concentration = dragConcentration, let index = dragIndex{ concentration.move(to: index) }
        dragConcentration = nil
    }
    
    
    
    
    func hoverOverConcentration(_ concentration: Concentration, entered: Bool) -> Bool {
        if dragConcentration != nil && dragConcentration != concentration {
            if entered {
                print("Dragging over concentration \(concentration.index)")
                dragIndex = concentration.index
            }
            else {
                 print("Setting back to start position")
                dragIndex = startIndex
            }
            return entered
        }
        return false
    }
    
    func hoverOverCategory(_ category: Category, entered: Bool) -> Bool {
        if dragCategory != nil && dragCategory != category {
            if entered {
                print("Dragging over category \(category.index)")
                dragIndex = category.index
            }
            else {
                print("Setting back to start position")
                dragIndex = startIndex
            }
            return entered
        }
        return false
    }
    
}
