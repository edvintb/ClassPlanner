//
//  SwiftUIView.swift
//  ClassPlanner
//
//  Created by Edvin Berhan on 2021-05-15.
//

import SwiftUI
import CoreData

struct PanelCoursesView: View {
    
    @ObservedObject var courseStore: CourseStore
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.managedObjectContext) var context
    
    @State private var query: String = ""
    @FetchRequest private var courses: FetchedResults<Course>
    
    @State var isDropping: Bool = false
    
    init(courseStore: CourseStore) {
        self.courseStore = courseStore
        let request = NSFetchRequest<Course>(entityName: "Course")
        request.sortDescriptors = [NSSortDescriptor(key: "name_", ascending: true)]
        request.predicate = NSPredicate(format: "name_ != %@", argumentArray: [""])
        _courses = FetchRequest(fetchRequest: request)
    }
    
    var matchingCourses: [Course] {
        courses.filter { query.isEmpty || $0.name.localizedCaseInsensitiveContains(query) }
    }
    
    
    // Enable dropping to remove courses from here
    var body: some View {
        GeometryReader { geo in
            ScrollView {
                Spacer(minLength: 3)
                SearchTextField(query: $query).padding([.horizontal], 10).padding([.vertical], 5)
                if matchingCourses.isEmpty { noResultsView }
                else {
                    Columns(matchingCourses, numberOfColumns: 2, maxNumberRows: 7, moreView: moreView) { course in
                        PanelCourseView(course: course, viewModel: courseStore)
                        .onDrag { NSItemProvider(object: course.name as NSString) }
                        .scaleEffect(isDropping ? hoverScaleFactor : 1)
                    }
                    .padding([.horizontal], 7)
                }
            }
            .onDrop(of: ["public.utf8-plain-text"], isTargeted: $isDropping) { drop(providers: $0) }
        }
    }
    
    func drop(providers: [NSItemProvider]) -> Bool {
        print("Found")
        print(providers)
        let found = providers.loadFirstObject(ofType: String.self) { string in
            let newCourse = Course.withName(string as String, context: context)
            withAnimation(Animation.linear(duration: 0.1)){
                newCourse.moveToSemester(0, and: 0)
            }
        }
        return found
    }
    
    var noResultsView: some View {
        HStack {
            VStack {
                Text("No Results").opacity(0.2).font(.system(size: 20))
                CourseView(course: Course.withName("", context: context))
                    .padding([.horizontal], 5)
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
