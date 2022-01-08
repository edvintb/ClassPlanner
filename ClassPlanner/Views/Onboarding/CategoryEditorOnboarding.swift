//
//  ScheduleOnboarding.swift
//  ClassPlanner
//
//  Created by Edvin Berhan on 18.07.21.
//

import SwiftUI

struct CategoryFunctionOnboarding: View {
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("A Category is ") + Text("not").font(.system(size: 15, weight: .bold)) + Text(" a major.")
            Text("If a major is ") + Text("Computer Science").foregroundColor(.oliveGreen) + Text(", a category could be ") + Text("Basic Software").foregroundColor(.newOrange)
            Text("To add courses to a category, search below or use drag & drop.")
            Text("To move categories in majors, use drag & drop.")
            Text("To copy categories between majors, use drag & drop")
        }
        .font(onboardingTextFont)
        .padding()
    }
}
