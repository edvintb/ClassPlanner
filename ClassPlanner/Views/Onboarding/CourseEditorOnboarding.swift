//
//  ScheduleOnboarding.swift
//  ClassPlanner
//
//  Created by Edvin Berhan on 18.07.21.
//

import SwiftUI
import Combine

struct CourseNamingOnboarding: View {
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text("Use this field to search among courses.")
            Text("Use the fields below to create a new course.")
        }
        .font(onboardingTextFont)
        .padding()
    }
}

struct CourseSemesterOnboarding: View {
    
    @EnvironmentObject var shared: SharedVM
    
    var body: some View {
        if shared.isSemesterSystem {
            (Text("\(fallSymbol) \(implicationArrow) Fall Semester\n\(springSymbol) \(implicationArrow) Spring Semester\n ")
            + Text(courseContainedSymbol).foregroundColor(.green) + Text("  \(implicationArrow) Course Finished"))
                .lineSpacing(3)
                .multilineTextAlignment(.leading)
                .font(onboardingTextFont)
                .padding()
        }
        else {
            (Text("1 \(implicationArrow) First Quarter\n2 \(implicationArrow) Second Quarter\n ")
            + Text(courseContainedSymbol).foregroundColor(.green) + Text("  \(implicationArrow) Course Finished"))
                .lineSpacing(3)
                .multilineTextAlignment(.leading)
                .font(onboardingTextFont)
                .padding()
        }
    }
}


//                    Text("Typing here searches among your created courses.")
//                    Text("If the course ") + Text("is").bold() + Text(" found, the rest of the information fills out")
//                    Text("If the course ") + Text("is not").bold() + Text(" found, the name you type creates a new course.")
//                    onboardingButton(text: "Dismiss", show: false)
