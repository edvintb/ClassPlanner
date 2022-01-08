//
//  ScheduleOnboarding.swift
//  ClassPlanner
//
//  Created by Edvin Berhan on 18.07.21.
//

import SwiftUI
import Combine

struct ScheduleOnboardingView: View {
    
    @EnvironmentObject var shared: SharedVM
    
    var setScheduleOnboarding: (Bool) -> ()
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("This is your selected 4-year schedule.")
            Text("Schedules are created & selected under the \"Schedules\" tab.")
            Text("Each column represents a semester.")
            if shared.isSemesterSystem {
                Text("\(workloadSymbol) \(implicationArrow) Workload. \(fallSymbol) \(implicationArrow) Fall. \(springSymbol) \(implicationArrow) Spring.")
            }
            else {
                Text("\(workloadSymbol) \(implicationArrow) Workload. 1 \(implicationArrow) Quarter 1. 2 \(implicationArrow) Quarter 2 .....")
            }
            Text("To add courses, click + in a semester or use drag & drop.")
            Text("To move & remove courses, use drag & drop.")
        }
        .font(.system(size: 18, weight: .regular, design: .default))
        .padding()
        .onDisappear { setScheduleOnboarding(false) }
    }
}
