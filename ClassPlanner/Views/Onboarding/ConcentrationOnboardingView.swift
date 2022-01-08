//
//  ScheduleOnboarding.swift
//  ClassPlanner
//
//  Created by Edvin Berhan on 18.07.21.
//

import SwiftUI

struct ConcentrationOnboardingView: View {
    
//    var setConcentrationOnboarding: (Bool) -> ()
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("This is a list of majors, minors & other requirements.")
            Text("To add a major, click in this box or drag & drop from the major tab.")
            Text("To move & remove majors, use drag & drop.")
        }
        .font(.system(size: 20, weight: .light, design: .default))
        .padding()
//        .onDisappear { setConcentrationOnboarding(false) }
    }
}
