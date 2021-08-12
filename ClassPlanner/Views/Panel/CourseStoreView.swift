//
//  SwiftUIView.swift
//  ClassPlanner
//
//  Created by Edvin Berhan on 2021-05-15.
//

import SwiftUI
import CoreData

struct CourseStoreView: View {
    
    // Needed to set panel/editor
    // And to remove courses from current schedule
    @EnvironmentObject var shared: SharedVM
    
    // Needed to create new courses
    @Environment(\.managedObjectContext) var context
    
    @FetchRequest private var courses: FetchedResults<Course>
    
    @State private var query: String = ""
    @State var isDropping: Bool = false
    
    init() {
        let predicate = NSPredicate(format: "name_ != %@", argumentArray: [""])
        let request = Course.fetchRequest(predicate)
        _courses = FetchRequest(fetchRequest: request)
    }
    
    var matchingCourses: [Course] {
        courses.filter { query.isEmpty || $0.name.localizedCaseInsensitiveContains(query) }
    }

    var body: some View {
        PanelHeaderView(addAction: addCourse, searchQuery: $query) {
            ScrollView {
                if matchingCourses.isEmpty {
                    noResultsView
                }
                else {
                    coursesView
                }
            }
        }
    }
    
    
    var coursesView: some View {
        Columns(matchingCourses, moreView: moreView) { course in
            CourseView(course: course)
                .onDrag { NSItemProvider(object: course.stringID as NSString) }
                .scaleEffect(isDropping ? hoverScaleFactor : 1)
        }
        .padding()
    }
    
    var noResultsView: some View {
        HStack {
            Spacer()
            Text("No Results").opacity(0.2).font(.system(size: 20))
            Spacer()
        }
    }
    
    func addCourse() {
        let course = Course.create(context: context)
        withAnimation {
            shared.setEditSelection(to: .course(course: course))
        }
    }
    
    func drop(providers: [NSItemProvider]) -> Bool {
        let found = providers.loadFirstObject(ofType: String.self) { id in
            if let droppedCourse = getDroppedCourse(id: id) {
                if let schedule = shared.currentSchedule {
                    withAnimation {
                        schedule.removeCourse(droppedCourse)
                    }
                }
            }
        }
        return found
    }
    
    private func getDroppedCourse(id: String) -> Course? {
        if let uri = URL(string: id) {
            return Course.fromCourseURI(uri: uri, context: context)
        }
        return nil
    }
    

    
    var moreView: some View {
        ZStack {
            RoundedRectangle(cornerRadius: frameCornerRadius).stroke()
            Text("...").font(.system(size: 1.3*titleSize))
        }
        .frame(height: courseHeight, alignment: .center)
        .contentShape(RoundedRectangle(cornerRadius: frameCornerRadius))
        .opacity(0.2)
        .padding([.horizontal], 5)
    }
}

//struct SwiftUIView_Previews: PreviewProvider {
//    static var previews: some View {
//        PanelCoursesView()
//    }
//}
