//
//  ScheduleOnboarding.swift
//  ClassPlanner
//
//  Created by Edvin Berhan on 18.07.21.
//

import SwiftUI

struct ConcentrationEditorOnboarding: View {
    
//    var setConcentrationEditorOnboarding: (Bool) -> ()
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("A major does not have courses. Majors have categories.")
            Text("The courses are split up into \"buckets\" called categories.")
            Text("Click + in a major to create a new category for that major.")
            Text("To move categories in a major, use drag & drop.")
        }
        .font(onboardingTextFont)
        .padding()
//        .onDisappear { setConcentrationEditorOnboarding(false) }
    }
}
