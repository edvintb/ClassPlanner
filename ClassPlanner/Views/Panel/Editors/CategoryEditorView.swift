//
//  CourseAdderView.swift
//  ClassPlanner
//
//  Created by Edvin Berhan on 2021-03-22.
//

import SwiftUI
import CoreData
import Combine

struct CategoryEditorView: View {
    
    // Used to stop editing
    @EnvironmentObject var shared: SharedVM
    
    @ObservedObject var category: Category
    
//    // Used to search courses
//    @ObservedObject var courseStore: CourseStore
    
    @ObservedObject var categorySuggestionVM: CategorySuggestionVM
    @ObservedObject var searchModel: SearchModel
    
    private var cancellables = Set<AnyCancellable>()
    private var color: Color { category.getColor() }
    
    // Sort courses depending on current schedule
    private var courses: [Course] {
        if let schedule = shared.currentSchedule {
            return category.coursesSortedBySchedule(schedule: schedule)
        }
        else {
            return category.coursesSorted()
        }
    }
    
    init(category: Category, categorySuggestionVM: CategorySuggestionVM, context: NSManagedObjectContext) {
        self.categorySuggestionVM = categorySuggestionVM
        self.category = category
        // Breaks when we delete a course
        self.searchModel = SearchModel(startingText: "", context: context)

    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Spacer(minLength: 7)
            concentrationName
            EditorTitleView(title: category.name).foregroundColor(color)
            Divider().padding(5)
            EditorNotes(notes: category.notes)
            Form {
                Section {
                    nameField
                    requiredField
                    noteEditor
                }
                Spacer().frame(height: 20)
                Section(header: header, footer: footer) {
                    courseSearchField
                    coursesView
                }
                Spacer()
                EditorColorGrid { category.color = $0; save() }
                bottomButtons
                
            }
            .padding()

        }

    }
    
    var concentrationName: some View {
        HStack {
            Spacer()
            Text(category.concentration?.name ?? "No concentration")
                .opacity(0.4)
                .font(.footnote)
            Spacer()
        }
        
    }
    
    var nameField: some View {
        HStack {
            Text(nameSymbol).font(.system(size: 16, weight: .thin, design: .serif))
            TextField("Name", text: $category.name, onCommit: { save() }).cornerRadius(textFieldCornerRadius)
        }
    }
    
    var requiredField: some View {
        HStack {
            Text(" # ").font(.system(size: 17.5, weight: .thin, design: .default)).foregroundColor(.yellow)
            IntTextField("# Required", integer: $category.numberOfRequired, onCommit: { save() })
                .cornerRadius(textFieldCornerRadius)
        }
    }
    
    
    var header: some View {
        Text("Add Courses")
            .opacity(emptyHoverOpacity)
    }
    
    var footer: some View {
        Text("Click Course to Remove")
            .opacity(emptyHoverOpacity)
    }
    
    var courseSearchField: some View {
        SuggestionInput(text: $searchModel.currentText,
                        suggestionGroups: searchModel.suggestionGroups,
                        suggestionModel: categorySuggestionVM.suggestionModel)
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
        HStack {
            Text(noteSymbol)
            if #available(OSX 11.0, *) {
                TextEditor(text: $category.notes)
                    .cornerRadius(textFieldCornerRadius)
            } else {
                TextField("Notes...", text: $category.notes, onCommit: { save() })
                    .cornerRadius(textFieldCornerRadius)
            }
        }
    }
//
//    @State var startIndex: Int = 0
//
//
//
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
//                Text("Click to add").frame(minWidth: 50, maxWidth: .infinity, alignment: .trailing)
//                Divider()
//                Grid(showingCourses, desiredAspectRatio: 3) { course in
//                    Text(course.name)
//                }
//            }
//
//                Divider()
//            }.frame(height: 40 + CGFloat((showingCourses.count + 1) / 3) * 50, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
//    }
    
    var coursesView: some View {
        Grid (courses, desiredAspectRatio: 2) { course in
            HStack {
                Text(course.name == "" ? "No name" : course.name)
                    .foregroundColor(course.getColor())
                    .contentShape(Rectangle())
                    .onTapGesture { category.removeCourse(course) }
            }
        }.frame(width: editorWidth, height: CGFloat(courses.count) * 20, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
    }
    
    var bottomButtons: some View {
        HStack {
            Button("Delete") {
                withAnimation {
                    // Only thing panel is needed for -- do we have to close to delete?
                    shared.setEditSelection(to: .none)
                    category.delete()
                }
            }
            Spacer()
            Button("Close") {
                withAnimation {
                    shared.setEditSelection(to: .none)
                }
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
//
//    var numberFormatter: NumberFormatter {
//        let numberFormatter = NumberFormatter()
//        numberFormatter.maximumSignificantDigits = 3
//        numberFormatter.roundingMode = .ceiling
//        numberFormatter.zeroSymbol = ""
//        return numberFormatter
//    }
    
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


