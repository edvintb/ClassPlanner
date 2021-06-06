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
    
    // MARK: - Managing Current Concentrations
    
    @Published private (set) var currentConcentrations: [URL]
    
    func insertConcentration(_ concentration: Concentration) {
        currentConcentrations.insert(concentration.urlID, at: 0)
    }
    
    func removeConcentration(_ concentration: Concentration) {
        currentConcentrations.remove(at: 0)
    }
    
    init() {
        
        let concentrationKey = "CurrentConcentrations"
        
        let stringArray = (UserDefaults.standard.stringArray(forKey: concentrationKey))
        let urlIDs = stringArray?.compactMap { URL(string: $0) }
        self.currentConcentrations = urlIDs ?? []
        
        $currentConcentrations.sink { concentrations in
            let stringURL = concentrations.map { $0.absoluteString }
            UserDefaults.standard.setValue(stringURL, forKey: concentrationKey)
            print("Saved current concentrations")
        }
        .store(in: &cancellables)
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

