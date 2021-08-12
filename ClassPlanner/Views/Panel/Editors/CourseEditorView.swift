//
//  CourseAdderView.swift
//  ClassPlanner
//
//  Created by Edvin Berhan on 2021-03-22.
//

import SwiftUI
import CoreData
import Combine

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
    @ObservedObject var prereqSuggestionVM: PrereqSuggestionVM
    @ObservedObject var searchModel: SearchModel
    @ObservedObject var prereqSearchModel: SearchModel
    
    private var isCatalina: Bool {
        if #available(macOS 11.0, *) { return true }
        else { return false }
    }
//
    @Binding private var isShowingOnboarding: Bool
    private func setCourseEditorOnboarding(show: Bool) {
        withAnimation {
            self.isShowingOnboarding = show
            UserDefaults.standard.setValue(!show, forKey: courseEditorOnboardingKey)
        }
    }
    
    init(course: Course,
         courseSuggestionVM: CourseSuggestionVM,
         prereqSuggestionVM: PrereqSuggestionVM,
         context: NSManagedObjectContext,
         isShowingOnboarding: Binding<Bool>) {
        
        self.courseSuggestionVM = courseSuggestionVM
        self.prereqSuggestionVM = prereqSuggestionVM
        self.course = course
        self._isShowingOnboarding = isShowingOnboarding
    
        // Okay to create search model here
        self.searchModel = SearchModel(startingText: course.name, context: context, avoid: course.objectID)
        
        self.prereqSearchModel = SearchModel(startingText: "", context: context, avoid: course.objectID)

        // Updating the name of the course as we type it in
        searchModel.$currentText
            .removeDuplicates()
            .assign(to: \.course.name, on: self)
            .store(in: &cancellables)
        
    }
    
    @State private var monday: Bool = false
    @State private var tuseday: Bool = false
    @State private var wednesday: Bool = false
    @State private var thursday: Bool = false
    @State private var friday: Bool = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            EditorHeader(title: course.name, notes: course.notes, color: course.getColor())
            // Add professor?
            GeometryReader { geo in
                Form {
                    NameEditor(entryView: nameField)
                    semesterSelector
                    dataEntryFields
                    NoteEditor(text: $course.notes) { course.save() }
                    dayAndDaySelector(size: geo.size)
                    gradeSelector
                    HStack {
                        prereqView
                        concentrationView
                    }
                    EditorColorGrid { course.color = $0; course.save() }
                    bottomButtons
                }
                .padding(editorPadding)
            }

        }
