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
    // Perhaps this belongs somewhere else
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
    
    // Needed to automatically save & load with User Defaults
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

