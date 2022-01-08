//
//  ScheduleOnboarding.swift
//  ClassPlanner
//
//  Created by Edvin Berhan on 18.07.21.
//

import SwiftUI

struct ConcentrationStoreOnboarding: View {
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("This is a list of all your created majors.")
            Text("Drag majors into the \"Current Majors\" section below the schedule.")
            Text("There you can view a major at the same time as the schedule.")
        }
        .font(onboardingTextFont)
        .padding()
    }
}
