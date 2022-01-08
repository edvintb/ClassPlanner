//
//  DrawingConstants.swift
//  ClassPlanner
//
//  Created by Edvin Berhan on 2021-05-02.
//

import Foundation
import SwiftUI

// MARK: - Drawing Constants
let frameCornerRadius: CGFloat = 10
let textFieldCornerRadius: CGFloat = 3.0

// Fonts
let titleSize: CGFloat = 15
let courseIconSize: CGFloat = 14
let categoryCourseFontSize: CGFloat = 12
let categoryCourseFont: Font = .system(size: categoryCourseFontSize)
let onboardingTextFont: Font = .system(size: 17)
let editorIconFontSize: CGFloat = 15

// Hovering
let hoverScaleFactor: CGFloat = 1.03
let hoverShadowRadius: CGFloat = 3

// Padding & Spacing
let semesterPadding: CGFloat = 5
let courseVerticalSpacing: CGFloat = 7
let courseHorizontalSpacing: CGFloat = 6
let horizontalBackPadding: CGFloat = 7
let courseBackSpacing: CGFloat = 2.5
let editorPadding: CGFloat = 7
let topSectionStackSpacing: CGFloat = 7
let topSectionPadding: CGFloat = 8

// Opacities
let emptyHoverOpacity: Double = 0.2
let emptyOpacity: Double = 0.2
let grayTextOpacity: Double = 0.4
let transparentTextOpacity: Double = 0.2


// Width & Height
let courseHeight: CGFloat = 100
let courseWidth: CGFloat = 135
let concentrationHeight: CGFloat = 1.4*courseHeight
let concentrationsMinHeight: CGFloat = 150
let categoryWidth: CGFloat = 120
let editorWidth: CGFloat = 300
let scheduleMinHeight: CGFloat = 400
let panelScheduleHeight: CGFloat = 50
let editorColorGridHeight: CGFloat = 35
let mainMinWidth: CGFloat = 1000
let topSectionheight: CGFloat = 35

// Colors
let checkMarkColor: Color = Color(r: 69, g: 206, b: 162)

// Number formatting
let maxIntegers: Int = 3
let maxDecimals: Int = 2
let maxSignificant: Int = 3

// Animation
let quickAnimation = Animation.easeInOut(duration: 0.2)


// Checking operating system
var isCatalina: Bool {
    if #available(macOS 11.0, *) { return false }
    else { return true }
}

// Symbols
let professorSymbol: String = isCatalina ? "🤓" : "🥸"
let dateSymbol: String = "📆"
let enrollmentSymbol: String = "👥"
let qscoreSymbol: String = "⭐️"//"𝗤"
let workloadSymbol: String = "🕑"
let noteSymbol: String = "🗒"
let fallSymbol: String = "🍁"
let springSymbol: String = "🌱"
let gradeSymbol: String = "🎓"
let gradeSymbolSize: CGFloat = 17
let nameSymbol: String = "💬" // "􀌮" 
let numberRequiredSymbol: String = "  # "
let courseContainedSymbol: String = "✓"
let implicationArrow: String = "→"

// User defaults keys
let contentViewPopoverKey = "contentViewPopOverKey"
let oldWelcomeOnboardingKey = "welcomeOnboardingKey"
let welcomeOnboardingKey = "welcomeOnboardingKey1"
let courseEditorOnboardingKey = "courseEditorOnboardingKey"
let concentrationOnboardingKey = "concentrationOnboardingKey"
let concentrationEditorOnboardingKey = "categoryOnboardingKey"
let semesterTopOnboardingKey = "semesterTopOnboardingKey"
let completedSemesterKey = "completedSemesterKey"
let currentScheduleKey = "currentScheduleKey"

let schoolSystemKey = "schoolSystemKey"
let semestersToShowKey = "semestersToShowKey"
let currentSchoolKey = "currentSchoolKey"
let courseLengthKey = "courseLengthKey"
let weekStartTimeKey = "weekStartTimeKey"
let weekStopTimeKey = "weekStopTimeKey"

// Start time for date
let startTime: Double = 82800