//        .background(KeyEventHandling(course: self.course, schedule: shared.currentSchedule))
        
    }
    
    
    
    func dayAndDaySelector(size: CGSize) -> some View {
        HStack(spacing: 0) {
            Text(" \(dateSymbol)")
            Spacer()
            Button("Mon", action: { monday.toggle() })
                .opacity(monday ? 1 : 0.51)
            Button("Tue", action: { tuseday.toggle() })
                .opacity(tuseday ? 1 : 0.51)
            Button("Wed", action: { wednesday.toggle() })
                .opacity(wednesday ? 1 : 0.51)
            Button("Thu", action: { thursday.toggle() })
                .opacity(thursday ? 1 : 0.51)
            Button( action: { friday.toggle() }, label: { Text("Fri").frame(maxWidth: .infinity) })
                .opacity(friday ? 1 : 0.51)
            Spacer()
            DatePicker("Course Time", selection: $course.time, displayedComponents: .hourAndMinute)
                .labelsHidden()
                .frame(width: size.width / 5)
        }
        .buttonStyle(DefaultButtonStyle())
        .padding(.vertical, 5)
    }
    
    var nameField: some View {
        SuggestionInput(text: $searchModel.currentText,
                        suggestionGroups: searchModel.suggestionGroups,
                        suggestionModel: courseSuggestionVM.suggestionModel)
            .focusable()
            .popover(isPresented: $isShowingOnboarding, content: {
                CourseEditorOnboarding(isShowingOnboarding: $isShowingOnboarding, setCourseEditorOnboarding: setCourseEditorOnboarding)
            })
    }
    
    var semesterSelector: some View {
        HStack(alignment: .center, spacing: 10) {
            Spacer()
            Toggle(fallSymbol, isOn: $course.fall)
            Spacer()
            Toggle(springSymbol, isOn: $course.spring)
            Spacer()
        }
        .padding(.vertical, 4)
    }

    var dataEntryFields: some View {
        Form {
            workloadEntry
            qscoreEntry
            enrollmentEntry
        }
        .cornerRadius(textFieldCornerRadius)
    }
    
    var workloadEntry: some View {
        HStack {
            Text(" \(workloadSymbol)")
            DoubleTextField("Workload", double: $course.workload, onCommit: { save() })
                .cornerRadius(textFieldCornerRadius)
                .focusable()
        }
    }
    
    var qscoreEntry: some View {
        HStack {
            Text(" \(qscoreSymbol)") // .foregroundColor(.red).font(.system(size: 14.5))
            DoubleTextField("Rating", double: $course.qscore, onCommit: { save() })
                .cornerRadius(textFieldCornerRadius)
                .focusable()
        }
    }
    
    var enrollmentEntry: some View {
        HStack {
            Text(" \(enrollmentSymbol)")
            IntTextField("Enrollment", integer: $course.enrollment, onCommit: { save() })
                .cornerRadius(textFieldCornerRadius)
                .focusable()
        }
    }
    
    var gradeSelector: some View {
        Picker("", selection: $course.grade) {
            ForEach(Grade.allCases, id: \.self) { grade in
                Text(Grade.gradeString[grade] ?? "")
                    .foregroundColor(Grade.color[grade])
                    .tag(grade.id)
            }
        }.pickerStyle(SegmentedPickerStyle())
    }
    
    var prereqView: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack {
                Text("Prerequisites")
                    .opacity(grayTextOpacity)
                    .frame(maxWidth: .infinity, alignment: .leading)
                shared.currentSchedule?.containsPrereqs(for: course) ?? Text("-")
            }
            Spacer().frame(height: 8)
            SuggestionInput(text: $prereqSearchModel.currentText,
                            suggestionGroups: prereqSearchModel.suggestionGroups,
                            suggestionModel: prereqSuggestionVM.suggestionModel)
                .focusable()
                .padding(.bottom, 5)
            ScrollView(showsIndicators: isCatalina) {
                ForEach(course.nameSortedPrereqs, id: \.self) { prereq in
                    HStack {
                        Text(prereq.name.isEmpty ? "No name" : prereq.name)
                            .foregroundColor(prereq.getColor())
                        Spacer()
                        if course.isPrereqSatisfied(prereq: prereq, schedule: shared.currentSchedule) {
                            Text(courseContainedSymbol)
                                .foregroundColor(checkMarkColor)
                        }
                    }
                    .padding(.bottom, 3)
                    .contentShape(Rectangle())
                    .onTapGesture {
                        withAnimation {
                            course.removePrereq(prereq: prereq)
                        }
                    }
                }
            }
            Spacer()
        }
    }
    
    var concentrationView: some View {
        HStack {
            Divider()
            VStack(alignment: .leading, spacing: 0) {
                Text("Majors")
                    .opacity(grayTextOpacity)
                    .padding(.bottom, 3)
                Divider()
                    .padding(.vertical, 3)
                ScrollView(showsIndicators: isCatalina){
                    ForEach(course.nameSortedConcentrations, id: \.self) { concentration in
                        Text(concentration.name.isEmpty ? "Unknown" : concentration.name)
                            .foregroundColor(concentration.getColor())
                            .padding(.bottom, 3)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                }
                Spacer()
            }
            Spacer()
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
        if schedule.courseUrlSet.contains(course.urlID) {
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
    //
    //struct KeyEventHandling: NSViewRepresentable {
    //
    //    let course: Course
    //    let schedule: ScheduleVM?
    //
    //    class KeyView: NSView {
    //
    //        override var acceptsFirstResponder: Bool { true }
    //        override func keyDown(with event: NSEvent) {
    ////            super.keyDown(with: event)
    //            print(event)
    //            print(">> key \(event.charactersIgnoringModifiers ?? "")")
    //            if event.keyCode == 51 {
    //                print("Deleting...")
    //            }
    //        }
    //    }
    //
    //    func makeNSView(context: Context) -> NSView {
    //        let view = KeyView()
    //        DispatchQueue.main.async { // wait till next event cycle
    //            view.window?.makeFirstResponder(view)
    //        }
    //        return view
    //    }
    //
    //    func updateNSView(_ nsView: NSView, context: Context) {
    //    }
    //}
    
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


