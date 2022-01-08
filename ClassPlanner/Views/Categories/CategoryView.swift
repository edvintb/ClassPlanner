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
    
    private var color: Color { category.colorOption.color }
    
    private var isEditingCategory: Bool {
        if case let .category(editingCategory) = shared.currentEditSelection {
            return editingCategory == self.category
        }
        return false
    }
    
    private var courses: [Course] { category.coursesSortedBySchedule(schedule: shared.currentSchedule) }
    
    private var moreContainedThanRequired: Bool {
        if category.numberOfRequired == 0 { return false }
        return category.numberOfContainedCourses(schedule: schedule) >= category.numberOfRequired
    }
    
//    private var moreFinishedThanRequired: Bool {
//        if category.numberOfRequired == 0 { return false }
//        return category.numberOfContainedAndFinishedCourses(schedule: schedule) >= category.numberOfRequired
//    }
    
    var body: some View {
        ZStack {
            if isEditingCategory { RoundedRectangle(cornerRadius: frameCornerRadius).stroke() }
            VStack(alignment: .leading, spacing: 0) {
                title
                Divider().padding(.trailing, 4)
                if courses.count > 0 || category.name != "" {
                    ForEach (courses) { course in
                        courseView(course: course)
                            .onDrag { NSItemProvider(object: course.stringID as NSString) }
                            .onTapGesture { shared.setEditSelection(to: .course(course: course)) }
                    }
                }
                else {
                    Spacer(minLength: 4)
//                    Text("Drop\nCourse\nto add")
//                        .frame(maxWidth: .infinity, alignment: .center)
//                        .opacity(transparentTextOpacity)
//                        .multilineTextAlignment(.center)
                }
                Spacer(minLength: 4)
            }.padding([.top, .leading], isEditingCategory ? 3 : 0)
        }
        .scaleEffect(isDropping ? hoverScaleFactor : 1)
        .contentShape(RoundedRectangle(cornerRadius: frameCornerRadius))
        .onDrop(of: ["public.utf8-plain-text"], isTargeted: $isDropping) { drop(providers: $0) }
        .onDrag({ NSItemProvider(object: category.stringID as NSString) })
       
    }

    var title: some View {
        HStack(spacing: 0) {
            Text(category.name == "" ? "Category" : category.name)
                .opacity(category.name == "" ? grayTextOpacity : 1)
                .foregroundColor(color)
            Spacer()
//            Text("\(category.numberOfContainedAndFinishedCourses(schedule: schedule))")
//                    .opacity(moreFinishedThanRequired ? 1 : grayTextOpacity)
//                    .foregroundColor(moreFinishedThanRequired ? .green : .primary)
            Text("\(category.numberOfContainedCourses(schedule: schedule))")
                .opacity(moreContainedThanRequired ? 1 : grayTextOpacity)
                .foregroundColor(moreContainedThanRequired ? checkMarkColor : .primary)
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
            Text(course.idOrName)
                .font(categoryCourseFont)
                .foregroundColor(course.colorOption.color)
            Spacer()
            if let schedule = shared.currentSchedule {
                if schedule.courseUrlSet.contains(course.urlID) {
                    Text(courseContainedSymbol)
                        .foregroundColor(course.isFinished ? checkMarkColor : .gray)
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
