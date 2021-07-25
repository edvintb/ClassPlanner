//
//  ScheduleOnboarding.swift
//  ClassPlanner
//
//  Created by Edvin Berhan on 18.07.21.
//

import SwiftUI
import Combine

struct CourseEditorOnboarding: View {
    
    @Binding var isShowingOnboarding: Bool
    var setCourseEditorOnboarding: (Bool) -> ()
    
    var body: some View {
        if isShowingOnboarding {
            ZStack {
                VStack(alignment: .leading, spacing: 5) {
                    Text("Typing the name of a created course copies the data from that course")
                    Text("Typing the name of a non-existing course creates a new course")
//                    Text("Typing here searches among your created courses.")
//                    Text("If the course ") + Text("is").bold() + Text(" found, the rest of the information fills out")
//                    Text("If the course ") + Text("is not").bold() + Text(" found, the name you type creates a new course.")
//                    onboardingButton(text: "Dismiss", show: false)
                }
                .font(.system(size: 13))
                .padding()
//                .frame(maxHeight: .infinity, alignment: .top)
                Rectangle().foregroundColor(.orange).opacity(0.1)
                    .onDisappear { setCourseEditorOnboarding(false) }
            }
        }
    }
    
    func onboardingButton(text: String, show: Bool) -> some View {
        Button(
            action: {
                setCourseEditorOnboarding(show)
            },
            label: {
                Text(text).font(.headline)
            }
        )
    }
}
