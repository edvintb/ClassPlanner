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
                VStack(alignment: .leading, spacing: 5) {
                    Text("This is where courses are named & searched.")
                    Text("Entering the name of an existing course copies the data from that course")
                    Text("If there is no course with the name, a new course is created.")
//                    Text("Typing here searches among your created courses.")
//                    Text("If the course ") + Text("is").bold() + Text(" found, the rest of the information fills out")
//                    Text("If the course ") + Text("is not").bold() + Text(" found, the name you type creates a new course.")
//                    onboardingButton(text: "Dismiss", show: false)
                }
                .font(.system(size: 15))
                .padding()
                .onDisappear { print("Popup disappeared"); setCourseEditorOnboarding(false) }
    }
}
