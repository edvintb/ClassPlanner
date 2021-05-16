//
//  CourseAdderView.swift
//  ClassPlanner
//
//  Created by Edvin Berhan on 2021-03-22.
//

import SwiftUI
import CoreData

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
    
    @ObservedObject var course: Course
    @EnvironmentObject var viewModel: CourseVM
    @Environment(\.colorScheme) var colorScheme

    private var color: Color { viewModel.getColor(course.color, dark: colorScheme == .dark) }
    

    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Spacer(minLength: 7)
            title
//                .frame(width: editorWidth, alignment: .leading)
            Divider().padding(5)
            notes
//                .frame(width: editorWidth, alignment: .leading)
            // Add professor & prereqs & Grade
            // Suggestions as typed for prereq and professor
            // Multiline textfields for the others
            // Add concentrations it is part of
            // Ability to add to categories?? Search and click concentrations to expand
            Form {
                TextField("Name", text: $course.name, onCommit: { save() }).cornerRadius(textFieldCornerRadius)
                semesterSelector
                workloadEntry
                qscoreEntry
                enrollmentEntry
                noteEditor
                colorGrid
                bottomButtons
            }
//            .frame(width: editorWidth, height: editorHeight, alignment: .center)
            .padding()
            
        }

    }
    
    var title: some View {
        let emptyName = course.name == ""
        return Text(emptyName ? "Name" : course.name)
            .font(.system(size: 20))
            .foregroundColor(color)
            .opacity(emptyName ? 0.2 : 1)
            .lineLimit(2)
            .fixedSize(horizontal: false, vertical: true)
            .padding([.horizontal], 15)
            
    }

    
    var notes: some View {
        let emptyNotes = course.notes == ""
        return Text(emptyNotes ? "Notes..." : course.notes)
            .font(.system(size: 12))
            .opacity(emptyNotes ? 0.2 : 0.5)
            .lineLimit(nil)
            .fixedSize(horizontal: false, vertical: false)
            .padding([.horizontal], 10)

    }
    
    var semesterSelector: some View {
        HStack(alignment: .center, spacing: 10) {
            Spacer()
            Button(action: { course.fall.toggle(); save() }, label: {
                Text("🍁")
                    .shadow(color: course.fall ? .green : .black, radius: /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)
            })
            Button(action: { course.spring.toggle(); save() }, label: {
                Text("🌱")
                    .shadow(color: course.spring ? .green : .black, radius: /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)
            })
            Spacer()
        }
    }
    
    var workloadEntry: some View {
        HStack {
            Text(" \(workloadSymbol)")
            DoubleTextField("Workload", double: $course.workload, onCommit: { save() })
                .cornerRadius(textFieldCornerRadius)
        }
    }
    
    var qscoreEntry: some View {
        HStack {
            Text("  \(qscoreSymbol) ").foregroundColor(.red).font(.system(size: 14.5))
            DoubleTextField("QScore", double: $course.qscore, onCommit: { save() })
                .cornerRadius(textFieldCornerRadius)
        }
    }
    
    var enrollmentEntry: some View {
        HStack {
            Text(" \(enrollmentSymbol)")
            IntTextField("Enrollment", integer: $course.enrollment, onCommit: { save() })
                .cornerRadius(textFieldCornerRadius)
        }
    }
    
    var noteEditor: some View {
        HStack {
            Text(" \(noteSymbol)")
            ZStack {
                if #available(OSX 11.0, *) {
                    TextEditor(text: $course.notes)
                        .cornerRadius(textFieldCornerRadius)
                } else {
                    TextField("Notes...", text: $course.notes, onCommit: { save() })
                        .cornerRadius(textFieldCornerRadius)
                }
            }
        }

    }
        
    var colorGrid: some View {
        Grid(Array(1..<viewModel.colors.count), id: \.self) { index in
            RoundedRectangle(cornerRadius: frameCornerRadius)
            .foregroundColor(viewModel.colors[index])
            .onTapGesture { course.color = index; save(); print(course.color) }
            .padding(3)
        }
    }
    
    
    var bottomButtons: some View {
        HStack {
            Spacer()
            Button("Delete") {
                withAnimation {
                    viewModel.stopEdit()
                    viewModel.deleteCourse(course)
                    save()
                }
            }
            Spacer()
            if course.semester > 0 {
                Button("Remove from Schedule") {
                    withAnimation {
                        course.moveToSemester(0, and: 0)
                        save()
                    }
                }
            }
            else {
                Button("Add to Schedule") {
                    withAnimation {
                        course.moveToSemester(1, and: 0)
                        save()
                    }
                }
            }
        }

    }
    
    func save() {
        if let context = course.managedObjectContext {
            do {
                course.objectWillChange.send()
                try context.save()
            } catch {
                print("Unexpected Error when saving in CourseEditor: \(error)")
            }
        }
    }
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


