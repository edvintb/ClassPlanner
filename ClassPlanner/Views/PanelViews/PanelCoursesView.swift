//
//  SwiftUIView.swift
//  ClassPlanner
//
//  Created by Edvin Berhan on 2021-05-15.
//

import SwiftUI
import CoreData

struct PanelCoursesView: View {
    
    @EnvironmentObject var shared: SharedVM
    
    // Needed to remove courses from current schedule
    @ObservedObject var scheduleStore: ScheduleStore
    
    // Needed for the search logic
    @ObservedObject var courseStore: CourseStore
//    @Environment(\.colorScheme) var colorScheme
    
    // Needed for the request
    @Environment(\.managedObjectContext) var context
    
    @State private var query: String = ""
    @FetchRequest private var courses: FetchedResults<Course>
    
    @State var isDropping: Bool = false
    
    init(courseStore: CourseStore, scheduleStore: ScheduleStore) {
        self.scheduleStore = scheduleStore
        self.courseStore = courseStore
        let request = NSFetchRequest<Course>(entityName: "Course")
        request.sortDescriptors = [NSSortDescriptor(key: "name_", ascending: true)]
        request.predicate = NSPredicate(format: "name_ != %@", argumentArray: [""])
//        request.predicate = .all
        _courses = FetchRequest(fetchRequest: request)
    }
    
    var matchingCourses: [Course] {
        courses.filter { query.isEmpty || $0.name.localizedCaseInsensitiveContains(query) }
    }

    var body: some View {
        GeometryReader { geo in
            ScrollView {
                Spacer(minLength: 3)
                SearchTextField(query: $courseStore.courseQuery).padding([.horizontal], 10).padding([.vertical], 5)
                if matchingCourses.isEmpty { noResultsView }
                else {
                    Columns(matchingCourses, numberOfColumns: 2, maxNumberRows: 7, moreView: moreView) { course in
                        PanelCourseView(course: course, viewModel: courseStore)
                            .onDrag { NSItemProvider(object: course.stringID as NSString) }
                            .scaleEffect(isDropping ? hoverScaleFactor : 1)
                    }
                    .padding([.horizontal], 7)
                }
            }
            .onDrop(of: ["public.utf8-plain-text"], isTargeted: $isDropping) { drop(providers: $0) }
        }
    }
    
    func drop(providers: [NSItemProvider]) -> Bool {
        let found = providers.loadFirstObject(ofType: String.self) { id in
            if let droppedCourse = getDroppedCourse(id: id) {
                if let schedule = shared.currentSchedule {
                    withAnimation {
                        schedule.deleteCourse(droppedCourse)
                    }
                }
            }
        }
        return found
    }
    
    private func getDroppedCourse(id: String) -> Course? {
        if let uri = URL(string: id) {
            return Course.fromURI(uri: uri, context: context)
        }
        return nil
    }
    
    var noResultsView: some View {
        HStack {
            VStack {
                Text("No Results").opacity(0.2).font(.system(size: 20))
//                CourseView(course: Course.withName("", context: context))
//                    .padding([.horizontal], 5)
            }
            Spacer()
        }
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
