//
//  ScheduleOnboarding.swift
//  ClassPlanner
//
//  Created by Edvin Berhan on 18.07.21.
//

import SwiftUI

struct ConcentrationOnboardingView: View {
    
    @Binding var isShowingOnboarding: Bool
    @Environment(\.managedObjectContext) var context
    var setConcentrationOnboarding: (Bool) -> ()
    
    var body: some View {
        if isShowingOnboarding {
            ScrollView([.horizontal, .vertical]) {
                ZStack {
                    VStack(alignment: .leading, spacing: 20) {
                        Text("This is a list of majors, minors & other requirements.")
                        Text("To add a major, click in this box or drag & drop from the major tab.")
                        Text("To move & remove majors, use drag & drop.")
                        onboardingButton(text: "Dismiss", show: false)
                    }
                    .font(.system(size: 23, weight: .light, design: .default))
                    .frame(width: 800)
                    .padding()
                }
            }.background(Rectangle().foregroundColor(.green).opacity(0.2))
        }
    }
    
    func onboardingButton(text: String, show: Bool) -> some View {
        Button(
            action: {
                setConcentrationOnboarding(show)
            },
            label: {
                Text(text).font(.headline)
            }
        )
    }
}
