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
    
    // Make this guy look at the current schedule too for automatic updating
    
    // Used to stop editing
    @EnvironmentObject var shared: SharedVM
    
    @ObservedObject var category: Category
    
    // Needed to search courses w/ suggestions
    @ObservedObject var categorySuggestionVM: CategorySuggestionVM
    @ObservedObject var searchModel: SearchModel
    

    // Sort courses depending on current schedule
    private var courses: [Course] {
        if let schedule = shared.currentSchedule {
            return category.coursesSortedBySchedule(schedule: schedule)
        }
        else {
            return category.coursesSorted()
        }
    }
    
    private var cancellables = Set<AnyCancellable>()
    private var color: Color { category.getColor() }
    
    init(category: Category, categorySuggestionVM: CategorySuggestionVM, context: NSManagedObjectContext) {
        self.categorySuggestionVM = categorySuggestionVM
        self.category = category
        // Breaks when we delete a course
        self.searchModel = SearchModel(startingText: "", context: context)

    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            concentrationName
            Spacer().frame(height: 6)
            EditorHeader(title: category.name, notes: category.notes, color: category.getColor() )
            Form {
                NameEditor(entryView: nameField)
                requiredField
                NoteEditor(text: $category.notes) { category.save() }
                Spacer().frame(height: 25)
                Section(header: header) {
                    courseSearchField
                    coursesView
                }
                EditorColorGrid { category.color = $0; category.save() }
                EditorButtons(deleteAction: deleteAction, closeAction: shared.stopEdit)
                
            }
            .padding(editorPadding)
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
        TextField("Name...", text: $category.name, onCommit: { category.save() }).cornerRadius(textFieldCornerRadius)
    }
    
    var requiredField: some View {
        HStack {
            Text(numberRequiredSymbol).font(.system(size: 17.5, weight: .thin, design: .default)).foregroundColor(.yellow)
            IntTextField("Number of required courses", integer: $category.numberOfRequired, onCommit: { category.save() })
                .cornerRadius(textFieldCornerRadius)
                .focusable()
        }
    }
    
    
    var header: some View {
        HStack {
            Text("Add Courses")
                .opacity(emptyHoverOpacity)
            Spacer()
            Text("Click to Remove")
                .opacity(emptyHoverOpacity)
        }

    }
    
    var courseSearchField: some View {
        SuggestionInput(text: $searchModel.currentText,
                        suggestionGroups: searchModel.suggestionGroups,
                        suggestionModel: categorySuggestionVM.suggestionModel)
            .focusable()
    }

    
    var coursesView: some View {
        ScrollView(showsIndicators: false) {
            Columns(courses, moreView: EmptyView()) { course in
                HStack {
                    Text(course.name == "" ? "No name" : course.name)
                        .foregroundColor(course.getColor())
                    Spacer()
                    if shared.currentSchedule?.courseURLs.contains(course.urlID) ?? false {
                        Text(courseContainedSymbol)
                            .foregroundColor(checkMarkColor)
                    }
                }
                .padding(.vertical, 7)
                .padding(.horizontal, 10)
                .contentShape(Rectangle())
                .onTapGesture {
                    withAnimation {
                        category.removeCourse(course)
                    }
                }
            }
        }
    }
    
    func deleteAction() {
        shared.stopEdit()
        category.delete()
        shared.setPanelSelection(to: .concentrations)
    }
    
    func closeAction() {
        shared.stopEdit()
        shared.setPanelSelection(to: .concentrations)
    }
}

//        Grid (courses, desiredAspectRatio: 2) { course in
//            HStack {
//                Text(course.name == "" ? "No name" : course.name)
//                    .foregroundColor(course.getColor())
//                    .contentShape(Rectangle())
//                    .onTapGesture { category.removeCourse(course) }
//            }
//        }.frame(height: CGFloat(courses.count) * 20)


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

//        Text("+").font(.title)
//            .rotationEffect(Angle(degrees: 45))
//            .foregroundColor(.red)
//            .onTapGesture {
//                self.isPresented = false
//                viewModel.deleteCourse(course)
//            }

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

//
//    var numberFormatter: NumberFormatter {
//        let numberFormatter = NumberFormatter()
//        numberFormatter.maximumSignificantDigits = 3
//        numberFormatter.roundingMode = .ceiling
//        numberFormatter.zeroSymbol = ""
//        return numberFormatter
//    }


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
