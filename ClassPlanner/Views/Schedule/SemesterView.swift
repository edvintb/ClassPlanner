//
//  SemesterView.swift
//  ClassPlanner
//
//  Created by Edvin Berhan on 2021-03-24.
//

import SwiftUI
import CoreData

struct SemesterView: View {
    
    let semester: Int
    
    @Environment(\.managedObjectContext) var context
    @ObservedObject var schedule: ScheduleVM
    
    private var courses: [Course] { schedule.courses(for: semester) }
    
    private var totalWorkload: Double { courses.reduce(into: 0) { acc, course in acc += course.workload }}
    
    private var totalGrade: Double { courses.reduce(into: 0) { acc, course in acc += Grade.gradeNumber[course.enumGrade] ?? 0 }}
    
    var body: some View {
        VStack(spacing: courseSpacing) {
            topView
            ForEach (courses) { course in
                ScheduleCourseView(course: course)
            }
            EmptyCourseView(semester: semester)
            Spacer()
        }
        .frame(width: courseWidth, alignment: .top)
    }
    
    var topView: some View {
        HStack {
            Text(String(format: "\(workloadSymbol) %.1f", totalWorkload))
            
        }
    }
    
//    func delete(course: Course) -> some View {
//        print(course.qscore)
//        course.delete()
//        return Text("I was a course")
//    }
    
    //        VStack {
    ////            HStack {
    ////                ForEach (viewModel.semesters, id: \.self) { semester in
    ////                    Text("\(semester)").frame(width: courseWidth, alignment: .center)
    ////                }
    ////                .padding()
    
    //        List {
    //            HStack {
    //                ForEach (viewModel.semesters, id: \.self) { semester in
    //                    SemesterView(for: semester, viewModel)
    //                }
    //            }
    //        }
    
    //        ScrollView([.horizontal, .vertical], showsIndicators: true) {
    //                HStack {
    //                    ForEach (viewModel.semesters, id: \.self) { semester in
    //                        SemesterView(for: semester, viewModel)
    //                    }
    //                }
    //            }
    
    
    //    var body: some View {
    //        VStack {
    //            List {
    //                HStack(spacing: 0) {
    //                    ForEach(viewModel.semesters, id: \.self) { semester in
    //                        SemesterView(for: semester viewModel)
    //                    }
    //
    //                }
    //            }
    //        }
    //    }
    
    
    
    
    
//    @State private var isTargeted: Bool = false
    
//    func emptyCourseView() -> some View {
//        ZStack(alignment: .top) {
//            RoundedRectangle(cornerRadius: frameCornerRadius).opacity(0.001)
//                .frame(minWidth: courseWidth, maxWidth: courseWidth, minHeight: courseHeight, maxHeight: .infinity, alignment: .center)
//            Text("\(position)")
//            if isTargeted {
//                RoundedRectangle(cornerRadius: frameCornerRadius).stroke()
//                    .foregroundColor(Color.gray)
//                    .opacity(0.8)
//                    .frame(width: courseWidth, height: courseHeight, alignment: .top)
//            }
//        }
//        .onHover { entered in
//            hover(entered) }
//        
//        
//    }
//    
//    func hover(_ entered: Bool) {
//        if viewModel.dragCourse != nil && viewModel.startSemester != Int16(semester) {
//            if entered {
//                print("Dragging over course \(position) in semester \(semester)")
//                viewModel.dragSemester = Int16(semester)
//                viewModel.dragPosition = Int32(courses.count)
//                isTargeted = true
//                // dragState = .good
//            }
//            else {
//                print("Setting back to start position")
//                isTargeted = false
//                viewModel.setToStarting()
//                // dragState = .bad
//            }
//        }
//        else {
//            isTargeted = false
//        }
//    }

    
//    func addButton() -> some View {
//
//        ZStack(alignment: .center) {
//            RoundedRectangle(cornerRadius: frameCornerRadius).stroke()
//            if #available(OSX 11.0, *) {
//                Image(systemName: "plus.circle")
//            } else {
//                Text("+").font(.system(size: 2*titleSize))
//            }
//        }
//        .contentShape(RoundedRectangle(cornerRadius: frameCornerRadius))
//        .onTapGesture {
//            addingCourse = !addingCourse
//            print(addingCourse)
//        }
//        .popover(isPresented: $addingCourse, content: {
//            CourseAdder(to: semester, at: courses.count, $addingCourse)
//                .environment(\.managedObjectContext, self.context)
//        })
//        .frame(width: courseWidth, height: courseHeight/2, alignment: .center)
//        .padding([.horizontal], 5)
//        .foregroundColor(.gray)
//        .opacity(0.6)
//
//    }
    
}

//        .onDrop(of: ["public.text"], isTargeted: nil) { providers in
//            print("Dropped")
//            return true
//        }


//            .onReceive(viewModel.$frameSwitch) { _ in
//                // print("Frames updated")
////                viewModel.semesterFrames[semester] = geo.frame(in: .global)
//                // print(geo.frame(in: .global))
//            }
//            }



// Spacer().frame(width: 10, height: topSpace, alignment: .center)

// .frame(minWidth: 100, idealWidth: 110, maxWidth: 120, minHeight: 200, idealHeight: 500, maxHeight: 500, alignment: .center)


//    private func drop(at index: Int, _ items: [NSItemProvider]) {
//        for item in items {
//            _ = item.loadObject(ofClass: String.self) { name, _ in
//                let request = Course.fetchRequest(NSPredicate(format: "name_ = %@", argumentArray: [name as Any]))
//                let courses = (try? context.fetch(request)) ?? []
//                DispatchQueue.main.async {
//                    if let course = courses.first {
//                        course.move(to: semester, and: index)
//                    }
//                }
//            }
//        }
//    }
//


//                        .onHover { entered in
//                            print(viewModel.isDragging)
//                            if entered && viewModel.isDragging {
//                                print("Hovering over course \(course.position)")
//                                // viewModel.updateFrames()
//                            }
//                        }
//                        .background(
//                            GeometryReader { geo in
//                                Color.clear
////                                    .onReceive(viewModel.$isDragging) { _ in
//////                                         print("Course \(course.name) updated")
////                                        // Check if frames are equal before updating all of them -- must be done through viewmodel
////                                        // What is going on with the frames?
////                                       viewModel.courseFrames[semester]?[Int(course.position)] = geo.frame(in: .global)
//// //                                       print(viewModel.courseFrames[semester]![Int(course.position)])
////
////                                   }
//////                                        if entered {
//////                                            print("Hovering over course \(course.position)")
//////                                            if geo.frame(in: .global) != .zero {
//////                                                viewModel.courseFrames[semester]?[Int(course.position)] = geo.frame(in: .global)
//////                                            }
//////                                        }
////                                    }
//                    })

//    var dragGesture: some Gesture {
//        DragGesture(coordinateSpace: .global)
//            .onChanged {
//                viewModel.isDragging = true
//                // turnOnDrag()
//                self.dragOffset = CGSize(width: $0.translation.width, height: -$0.translation.height)
//                // self.dragState = self.courseMoved(to: $0.location)
//            }
//            .onEnded { _ in
//                // if dragState == .good {
//                    // self.courseDropped()
//                // }
//                dragOffset = .zero
//                // repositionOffset = 0
//                viewModel.isDragging = false
//            }
//    }
