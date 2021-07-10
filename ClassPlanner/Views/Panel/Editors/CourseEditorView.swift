//
//  CourseAdderView.swift
//  ClassPlanner
//
//  Created by Edvin Berhan on 2021-03-22.
//

import SwiftUI
import CoreData
import Combine

//struct CourseInfo {
//
//    var name: String
//    var workload: String
//    var enrollment: String
//    var semester: Int
//    var score: String
//    var notes: String
//    var fall: Bool
//    var spring: Bool
//
//    init(_ semester: Int) {
//        name = ""
//        workload = ""
//        enrollment = ""
//        self.semester = semester
//        score = ""
//        notes = ""
//        fall = false
//        spring = false
//    }
//}


// Create separate viewModel for this view??


// Perhaps have a state-course instead and pass in a Course.empty as an argument?
// Then we can bind to it with our TextFields and have what we write show up at once
struct CourseEditorView: View {
    
    // Needed to stop editing
    @EnvironmentObject var shared: SharedVM
    @ObservedObject var course: Course
    
    // Storing course name subscription
    private var cancellables = Set<AnyCancellable>()
    
    @ObservedObject var courseSuggestionVM: CourseSuggestionVM

    // Okay to create here bc this view does not get redrawn
    @ObservedObject var searchModel: SearchModel
    
    init(course: Course, courseSuggestionVM: CourseSuggestionVM, context: NSManagedObjectContext) {
        self.courseSuggestionVM = courseSuggestionVM
        self.course = course
        
        // Okay to create search model here
        self.searchModel = SearchModel(startingText: course.name, context: context, avoid: course.objectID)

        // Updating the name of the course as we type it in
        searchModel.$currentText
            .removeDuplicates()
            .assign(to: \.course.name, on: self)
            .store(in: &cancellables)
    }

