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
struct CategoryEditorView: View {
    
    @EnvironmentObject var category: Category
    @EnvironmentObject var viewModel: CourseVM
    @Environment(\.colorScheme) var colorScheme

    @Binding var isPresented: Bool
    private var color: Color {
        category.color != 0 ? viewModel.colors[category.color] :
            colorScheme == .dark ? .white : .black
    }
    
    private var courses: [Course] { category.courses.sorted { $0.name < $1.name } }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Spacer(minLength: 15)
            title.frame(width: editorWidth, alignment: .leading)
            Divider().padding([.horizontal, .vertical], 5)
            notes.frame(width: editorWidth, alignment: .leading)
            Form {
                TextField("Name", text: $category.name, onCommit: { save() })
                TextField("# Required", value: $category.numberOfRequired, formatter: numberFormatter, onCommit: { save() })
                noteEditor
                coursesView
                Grid(Array(1..<viewModel.colors.count), id: \.self) { index in
                    RoundedRectangle(cornerRadius: frameCornerRadius)
                        .onTapGesture { category.color = index; save() }
                        .foregroundColor(viewModel.colors[index])
                        .padding(3)
                }
                bottomButtons
                
            }
            .frame(width: editorWidth, height: editorHeight, alignment: .center)
            .padding()
            
        }

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
    
    var coursesView: some View {
        Grid (courses, desiredAspectRatio: 2) { course in
            ZStack {
                Text(course.name)
                    .foregroundColor(viewModel.getColor(course.color, dark: colorScheme == .dark))
            }
        }
    }
    
    var title: some View {
        let emptyName = category.name == ""
        return Text(emptyName ? "Name" : category.name)
            .font(.system(size: 20))
            .foregroundColor(color)
            .opacity(emptyName ? 0.2 : 1)
            .lineLimit(2)
            .fixedSize(horizontal: false, vertical: true)
            .padding([.horizontal], 5)
    }
    
    var notes: some View {
        let emptyNotes = category.notes == ""
        return Text(emptyNotes ? "Notes..." : category.notes)
            .font(.system(size: 12))
            .opacity(emptyNotes ? 0.2 : 0.5)
            .lineLimit(nil)
            .fixedSize(horizontal: false, vertical: true)
            .padding([.horizontal], 5)
    }
    
    var noteEditor: some View {
        ZStack {
            if #available(OSX 11.0, *) {
                TextEditor(text: $category.notes)
            } else {
                TextField("Notes...", text: $category.notes, onCommit: { save() })
            }
        }
    }
    
    var bottomButtons: some View {
        HStack {
            Button("Delete") {
                withAnimation {
                    self.isPresented = false
                    viewModel.deleteCategory(category)
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
        if let context = category.managedObjectContext {
            do {
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


