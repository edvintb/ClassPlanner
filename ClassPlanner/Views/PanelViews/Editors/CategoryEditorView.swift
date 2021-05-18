//
//  CourseAdderView.swift
//  ClassPlanner
//
//  Created by Edvin Berhan on 2021-03-22.
//

import SwiftUI
import CoreData

struct CategoryEditorView: View {
    
    @ObservedObject var category: Category
    @ObservedObject var courseStore: CourseStore
//    @EnvironmentObject var viewModel: ScheduleVM
    @Environment(\.colorScheme) var colorScheme


//    @Binding var isPresented: Bool
    
    private var color: Color { courseStore.getColor(category.color, dark: colorScheme == .dark) }
    private var courses: [Course] { category.courses.sorted { $0.name < $1.name } }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Spacer(minLength: 7)
            EditorTitleView(title: category.name).foregroundColor(color)
            Divider().padding(5)
            EditorNotes(notes: category.notes)
            Form {
                TextField("Name", text: $category.name, onCommit: { save() }).cornerRadius(textFieldCornerRadius)
                // Bug when not writing anything / removing everything -- check for other formatted fields
                IntTextField("# Required", integer: $category.numberOfRequired, onCommit: { save() })
                noteEditor
                Spacer(minLength: 12)
                searchField
                Spacer(minLength: 12)
                coursesView
                // Make them all colorpickers for Big Sur
                Grid(Array(1..<courseStore.colors.count), id: \.self) { index in
                    RoundedRectangle(cornerRadius: frameCornerRadius)
                        .onTapGesture { category.color = index; save() }
                        .foregroundColor(courseStore.colors[index])
                        .padding(3)
                }
                bottomButtons
                
            }
//            .frame(width: editorWidth, height: editorHeight, alignment: .center)
            .padding()
            
        }

    }
    
    var requiredField: some View {
        HStack {
            Text(" \(enrollmentSymbol)")
            IntTextField("# Required", integer: $category.numberOfRequired, onCommit: { save() })
                .cornerRadius(textFieldCornerRadius)
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
    

    
    
    var noteEditor: some View {
        ZStack {
            if #available(OSX 11.0, *) {
                TextEditor(text: $category.notes)
            } else {
                TextField("Notes...", text: $category.notes, onCommit: { save() })
            }
        }
    }
    
    @State var startIndex: Int = 0
    var showingCourses: [Course] { Array(courseStore.foundCourses[startIndex..<min(startIndex + 5, courseStore.foundCourses.count)]) }
    
    var searchField: some View {
        VStack(spacing: 10) {
            Spacer(minLength: 5)
            SearchTextField(query: $courseStore.courseQuery, placeholder: "Search for Courses...")
            if showingCourses.count == 0 {
                Text("No Results").opacity(0.2).frame(minWidth: /*@START_MENU_TOKEN@*/0/*@END_MENU_TOKEN@*/, maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, alignment: .leading)
            }
            else {
                Spacer(minLength: 1)
                Text("Courses")
                Text("Click to add").frame(minWidth: 50, maxWidth: .infinity, alignment: .trailing)
                Divider()
                Grid(showingCourses, desiredAspectRatio: 3) { course in
                    Text(course.name)
                }
            }

                Divider()
            }.frame(height: 40 + CGFloat((showingCourses.count + 1) / 3) * 50, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
    }
    
    var coursesView: some View {
        Grid (courses, desiredAspectRatio: 2) { course in
            HStack {
                Text(course.name == "" ? "No name" : course.name)
//                    .foregroundColor(viewModel.getColor(course.color, dark: colorScheme == .dark))
                    .contentShape(Rectangle())
                    .onTapGesture { category.removeCourse(course) }
            }
        }.frame(width: editorWidth, height: CGFloat(courses.count) * 20, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
    }
    
    var bottomButtons: some View {
        HStack {
//            Button("Delete") {
//                withAnimation {
//                    self.isPresented = false
//                    viewModel.deleteCategory(category)
//                }
//            }
//            Spacer()
//            Button("Save") {
//                withAnimation { self.isPresented = false; save() }
//            }
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


