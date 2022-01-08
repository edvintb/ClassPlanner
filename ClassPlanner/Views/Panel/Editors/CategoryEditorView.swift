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
    
    @Binding var isShowingOnboarding: Bool
    @State private var isDroppingCourse: Bool = false
    
    // Sort courses depending on current schedule
    private var courses: [Course] { category.coursesSortedBySchedule(schedule: shared.currentSchedule) }
    
    private var color: Color { category.getColor() }
    
    init(category: Category, categorySuggestionVM: CategorySuggestionVM, context: NSManagedObjectContext, isShowingOnboarding: Binding<Bool>) {
        self.categorySuggestionVM = categorySuggestionVM
        self.category = category
        self._isShowingOnboarding = isShowingOnboarding
        // Breaks when we delete a course
        self.searchModel = SearchModel(startingText: "", context: context)
        
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            EditorTypeView(editorName: "Category", infoTappedAction: { isShowingOnboarding = true }, createBackButton: createBackButton)
            concentrationName
            Spacer().frame(height: 6)
            EditorHeader(title: category.name, notes: category.notes, color: category.getColor() )
            Form {
                NameEditor(entryView: nameField)
                requiredField
                NoteEditor(text: $category.notes) { category.save() }
                Spacer().frame(height: 5)
                EditorColorGrid { category.colorOption = $0; category.save() }
                Spacer().frame(height: 15)
                Section(header: header) {
                    courseSearchField
                    coursesView
                }
                
                EditorButtons(deleteAction: deleteAction, closeAction: closeAction)
            }
            .padding(editorPadding)
        }
        
    }
    
    func createBackButton() -> some View {
        Button(action: {
            if let safeConcentration = category.concentration {
                shared.setEditSelection(to: .concentration(concentration: safeConcentration))
            }
            else {
                shared.setPanelSelection(to: .concentrations)
            }
        }, label: {
            Text("⬅")
        })
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    var concentrationName: some View {
            Text(category.concentration?.name ?? "No concentration")
                .opacity(0.4)
                .font(.footnote)
                .frame(maxWidth: .infinity, alignment: .center)
    }
    
    var nameField: some View {
        TextField("Name...", text: $category.name, onCommit: { category.save() })
            .cornerRadius(textFieldCornerRadius)
            .popover(isPresented: $isShowingOnboarding, content: {
                CategoryFunctionOnboarding()
            })
    }
    
    var requiredField: some View {
        HStack {
            Text(numberRequiredSymbol).font(.system(size: 20, weight: .thin, design: .default)).foregroundColor(.yellow)
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
        ScrollView(showsIndicators: isCatalina) {
            Columns(courses, moreView: EmptyView()) { course in
                HStack {
                    Text(course.name == "" ? "No name" : course.name)
                        .foregroundColor(course.getColor())
                    Spacer()
                    if shared.currentSchedule?.courseUrlSet.contains(course.urlID) ?? false {
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
        .contentShape(Rectangle())
        .onDrop(of: ["public.utf8-plain-text"], isTargeted: $isDroppingCourse) { drop(providers: $0) }
    }
    
    func deleteAction() {
        shared.stopEdit()
        if let safeConcentration = category.concentration {
            shared.setEditSelection(to: .concentration(concentration: safeConcentration))
        }
        else {
            shared.setPanelSelection(to: .concentrations)
        }
        category.delete()
        
    }
    
    func closeAction() {
        if let safeConcentration = category.concentration {
            shared.setEditSelection(to: .concentration(concentration: safeConcentration))
        }
        else {
            shared.setPanelSelection(to: .concentrations)
        }
    }
    
    func drop(providers: [NSItemProvider]) -> Bool {
        let found = providers.loadFirstObject(ofType: String.self) { url in
            if let uri = URL(string: url) {
                if let context = category.managedObjectContext {
                    if let course = NSManagedObject.fromURI(uri: uri, context: context) as? Course {
                        withAnimation {
                            category.addCourse(course)
                        }
                    }
                }
            }
        }
        return found
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
