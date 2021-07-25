//
//  ScheduleOnboarding.swift
//  ClassPlanner
//
//  Created by Edvin Berhan on 18.07.21.
//

import SwiftUI
import Combine

struct ScheduleOnboardingView: View {
    
    @Binding var isShowingOnboarding: Bool
    var setScheduleOnboarding: (Bool) -> ()
    
    var body: some View {
        if isShowingOnboarding {
            ZStack {
                VStack(alignment: .leading, spacing: 20) {
                    Text("This is your selected schedule.")
                    Text("Schedules are created & selected under the \"Schedules\" tab.")
                    Text("The 8 columns represent 8 school semesters.")
                    Text("The symbols above each semester show total workload - \(workloadSymbol) & fall/spring -  \(fallSymbol)/\(springSymbol).")
//                    Text("To edit a Schedule, click on its name.")
                    Text("To add courses to a schedule, click + in a semester or use drag & drop.")
                    Text("To move courses in a schedule, use drag & drop")
                    onboardingButton(text: "Dismiss", show: false)
                }
                .font(.system(size: 22, weight: .regular, design: .default))
                .frame(width: 800)
                Rectangle().foregroundColor(.blue).opacity(0.2)
            }
        }
    }
    
    func onboardingButton(text: String, show: Bool) -> some View {
        Button(
            action: {
                setScheduleOnboarding(show)
            },
            label: {
                Text(text).font(.headline)
            }
        )
    }
}
