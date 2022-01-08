//
//  ScheduleOnboarding.swift
//  ClassPlanner
//
//  Created by Edvin Berhan on 18.07.21.
//

import SwiftUI

struct WelcomeOnboarding: View {
    
    var setWelcomeOnboarding: (Bool, Bool) -> ()
    
    
    
    // Add the option to select a school here when we have school support
    var body: some View {
        VStack(spacing: 20) {
            Text("Welcome to the Class Schedule Planner!").font(.system(size: 30)).padding(.bottom, 15)
            screenDescriptionRectangle
            Text("The parts of the screen").opacity(grayTextOpacity)
//            Text("You will create your own courses & majors")
            SettingsView().padding(.horizontal, 40)
            Text("Press continue to start creating your plan!")
                .font(.system(size: 18, weight: .regular, design: .default))
            Button(
                action: {
                    setWelcomeOnboarding(false, true)
                },
                label: {
                    Text("Continue").font(.system(size: editorIconFontSize))
                }
            ).frame(maxWidth: .infinity, alignment: .trailing)
        }
        .padding()
    }
    
    let totalRectangleWidth: CGFloat = 250
    var rectangleScheduleWidth: CGFloat {
        2 * totalRectangleWidth / 3
    }
    let totalRectangleHeight: CGFloat = 170
    var rectangleScheduleHeight: CGFloat {
        2 * totalRectangleHeight / 3
    }
    
    var screenDescriptionRectangle: some View {
        HStack {
            Rectangle().stroke()
                .overlay(Text("Panel"))
            VStack {
                Rectangle().stroke()
                    .overlay(Text("Selected Schedule"))
                    .frame(height: rectangleScheduleHeight)
                Rectangle().stroke()
                    .overlay(Text("Majors & Other Requirements"))
            }
            .frame(width: rectangleScheduleWidth)
        }
        .frame(width: totalRectangleWidth, height: totalRectangleHeight)
    }
}


