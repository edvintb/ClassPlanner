//
//  SharedVM.swift
//  ClassPlanner
//
//  Created by Edvin Berhan on 2021-06-03.
//

import Foundation
import Combine

class SharedVM: ObservableObject {
    
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Managing Current Schedule
    
    private (set) var currentSchedule: ScheduleVM?
    
    func setCurrentSchedule(to schedule: ScheduleVM) {
        self.currentSchedule = schedule
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

