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
    
    @EnvironmentObject var viewModel: CourseVM
    @Environment(\.managedObjectContext) var context
    @Binding var isPresented: Bool
    @ObservedObject var course: Course

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
        ZStack {
            Text(course.name)
            deleteButton.frame(minWidth: /*@START_MENU_TOKEN@*/0/*@END_MENU_TOKEN@*/, maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, minHeight: /*@START_MENU_TOKEN@*/0/*@END_MENU_TOKEN@*/, maxHeight: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, alignment: .topLeading)
                .padding([.horizontal], 8)
        }
        // Add notes, color, professor, prereqs
        // Suggestions as typed for prereq and professor
        // Multiline textfields for the others
        Form {
            TextField("Name", text: $course.name, onCommit: { try? context.save() })
            HStack(alignment: .center, spacing: 10) {
                Spacer()
                Toggle(isOn: $course.fall) { Text("🍁") }
                Toggle(isOn: $course.spring) { Text("🌱") }
                Spacer()
            }
            TextField("Workload", value: $course.workload, formatter: numberFormatter, onCommit: { try? context.save() })
            TextField("Enrollment", value: $course.enrollment, formatter: numberFormatter, onCommit: { try? context.save() })
            TextField("QScore", value: $course.qscore, formatter: numberFormatter, onCommit: { try? context.save() })
            
        }
        .frame(width: 200, height: 300, alignment: .center)
        .padding()
    }
    
    var deleteButton: some View {
        Text("+").font(.title)
            .rotationEffect(Angle(degrees: 45))
            .foregroundColor(.red)
            .onTapGesture {
                self.isPresented = false
                viewModel.deleteCourse(course)
            }
    }
    
    var numberFormatter: NumberFormatter {
        let numberFormatter = NumberFormatter()
        numberFormatter.maximumSignificantDigits = 3
        numberFormatter.roundingMode = .ceiling
        numberFormatter.zeroSymbol = ""
        return numberFormatter
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


