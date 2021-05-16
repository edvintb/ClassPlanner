//
//  SwiftUIView.swift
//  ClassPlanner
//
//  Created by Edvin Berhan on 2021-05-15.
//

import SwiftUI
import CoreData

struct PanelCoursesView: View {
    
    @EnvironmentObject var viewModel: CourseVM
    @State private var query: String = ""
    @FetchRequest private var courses: FetchedResults<Course>
    
    init() {
        let request = NSFetchRequest<Course>(entityName: "Course")
        request.sortDescriptors = [NSSortDescriptor(key: "name_", ascending: true)]
        request.predicate = NSPredicate(format: "name_ != %@", argumentArray: [""])
        _courses = FetchRequest(fetchRequest: request)
    }
    
    var matchingCourses: [Course] {
        courses.filter { query.isEmpty || $0.name.localizedCaseInsensitiveContains(query) }
    }
    
    var body: some View {
        GeometryReader { geo in
            ScrollView {
                SearchTextField(query: $query)
                Columns(matchingCourses, numberOfColumns: Int((geo.frame(in: .local).width - courseWidth / 2) / courseWidth), maxNumberRows: 7) { course in
                    CourseView(course: course)
                }
            }.onHover { if viewModel.dragCourse != nil { viewModel.draggedPanelToSchedule = !$0; print(!$0) } }
        }
    }
}

//struct SwiftUIView_Previews: PreviewProvider {
//    static var previews: some View {
//        PanelCoursesView()
//    }
//}
