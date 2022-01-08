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
    @ObservedObject var storeVM: CourseStoreVM
    
    // Needed to create new courses
    @Environment(\.managedObjectContext) var context
    
    @FetchRequest private var courses: FetchedResults<Course>
    
    init(storeVM: CourseStoreVM) {
        self.storeVM = storeVM
        let predicate = NSPredicate(format: "name_ != %@", argumentArray: [""])
        let request = Course.fetchRequest(predicate)
        _courses = FetchRequest(fetchRequest: request)
    }
    
    var matchingCourses: [Course] {
        courses.filter {
            (storeVM.query.isEmpty ||
             $0.name.localizedCaseInsensitiveContains(storeVM.query) ||
             $0.course_id.localizedCaseInsensitiveContains(storeVM.query) ||
             $0.professorName.localizedStandardContains(storeVM.query)) &&
            ($0.fall == storeVM.includeFall || $0.spring == storeVM.includeSpring || !storeVM.includeSpring && !storeVM.includeFall) &&
            ($0.monday == storeVM.monday && $0.tuesday == storeVM.tuesday && $0.wednesday == storeVM.wednesday && $0.thursday == storeVM.thursday && $0.friday == storeVM.friday || !storeVM.monday && !storeVM.tuesday && !storeVM.wednesday && !storeVM.thursday && !storeVM.friday)
        }.sorted(by: storeVM.sortOrder == .ascending ? storeVM.ascendingSort : storeVM.descendingSort)
    }

    var body: some View {
        PanelHeaderView(addAction: addCourse, includeAddButton: false, searchQuery: $storeVM.query) {
            VStack {
                Group {
                    optionsView
                        .padding(.vertical, 10)
                    Divider()
                }
                    .padding(.leading, isCatalina ? 15 : editorPadding)
                    .padding(.trailing, isCatalina ? 30 : editorPadding)
                if matchingCourses.isEmpty {
                    NoResultsView()
                }
                else if #available(macOS 11.0, *) {
                    courseVStack
                        .padding(.horizontal, editorPadding)
                } else {
                    courseList
                }
            }
         }
    }
    
    var optionsView: some View {
        VStack {
            HStack(spacing: 3) {
                Button("Mon", action: storeVM.toggleMonday)
                            .opacity(storeVM.monday ? 1 : 0.51)
                Button("Tue", action: storeVM.toggleTuesday)
                            .opacity(storeVM.tuesday ? 1 : 0.51)
                Button("Wed", action: storeVM.toggleWednesday)
                            .opacity(storeVM.wednesday ? 1 : 0.51)
                Button("Thu", action: storeVM.toggleThursday)
                            .opacity(storeVM.thursday ? 1 : 0.51)
                Button("Fri", action: storeVM.toggleFriday)
                            .opacity(storeVM.friday ? 1 : 0.51)
//                DatePicker("Course Time", selection: $storeVM.time, displayedComponents: .hourAndMinute)
//                    .labelsHidden()
                Spacer()
                Toggle(fallSymbol, isOn: $storeVM.includeFall.animation())
                Toggle(springSymbol, isOn: $storeVM.includeSpring.animation())

            }
            .padding(.leading, 9)
            .padding(.trailing, 2)
            .buttonStyle(DefaultButtonStyle())
            HStack(spacing: 15) {
                Picker("", selection: $storeVM.sortOption) {
                        ForEach(SortOption.allCases, id: \.self) { option in
                            Text(option.description)
                    }
                }.pickerStyle(SegmentedPickerStyle())
                Picker("", selection: $storeVM.sortOrder) {
                        ForEach(SortOrder.allCases, id: \.self) { order in
                            Text(order.description)
                    }
                }.pickerStyle(SegmentedPickerStyle())
                    .frame(width: 60)
                    .clipped()
                Text("\(qscoreSymbol)  \(workloadSymbol)  \(enrollmentSymbol) ")
            }
        }
    }
    
    
    var courseList: some View {
        List(matchingCourses) { course in
            courseListView(course: course)
                .onDrag { NSItemProvider(object: course.stringID as NSString) }
                .contentShape(Rectangle())
                .onTapGesture {
                    withAnimation {
                        shared.setEditSelection(to: .course(course: course))
                    }
                }
        }
    }
    
    @available(macOS 11.0, *)
    var courseVStack: some View {
        ScrollView(showsIndicators: isCatalina) {
            LazyVStack {
                ForEach(matchingCourses) { course in
                    courseListView(course: course)
                        .onDrag { NSItemProvider(object: course.stringID as NSString) }
                        .contentShape(Rectangle())
                        .onTapGesture {
                            withAnimation {
                                shared.setEditSelection(to: .course(course: course))
                        }
                    }
                }
            }
        }
    }
    
    func courseListView(course: Course) -> some View {
        VStack {
            HStack(spacing: 0) {
                Text(course.idName)
                    .foregroundColor(course.getColor())
                    .lineLimit(1)
                    .truncationMode(.tail)
                Spacer()
                Text(" \(course.fall ? fallSymbol : "")\(course.spring ? springSymbol : "") \(NSNumber(value: course.qscore), formatter: NumberFormatter.courseFormat) / \(NSNumber(value: course.workload), formatter: NumberFormatter.courseFormat) / \(NSNumber(value: course.enrollment), formatter: NumberFormatter.courseFormat)")
            }
            Divider()
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
