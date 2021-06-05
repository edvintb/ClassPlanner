//
//  SharedVM.swift
//  ClassPlanner
//
//  Created by Edvin Berhan on 2021-06-03.
//

import Foundation

class SharedVM: ObservableObject {
    
    // MARK: - Managing Current Schedule
    
    private (set) var currentSchedule: ScheduleVM?
    
    func setCurrentSchedule(to schedule: ScheduleVM) {
        self.currentSchedule = schedule
    }
    
    // MARK: - Managing Current Concentrations
    
    @Published private (set) var currentConcentrations = Set<Concentration>()
    
    func insertConcentration(_ concentration: Concentration) {
        currentConcentrations.insert(concentration)
    }
    
    func removeConcentration(_ concentration: Concentration) {
        currentConcentrations.remove(concentration)
    }
    
    
    // MARK: - Edit Functionality
    
    @Published private (set) var currentPanelSelection: PanelOption = .schedules
    @Published private (set) var currentEditSelection: EditOption = .none
    
    func setPanelSelection(to newSelection: PanelOption) {
        self.currentPanelSelection = newSelection
    }
    
    func setEditSelection(to newSelection: EditOption) {
        self.currentEditSelection = newSelection
        currentPanelSelection = .editor
    }
    
    func stopEdit() {
        currentEditSelection = .none
    }
}

