//
//  CourseAdderView.swift
//  ClassPlanner
//
//  Created by Edvin Berhan on 2021-03-22.
//

import SwiftUI
import CoreData

struct ScheduleEditorView: View {
    
    @EnvironmentObject var shared: SharedVM
    
    @ObservedObject var schedule: ScheduleVM
    
    // store needed to confirm name
    @ObservedObject var scheduleStore: ScheduleStore
//    @ObservedObject var courseStore: CourseStore

    @Environment(\.managedObjectContext) var context

//    private var courses: [Course] { Course.fromURIs(uri: Array(schedule.courseURLs), context: context) }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Spacer(minLength: 7)
            EditorTitleView(title: schedule.name).foregroundColor(schedule.color)
            Divider().padding(5)
            EditorNotes(notes: schedule.notes)
            Form {
                TextField("Name", text: $schedule.name, onCommit: {
                    scheduleStore.setName(schedule.name, for: schedule)
                }).cornerRadius(textFieldCornerRadius)
                .focusable(true) { print($0)}
                TextField("Notes...", text: $schedule.notes)
                    .cornerRadius(textFieldCornerRadius)
                    .focusable()
                Spacer(minLength: 12)
                coursesView
                // Make them all colorpickers for Big Sur
                Grid(Array(1..<Color.colorSelection.count), id: \.self) { index in
                    RoundedRectangle(cornerRadius: frameCornerRadius)
                        .onTapGesture { schedule.setColor(to: index) }
                        .foregroundColor(Color.colorSelection[index])
                        .padding(3)
                }
                bottomButtons
                
            }
//            .frame(width: editorWidth, height: editorHeight, alignment: .center)
            .padding()
            
        }
        
    }
    
    var nameField: some View {
        TextField("Name", text: $schedule.name, onEditingChanged: { _ in
            scheduleStore.setName(schedule.name, for: schedule)
        }).cornerRadius(textFieldCornerRadius)
    }
    
//    var coursesView: some View {
//        HStack {
//            VStack(alignment: .leading, spacing: 0) {
//                ForEach (0..<Int(courses.count/2))  { index in
//                    Text("- ") + Text(courses[index].name)
//                        .foregroundColor(viewModel.getColor(courses[index].color))
//                }
//            }
//            VStack(alignment: .leading, spacing: 0) {
//                ForEach (Int(courses.count/2)..<courses.count)  { index in
//                    Text("- ") + Text(courses[index].name)
//                        .foregroundColor(viewModel.getColor(courses[index].color))
//                }
//            }
//        }
//    }
    

    
    
    var noteEditor: some View {
        ZStack {
            if #available(OSX 11.0, *) {
                TextEditor(text: $schedule.notes)
            } else {
                TextField("Notes...", text: $schedule.notes)
                    .cornerRadius(textFieldCornerRadius)
            }
        }
    }

    var coursesView: some View {
        VStack(alignment: .leading, spacing: 10) {
            ForEach(schedule.semesters, id: \.self) { semester in
                HStack {
                    Text(semester % 2 == 0 ? fallSymbol : springSymbol)
                    ForEach (schedule.courses(for: semester)) { course in
                        Text(course.name)
                            .foregroundColor(course.getColor())
                            .lineLimit(1)
                    }
                    Spacer()
                    // Format to remove decimals -- what happens with 3 digits?
                    Text(workloadSymbol + " \(Int(schedule.courses(for: semester).reduce(into: 0) { $0 += $1.workload }))")
                        .frame(width: 45, alignment: .leading)
                        
                    
                }
            }
            
            
        }
    }
    
    var bottomButtons: some View {
        HStack {
            Button("Delete") {
                withAnimation {
                    // Only thing panel is needed for -- do we have to close to delete?
                    shared.setEditSelection(to: .none)
                    scheduleStore.removeSchedule(schedule)
                }
            }
            Spacer()
            Button("Close") {
                withAnimation {
                    shared.setEditSelection(to: .none)
                }
            }
        }
    }
}



// Put this in if we want to start searching courses from the editor

//
//    @State var startIndex: Int = 0
//    var showingCourses: [Course] { Array(courseStore.dbCourses[startIndex..<min(startIndex + 5, courseStore.dbCourses.count)]) }
//
//    var searchField: some View {
//        VStack(spacing: 10) {
//            Spacer(minLength: 5)
//            SearchTextField(query: $courseStore.courseQuery, placeholder: "Search for Courses...")
//            if showingCourses.count == 0 {
//                Text("No Results").opacity(0.2).frame(minWidth: /*@START_MENU_TOKEN@*/0/*@END_MENU_TOKEN@*/, maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, alignment: .leading)
//            }
//            else {
//                // Must be fixed
//                Spacer(minLength: 1)
//                Text("Courses")
//                Text("Click to Add").frame(minWidth: 50, maxWidth: .infinity, alignment: .trailing)
//                Divider()
//                Grid(showingCourses, desiredAspectRatio: 3) { course in
//                    Text(course.name)
//                }
//            }
//
//                Divider()
//            }.frame(height: 40 + CGFloat((showingCourses.count + 1) / 3) * 50, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
//    }

