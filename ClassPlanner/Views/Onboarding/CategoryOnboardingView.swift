//
//  ScheduleOnboarding.swift
//  ClassPlanner
//
//  Created by Edvin Berhan on 18.07.21.
//

import SwiftUI

struct CategoryOnboardingView: View {
    
    @Binding var isShowingOnboarding: Bool
    var setCategoryOnboarding: (Bool) -> ()
    
    var body: some View {
        if isShowingOnboarding {
            ZStack {
                VStack(alignment: .leading, spacing: 10) {
                    Text("Each major has multiple course categories.")
                    Text("Click + in a major to create a new category for that major.")
                    Text("To move categories in a major, use drag & drop.")
                    onboardingButton(text: "Dismiss", show: false)
                }
                .font(.system(size: 18, weight: .light, design: .default))
                .frame(width: 800)
                RoundedRectangle(cornerRadius: frameCornerRadius)
                    .foregroundColor(.orange).opacity(0.2)
            }
        }
    }
    
    func onboardingButton(text: String, show: Bool) -> some View {
        Button(
            action: {
                setCategoryOnboarding(show)
            },
            label: {
                Text(text).font(.headline)
            }
        )
    }
}
