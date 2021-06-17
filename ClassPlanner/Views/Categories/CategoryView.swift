//
//  CategoryView.swift
//  ClassPlanner
//
//  Created by Edvin Berhan on 2021-05-02.
//

import SwiftUI

struct CategoryView: View {
    
    // Needed to set edit selection
    @EnvironmentObject var shared: SharedVM
    @ObservedObject var category: Category

    // Needs to look at the schedule to check the courses
    @ObservedObject var schedule: ScheduleVM

    @State private var isDropping: Bool = false
    
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
    
    private var numberOfContainedCourses: Int {
        if let schedule = shared.currentSchedule {
            return
                category.courses.reduce(into: 0) { acc, course in
                    acc += Int(schedule.courseURLs.contains(course.urlID))
                }
        }
        else {
            return 0
        }
    }
    
    private var moreContainedThanRequired: Bool {
        if category.numberOfRequired == 0 { return false }
        return numberOfContainedCourses >= category.numberOfRequired
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            title
            Divider().padding(.trailing, 4)
            ForEach (courses) { course in
                courseView(course: course)
                    .onDrag { NSItemProvider(object: course.stringID as NSString) }
                    .onTapGesture { shared.setEditSelection(to: .course(course: course)) }
            }
            Spacer(minLength: 4)
        }
        .scaleEffect(isDropping ? hoverScaleFactor : 1)
        .contentShape(RoundedRectangle(cornerRadius: frameCornerRadius))
        .onDrop(of: ["public.utf8-plain-text"], isTargeted: $isDropping) { drop(providers: $0) }
        .onDrag({ NSItemProvider(object: category.stringID as NSString) })
        .frame(width: categoryWidth)
    }

    var title: some View {
        HStack(spacing: 0) {
            Text(category.name == "" ? "Name" : category.name)
                .opacity(category.name == "" ? grayTextOpacity : 1)
                .foregroundColor(color)
            Spacer()
            Text("\(numberOfContainedCourses)")
                .opacity(moreContainedThanRequired ? 1 : grayTextOpacity)
                .foregroundColor(moreContainedThanRequired ? .green : .primary)
            Text("/\(category.numberOfRequired)")
                .opacity(category.numberOfRequired == 0 ? grayTextOpacity : 1)
                
        }
        .padding([.trailing], 4)
        .lineLimit(2)
        .font(.system(size: categoryCourseFontSize + 1))
        .contentShape(Rectangle())
        .onTapGesture { shared.setEditSelection(to: .category(category: category)) }
        
    }
    
    func courseView(course: Course) -> some View {
        HStack {
            Text(course.name)
                .font(categoryCourseFont)
                .foregroundColor(course.getColor())
            Spacer()
            if let schedule = shared.currentSchedule {
                if schedule.courseURLs.contains(course.urlID) {
                    Text("􀁢")
                        .foregroundColor(checkMarkColor)
                }
            }
        }
        .padding(.trailing, 3)
    }
    
    func drop(providers: [NSItemProvider]) -> Bool {
        let found = providers.loadFirstObject(ofType: String.self) { location in
            if let uri = URL(string: location) {
                if let context = category.managedObjectContext {
                    if let droppedObject = NSManagedObject.fromURI(uri: uri, context: context) {
                        withAnimation {
                            if let course = droppedObject as? Course {
                                category.addCourse(course)
                            }
                            if let category = droppedObject as? Category {
                                if let concentration = self.category.concentration {
                                    category.move(to: self.category.index, concentration: concentration)
                                }
                            }
                        }
                    }
                }
            }
        }
        return found
    }
    
    
//
//
//    var dragGesture: some Gesture {
//        DragGesture(coordinateSpace: .global)
//            .onChanged {
//                dragOffset = CGSize(width: $0.translation.width, height: -$0.translation.height)
//                if concentrationVM.dragCategory == nil { concentrationVM.setDragCategory(to: category) }
//            }
//            .onEnded { _ in
//                concentrationVM.categoryDragEnded()
//                dragOffset = .zero
//            }
//    }
    

}
