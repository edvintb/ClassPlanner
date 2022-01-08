//
//  SettingsView.swift
//  ClassPlanner
//
//  Created by Edvin Berhan on 04.01.22.
//

import SwiftUI

enum School: Int, CaseIterable {
    
    case other
    case harvardCollege
    
    var description: String {
        switch self {
            case .other: return "Other"
            case .harvardCollege: return "Harvard College"
        }
    }
}

enum SchoolSystem: Int, CaseIterable {
    
    case semester
    case quarter
    
    var description: String {
        switch self {
            case .semester: return "Semester"
            case .quarter: return "Quarter"
        }
    }
}

struct SettingsView: View {
    
    @Environment(\.managedObjectContext) var context
    @EnvironmentObject var shared: SharedVM
    
    @State private var isLoaded: Bool = false
    @State private var isDeleting: Bool = false
    @State private var isDeletingOther: Bool = false
    
    var body: some View {
        VStack {
            if isLoaded {
                switch shared.currentSchool {
                    case .other: Text("Create your own courses by clicking in the schedule")
                    default: Text("\(shared.currentSchool.description) courses loaded")
                }
            }
            else if isDeletingOther {
                Text("Delete other courses from course editor")
            }
            loadCourseView
            HStack {
                chooseSystemView
                Stepper(value: $shared.semestersToShow, in: 2...30) {
                    Text("\(shared.semestersToShow) \(shared.isSemesterSystem ? "semesters" : "quarters")")
                }
            }
        }
        .padding()
        .alert(isPresented: $isDeleting, content: {
            Alert(title: Text("Are you sure?"),
                  message: Text(
                    "Deleting removes \(shared.currentSchool.description) courses completely.\nThey can be reloaded, but will disappear from any schedule."),
                  primaryButton:
                    .cancel({ self.isDeleting = false }),
                  secondaryButton:
                        .destructive(Text("OK"), action: { withAnimation { Course.deleteFromSchool(context: context, school: shared.currentSchool) }} )
                )
            }
        )
    }
    
    var loadCourseView: some View {
        HStack {
            Picker("", selection: $shared.currentSchool) {
                ForEach (School.allCases, id: \.self) { school in
                    Text(school.description)
                }
            }
            Button(action: loadCourses, label: { Text("Load Courses") })
            Button(action: deleteCourses, label: { Text("Delete Courses") })
        }
    }
    
    var chooseSystemView: some View {
        Picker("", selection: $shared.schoolSystem) {
            ForEach(SchoolSystem.allCases, id: \.self) { system in
                Text(system.description)
            }
        }
        .pickerStyle(.segmented)
    }
    
    func loadCourses() {
        switch shared.currentSchool {
        case .harvardCollege:
            parseCourseFile(
                courseFileArray: [
                    "undergraduate_courses_with_description",
                    "harvard_primarily_undergraduate"
                ],
                ratingFile: "harvard_qguide_with_year_cleaned",
                context: context,
                school: .harvardCollege
            )
            withAnimation {
                isLoaded = true
            }
        case .other:
            withAnimation {
                isLoaded = true
            }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            withAnimation {
                isLoaded = false
            }
        }
    }
    
    func deleteCourses() {
        if shared.currentSchool == .other {
            withAnimation {
                isDeletingOther = true
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                withAnimation {
                    isDeletingOther = false
                }
            }
        }
        else {
            isDeleting = true
        }
    }
}
