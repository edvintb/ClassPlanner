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
    
    // MARK: - Onboarding
    
    @Published private (set) var isShowingOnboarding: Bool = false
    @Published private (set) var isShowingWelcomeSheet: Bool = false
    
    func showOnboarding() {
        self.isShowingOnboarding = true
    }
    
    func showWelcomeSheet() {
        self.isShowingWelcomeSheet = true
    }
    
    // MARK: - Managing Current Schedule
    
    @Published private (set) var currentSchedule: ScheduleVM?
    
    func setCurrentSchedule(to schedule: ScheduleVM?) {
        UserDefaults.standard.setValue(schedule?.name, forKey: currentScheduleKey)
        self.currentSchedule = schedule
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
    
    // MARK: Settings
    
    let defaults: UserDefaults
    
    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
        
        defaults.register(defaults: [
            semestersToShowKey: 8,
            schoolSystemKey: SchoolSystem.semester.rawValue,
            currentSchoolKey: School.harvardCollege.rawValue,
            courseLengthKey: 75,
            weekStartTimeKey: Date.init(timeIntervalSinceReferenceDate: 8 * 3600),
            weekStopTimeKey: Date.init(timeIntervalSinceReferenceDate: 18 * 3600)
        ])
        
    }
    
    var currentSchool: School {
        set { defaults.set(newValue.rawValue, forKey: currentSchoolKey); objectWillChange.send() }
        get { School.init(rawValue: defaults.integer(forKey: currentSchoolKey)) ?? .harvardCollege }
    }
    
    var schoolSystem: SchoolSystem {
        set { defaults.set(newValue.rawValue, forKey: schoolSystemKey); objectWillChange.send() }
        get { SchoolSystem.init(rawValue: defaults.integer(forKey: schoolSystemKey)) ?? .semester }
    }
    
    var isSemesterSystem: Bool {
        schoolSystem == .semester
    }
    
    var semestersToShow: Int {
        set { defaults.set(newValue, forKey: semestersToShowKey); objectWillChange.send() }
        get { defaults.integer(forKey: semestersToShowKey) }
    }
    
    var weekStartTime: Date {
        set { defaults.set(newValue, forKey: weekStartTimeKey); objectWillChange.send() }
        get { defaults.object(forKey: weekStartTimeKey) as? Date ?? Date.init(timeIntervalSinceReferenceDate: 8 * 3600) }
    }
    
    var weekStopTime: Date {
        set { defaults.set(newValue, forKey: weekStopTimeKey); objectWillChange.send() }
        get { defaults.object(forKey: weekStopTimeKey) as? Date ?? Date.init(timeIntervalSinceReferenceDate: 18 * 3600) }
    }
    
    var courseLength: Int {
        set { defaults.set(newValue, forKey: courseLengthKey); objectWillChange.send() }
        get { defaults.integer(forKey: courseLengthKey) }
    }
}

