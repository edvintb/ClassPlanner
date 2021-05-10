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
    
    @EnvironmentObject var course: Course
    @EnvironmentObject var viewModel: CourseVM
    @Environment(\.colorScheme) var colorScheme

    @Binding var isPresented: Bool
    private var color: Color { viewModel.getColor(course.color, dark: colorScheme == .dark) }
    
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
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Spacer(minLength: 15)
            title.frame(width: editorWidth, alignment: .leading)
            Divider().padding(5)
            notes.frame(width: editorWidth, alignment: .leading)
            // Add professor & prereqs
            // Suggestions as typed for prereq and professor
            // Multiline textfields for the others
            Form {
                TextField("Name", text: $course.name, onCommit: { save() })
                semesterSelector
                TextField("Workload", value: $course.workload, formatter: numberFormatter, onCommit: { save() })
                TextField("QScore", value: $course.qscore, formatter: numberFormatter, onCommit: { save() })
                TextField("Enrollment", value: $course.enrollment, formatter: numberFormatter, onCommit: { save() })
                noteEditor
                colorGrid
                bottomButtons
            }
            .frame(width: editorWidth, height: editorHeight, alignment: .center)
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
            .fixedSize(horizontal: false, vertical: true)
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
    
    var noteEditor: some View {
        ZStack {
            if #available(OSX 11.0, *) {
                TextEditor(text: $course.notes)
            } else {
                TextField("Notes...", text: $course.notes, onCommit: { save() })
            }
        }
    }
    

    
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
            Button("Delete") {
                withAnimation {
                    self.isPresented = false
                    viewModel.deleteCourse(course)
                }
            }
            Spacer()
            Button("Save") {
                withAnimation { self.isPresented = false; save() }
            }
        }
//        Text("+").font(.title)
//            .rotationEffect(Angle(degrees: 45))
//            .foregroundColor(.red)
//            .onTapGesture {
//                self.isPresented = false
//                viewModel.deleteCourse(course)
//            }
    }
    
    var numberFormatter: NumberFormatter {
        let numberFormatter = NumberFormatter()
        numberFormatter.maximumSignificantDigits = 3
        numberFormatter.roundingMode = .ceiling
        numberFormatter.zeroSymbol = ""
        return numberFormatter
    }
    
    func save() {
        if let context = course.managedObjectContext {
            do {
                course.objectWillChange.send()
                try context.save()
            } catch {
                print("Unexpected Error: \(error)")
            }
        }
    }
    
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