    private var color: Color { course.getColor() }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            EditorHeader(title: course.name, notes: course.notes, color: course.getColor())
            // Add professor & prereqs & Grade
            // Suggestions as typed for prereq and professor
            // Multiline textfields for the others
            // Add concentrations it is part of
            // Ability to add to categories?? Search and click concentrations to expand
            // Adding grades into it
            Form {
                NameEditor(entryView: nameField)
                semesterSelector
                workloadEntry
                qscoreEntry
                enrollmentEntry
                NoteEditor(text: $course.notes) { course.save() }
                gradeSelector
                EditorColorGrid { course.color = $0; course.save() }
                bottomButtons
            }
            .padding(editorPadding)
        }
        
    }
    
    var nameField: some View {
        SuggestionInput(text: $searchModel.currentText,
                        suggestionGroups: searchModel.suggestionGroups,
                        suggestionModel: courseSuggestionVM.suggestionModel)

    }
    
    var semesterSelector: some View {
        HStack(alignment: .center, spacing: 10) {
            Spacer()
            Toggle(fallSymbol, isOn: $course.fall)
            Spacer()
            Toggle(springSymbol, isOn: $course.spring)
            Spacer()
        }
    }

    //            Button(action: { course.fall.toggle(); save() }, label: {
    //                Text("🍁")
    //                    .shadow(color: course.fall ? .green : .black, radius: /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)
    //            })
    //            Button(action: { course.spring.toggle(); save() }, label: {
    //                Text("🌱")
    //                    .shadow(color: course.spring ? .green : .black, radius: /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)
    //            })
    
    var gradeSelector: some View {
        Picker("", selection: $course.grade) {
            ForEach(Grade.allCases, id: \.self) { grade in
                Text(Grade.gradeString[grade] ?? "")
                    .foregroundColor(Grade.color[grade])
                    .tag(grade.id)
            }
        }.pickerStyle(SegmentedPickerStyle())
    }
    
    
    var workloadEntry: some View {
        HStack {
            Text(" \(workloadSymbol)")
            DoubleTextField("Workload", double: $course.workload, onCommit: { save() })
                .cornerRadius(textFieldCornerRadius)
//                .focusable()
        }
    }
    
    var qscoreEntry: some View {
        HStack {
            Text("  \(qscoreSymbol) ").foregroundColor(.red).font(.system(size: 14.5))
            DoubleTextField("QScore", double: $course.qscore, onCommit: { save() })
                .cornerRadius(textFieldCornerRadius)
//                .focusable()
        }
    }
    
    var enrollmentEntry: some View {
        HStack {
            Text(" \(enrollmentSymbol)")
            IntTextField("Enrollment", integer: $course.enrollment, onCommit: { save() })
                .cornerRadius(textFieldCornerRadius)
//                .focusable()
        }
    }
    
    
    
    var bottomButtons: some View {
        HStack {
            EditorButtons(deleteAction: deleteAction, closeAction: closeAction)
            Spacer()
            if let schedule = shared.currentSchedule {
                addRemoveButton(schedule: schedule)
            }
        }
    }
    
    func closeAction() {
        shared.stopEdit()
        shared.setPanelSelection(to: .courses)
    }
    
    
    func deleteAction() {
        if let schedule = shared.currentSchedule {
            schedule.removeCourse(course)
            shared.stopEdit()
            course.delete()
            course.save()
            shared.setPanelSelection(to: .courses)
        }
    }
    
    
    func addRemoveButton(schedule: ScheduleVM) -> some View {
        if schedule.courseURLs.contains(course.urlID) {
            return
                Button("Remove from current") {
                    withAnimation {
                        schedule.removeCourse(course)
                        if course.isEmpty {
                            shared.stopEdit()
                            course.delete()
                        }
                        course.save()
                    }
                }
        }
        else {
            return
                Button("Add to current") {
                    let newPos = CoursePosition(semester: 0, index: 0)
                    withAnimation {
                        schedule.addCourse(course, at: newPos)
                        course.save()
                    }
                }
        }
    }
    
    
    
    func save() {
        course.save()
    }
    
    
    //    var icons: some View {
    //        VStack {
    //            Text(" \(workloadSymbol)")
    //            Text("  \(qscoreSymbol) ").foregroundColor(.red).font(.system(size: 14.5))
    //            Text(" \(enrollmentSymbol)")
    //        }
    //    }
    
    
    //    init(_ course: Course, to semester: Int, at position: Int, _ isPresented: Binding<Bool>) {
    //        _isPresented = isPresented
    //        course.position = position
    //        course.semester = semester
    //        _draft = ObservedObject(wrappedValue: course)
    //    }
        
    //    init (_ course: Course, _ isPresented: Binding<Bool>) {
    //        _isPresented = isPresented
    //        _course = ObservedObject(wrappedValue: course)
    //    }
        
    //    @State var typedSeparator: Bool = false

    //    var qscoreProxy: Binding<String> {
    //        Binding<String>(
    //            get: {
    //                if course.qscore == 0 { return "" }
    //                return ((viewModel.numberFormatter.string(from: NSNumber(value: course.qscore)) ?? "")
    //                            + (typedSeparator ? (Locale.current.decimalSeparator ?? "") : ""))
    //            },
    //            set: {
    //                if $0 == "" { course.qscore = 0; return }
    //                var string = $0.filter { $0.isNumber }
    //                if let index = $0.firstIndex(where: { char in char == "." || char == "," }) {
    //                    string.insert(contentsOf: (Locale.current.decimalSeparator ?? ""), at: index)
    //                    if string.last == "." || string.last == "," {
    //                        typedSeparator = true
    //                        print("Setting separtor to \(typedSeparator)")
    //                        string.removeLast(1)
    //                    }
    //                    else { typedSeparator = false }
    //                }
    //                else { typedSeparator = false }
    //                if let value = viewModel.numberFormatter.number(from: string) {
    //                    course.qscore = value.doubleValue
    //                }
    //                else {
    //                    print("Could not convert value: \(string)")
    //                }
    //            }
    //        )
    //    }

        
    //
    //    var toNumber: NumberFormatter {
    //        let formatter = NumberFormatter()
    //        formatter.localizesFormat = false
    //        return formatter
    //    }
    //
    //    @State private var qscore: String?
    
    //        Text("+").font(.title)
    //            .rotationEffect(Angle(degrees: 45))
    //            .foregroundColor(.red)
    //            .onTapGesture {
    //                self.isPresented = false
    //                viewModel.deleteCourse(course)
    //            }
    
//    var colorGrid: some View {
//        Grid(Array(0..<viewModel.colors.count), id: \.self) { index in
//            ZStack {
//                if index == 0 { RoundedRectangle(cornerRadius: frameCornerRadius).stroke().opacity(0.2).contentShape(Rectangle()) }
//                else { RoundedRectangle(cornerRadius: frameCornerRadius).foregroundColor(viewModel.colors[index]) }
//            }
//            .onTapGesture { course.color = index; save(); print(course.color) }
//            .padding(3)
//
//        }
//    }
//    var cancel: some View {
//        Button("Cancel") {
//            self.isPresented = false
//        }
//    }
//    
//    var done: some View {
//        Button("Done") {
////            if self.draft.destination != self.flightSearch.destination {
////                self.draft.destination.fetchIncomingFlights()
////            }
////            self.flightSearch = self.draft
//            self.isPresented = false
//        }
//    }
    
}


