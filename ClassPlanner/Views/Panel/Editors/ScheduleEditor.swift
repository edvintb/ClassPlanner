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
    
    @State private var isShowingOnboarding: Bool = false

//    private var courses: [Course] { Course.fromURIs(uri: Array(schedule.courseURLs), context: context) }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            EditorTypeView(editorName: "Schedule", infoTappedAction: { isShowingOnboarding = true }, createBackButton: { EmptyView() })
            EditorHeader(title: schedule.name, notes: schedule.notes, color: schedule.colorOption.color)
            Form {
                NameEditor(entryView: nameField)
                NoteEditor(text: $schedule.notes) {}
                EditorColorGrid { schedule.setColor(to: $0); }
                Section(header: sectionHeader) {
                    coursesView
                }
                Spacer()
                EditorButtons(deleteAction: deleteAction, closeAction: closeAction)
            }
            .padding(editorPadding)
        }
    }

    var nameField: some View {
        TextField("Name", text: $schedule.name, onCommit: { scheduleStore.setName(schedule.name, for: schedule) })
            .cornerRadius(textFieldCornerRadius)
            .alert(item: $scheduleStore.existingNameAlert) { nameString in
                Alert(title: Text("Naming Conflict"),
                      message: Text("Existing schedule with name: \(nameString.value) \nPlease pick another name."),
                      dismissButton: .default(Text("OK")))
            }
    }
    
    var sectionHeader: some View {
        VStack(spacing: 3) {
            HStack {
                Text("Semester").opacity(grayTextOpacity)
                Spacer()
                Text(workloadSymbol)
            }
            Divider()
            Spacer().frame(height: 5)
        }

    }

    var coursesView: some View {
        VStack(alignment: .leading, spacing: 10) {
            ForEach(schedule.semesters, id: \.self) { semester in
                HStack {
                    Text(semester % 2 == 0 ? fallSymbol : springSymbol)
                    ForEach (schedule.courses(for: semester)) { course in
                        Text(course.name)
                            .foregroundColor(course.colorOption.color)
                            .lineLimit(1)
                    }
                    Spacer()
                    Text("\(Int(schedule.courses(for: semester).reduce(into: 0) { $0 += $1.workload })) ")
                }
            }
        }
        .popover(isPresented: $isShowingOnboarding, content: {
            Text("This is an overview of the entire schedule").padding()
        })
    }
    
    func deleteAction() {
        shared.setEditSelection(to: .none)
        shared.setCurrentSchedule(to: nil)
        scheduleStore.deleteSchedule(schedule)
        shared.setPanelSelection(to: .schedules)
    }
    
    func closeAction() {
        shared.setEditSelection(to: .none)
        shared.setPanelSelection(to: .schedules)
    }
    
}


//    var noteEditor: some View {
//        HStack {
//            Text(" \(noteSymbol)")
//            ZStack {
//                if #available(OSX 11.0, *) {
//                    TextEditor(text: $schedule.notes)
//                        .cornerRadius(textFieldCornerRadius)
//                        .focusable()
//                } else {
//                    TextField("Notes...", text: $schedule.notes)
//                        .cornerRadius(textFieldCornerRadius)
//                        .focusable()
//                }
//            }
//        }
//    }
    
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

