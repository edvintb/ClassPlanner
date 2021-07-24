//
//  ScheduleOnboarding.swift
//  ClassPlanner
//
//  Created by Edvin Berhan on 18.07.21.
//

import SwiftUI

struct ScheduleOnboardingView: View {
    
    static let scheduleOnboardingKey = "scheduleOnboardingKey"
    @State private var isHidingOnboarding: Bool = UserDefaults.standard.bool(forKey: scheduleOnboardingKey)
    
    var body: some View {
        if isHidingOnboarding {
            onboardingButton(text: "Help", hide: false)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
                .padding([.trailing, .top], 5)
        }
        else {
            ZStack {
                onboardingButton(text: "Hide", hide: true)
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
                    .padding([.trailing, .top], 5)
                VStack(alignment: .leading, spacing: 20) {
                    Text("This box shows your currently selected 4-year schedule. You select a schedule from the \"Schedules\" tab in the panel on the left.")
                    Text("To add courses to a schedule, you click \"+\" in a semester or drag & drop a course from the store. To move courses, you use drag & drop")
//                    Text("Each column represents a semester. The workload for each semester and your total GPA are computed from the courses and shown at the top of the schedule")
                    onboardingButton(text: "Dismiss", hide: true)
                }
                .font(.system(size: 25, weight: .light, design: .default))
                .frame(width: 600)
                Rectangle().foregroundColor(.blue).opacity(0.2)
            }
        }
    }
    
    func onboardingButton(text: String, hide: Bool) -> some View {
        Button(action: {
            withAnimation {
                self.isHidingOnboarding = hide
                UserDefaults.standard.setValue(hide, forKey: ScheduleOnboardingView.scheduleOnboardingKey)
            }
        }, label: {
            Text(text).font(.headline)
        })
    }
}
