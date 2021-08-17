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
        VStack(alignment: .leading, spacing: 20) {
            Text("This is your selected schedule.")
            Text("Schedules are created & selected under the \"Schedules\" tab.")
            Text("Each column represents a semester.")
            Text("\(workloadSymbol) shows total workload. \(fallSymbol) \(springSymbol) show fall spring.")
//                    Text("To edit a Schedule, click on its name.")
            Text("To add courses to a schedule, click + in a semester or use drag & drop.")
            Text("To move courses in a schedule, use drag & drop")
        }
        .font(.system(size: 18, weight: .regular, design: .default))
        .frame(width: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, height: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
        .padding()
        .onAppear { print("Schedule onboarding appeared")}
//        .onDisappear { setScheduleOnboarding(false) }
    }
}
