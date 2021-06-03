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
    
    // Needed for dragging and editing
    @ObservedObject var concentrationVM: ConcentrationVM

    @State private var dragOffset: CGSize = .zero
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
                category.courses.filter {
                    schedule.courseURLs.contains($0.objectID.uriRepresentation())
                }.count
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
            }
            Spacer(minLength: 4)
        }
        .scaleEffect(isDropping ? hoverScaleFactor : 1)
        .onHover { isDropping = concentrationVM.hoverOverCategory(category, entered: $0) }
        .offset(dragOffset)
        .contentShape(RoundedRectangle(cornerRadius: frameCornerRadius))
        .onDrop(of: ["public.utf8-plain-text"], isTargeted: $isDropping) { drop(providers: $0) }
    }

    
    
    var title: some View {
        HStack(spacing: 0) {
            Text(category.name == "" ? "Name" : category.name)
                .opacity(category.name == "" ? emptyHoverOpacity : 1)
                .foregroundColor(color)
            Spacer()
            Text("\(numberOfContainedCourses)")
                .opacity(moreContainedThanRequired ? 1 : emptyHoverOpacity)
                .foregroundColor(moreContainedThanRequired ? .green : .primary)
            Text("/\(category.numberOfRequired)")
                .opacity(category.numberOfRequired == 0 ? emptyHoverOpacity : 1)
                
        }
        .padding([.trailing], 4)
        .lineLimit(2)
        .font(.system(size: categoryCourseFontSize + 1))
        .contentShape(Rectangle())
        .onTapGesture { concentrationVM.setEditCategory(category) }
        .gesture(dragGesture)
    }
    
    func courseView(course: Course) -> some View {
        HStack {
            Text(course.name)
                .font(categoryCourseFont)
                .foregroundColor(course.getColor())
            Spacer()
            if let schedule = shared.currentSchedule {
                if schedule.courseURLs.contains(course.objectID.uriRepresentation()) {
                    Text("􀁢")
                        .foregroundColor(checkMarkColor)
                }
            }
        }
        .padding(.trailing, 3)
    }
    
    func drop(providers: [NSItemProvider]) -> Bool {
//        print("Found")
//        print(providers)
        let found = providers.loadFirstObject(ofType: String.self) { location in
            if let uri = URL(string: location) {
                if let context = category.managedObjectContext {
                    if let newCourse = Course.fromURI(uri: uri, context: context) {
                        withAnimation {
                            category.addCourse(newCourse)
                        }
                    }
                }
            }
        }
        return found
    }
    
    

    
    var dragGesture: some Gesture {
        DragGesture(coordinateSpace: .global)
            .onChanged {
                dragOffset = CGSize(width: $0.translation.width, height: -$0.translation.height)
                if concentrationVM.dragCategory == nil { concentrationVM.setDragCategory(to: category) }
            }
            .onEnded { _ in
                concentrationVM.categoryDragEnded()
                dragOffset = .zero
            }
    }
    

}
