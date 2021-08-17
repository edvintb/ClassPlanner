//
//  SharedVM.swift
//  ClassPlanner
//
//  Created by Edvin Berhan on 2021-06-03.
//

import Foundation
import SwiftUI
import Combine

class SharedVM: ObservableObject {
    
    // Onboarding toggle
    @Published private (set) var isShowingOnboarding: Bool = false
    
    func showOnboarding() {
        self.isShowingOnboarding = true
    }
    
    // MARK: - Managing Current Schedule
    
    @Published private (set) var currentSchedule: ScheduleVM?
    
    func setCurrentSchedule(to schedule: ScheduleVM?) {
//        withAnimation(Animation.easeInOut(duration: 0.2)) {
            self.currentSchedule = schedule
//        }
    }
    

    
    
    // MARK: - Edit Functionality
    
    @Published private (set) var currentPanelSelection: PanelOption = .schedules
    @Published private (set) var currentEditSelection: EditOption = .none
    
    func setPanelSelection(to newSelection: PanelOption) {
        withAnimation(quickAnimation) {
            self.currentPanelSelection = newSelection
        }
    }
    
    func setEditSelection(to newSelection: EditOption) {
        withAnimation(Animation.easeInOut(duration: 0.15)) {
            self.currentEditSelection = newSelection
            currentPanelSelection = .editor
        }
    }
    
    func stopEdit() {
        withAnimation(quickAnimation) {
            currentEditSelection = .none
        }
    }
}

