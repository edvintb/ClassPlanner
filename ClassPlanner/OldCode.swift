//
//  OldCode.swift
//  ClassPlanner
//
//  Created by Edvin Berhan on 2021-04-20.
//

import Foundation


//    @State var targetedSemester: Int = 0
//    @State var targetedCourse: Int = 0
//    @State var dummyCourse: Course?

//    func courseMoved(to position: CGPoint) -> DragState {
//        if viewModel.semesterFrames[targetedSemester].contains(position) {
//            //print("Semester \(targetedSemester) contain")
////            print(position.y)
////            print(viewModel.semesterFrames[currentSemester].height)
////            print(viewModel.semesterFrames[currentSemester].height - position.y)
////            let yIndex = Int(floor((viewModel.semesterFrames[currentSemester].height - position.y) / (courseHeight + courseSpacing/2)))
//            // print(yIndex)
//
//            if let semesterCourseFrames = viewModel.courseFrames[targetedSemester] {
//                if semesterCourseFrames[targetedCourse].contains(position) {
//                    // print("Still in same course")
//                    return .good
//                }
//            }
//            if let matchIndex = viewModel.courseFrames[targetedSemester]?.firstIndex(where: { $0.contains(position)}) {
//                targetedCourse = matchIndex
//                print(targetedCourse)
//                return .good
//            }
//            else {
//                var matchIndex = 0
//                while viewModel.courseFrames[targetedSemester]?[matchIndex] != .zero {
//                    matchIndex += 1
//                }
//                targetedCourse = matchIndex
//                print(targetedCourse)
//
//            }
//            return .good
//        }
//        else if let matchIndex = viewModel.semesterFrames.firstIndex(where: { $0.contains(position) }) {
//            targetedSemester = matchIndex
//            targetedCourse = 0
//            print(targetedSemester)
//            return .good
//        }
//        else {
//            return .bad
//        }
//    }

//    func courseMoved(to position: CGPoint) -> DragState {
//        turnOnDrag()
//        // Implement
//        if ((viewModel.courseFrames[targetedSemester]![targetedCourse].contains(position))) {
//            // print(targetedCourse)
//            return .good
//        }
//        // Make it check neighbouring positions first
//        var targetCourse: Int = 0
//        while (viewModel.courseFrames[targetedSemester]![targetCourse] != .zero) {
//            if ((viewModel.courseFrames[targetedSemester]![targetCourse].contains(position))) {
//                targetedCourse = targetCourse
//                if (course.semester == targetedSemester) {
//                    if (course.position < targetedCourse) {
//                        self.repositionOffset -= 1
//                    }
//                    else if (course.position > targetedCourse) {
//                        self.repositionOffset += 1
//                    }
//                    else {
//                        repositionOffset = 0
//                    }
//                    course.moveInSemester(to: targetedCourse)
//                    print("Moving course in same semester")
//                }
//                else if let dummy = dummyCourse {
//                    dummy.moveInSemester(to: targetedCourse)
//                }
//                print("First Loop: Moved to course \(targetedCourse) in semester \(targetedSemester)")
//                return .good
//            }
//            targetCourse += 1
//        }
//
//        // Moving to new semester -- remove dummy if there is one
//        // print(dummyCourse)
//
//        for semester in viewModel.semesters {
//            targetCourse = 0
//            while (viewModel.courseFrames[semester]![targetCourse] != .zero) {
//                // print("Ran loop for \(semester), \(targetedCourse)")
//                if ((viewModel.courseFrames[semester]![targetCourse].contains(position))) {
//                    targetedSemester = semester
//                    targetedCourse = targetCourse
////                        if let dummy = dummyCourse {
////                            if (dummy.semester == targetedSemester) {
////                                dummy.moveInSemester(to: targetedCourse)
////                            }
////                            else {
////                                dummy.moveToSemester(targetedSemester, and: targetedCourse)
////                            }
////                        }
////                        viewModel.isDragging = true
//                    if (course.semester == targetedSemester) {
//                        // There should always be a dummy when moving into the original semester
//                        viewModel.deleteCourse(dummyCourse!)
//                        if (course.position < targetedCourse) {
//                            self.repositionOffset -= 1
//                        }
//                        else if (course.position > targetedCourse) {
//                            self.repositionOffset += 1
//                        }
//                        else {
//                            repositionOffset = 0
//                        }
//                        course.moveInSemester(to: targetedCourse)
//                    }
//                    else {
//                        if dummyCourse == nil {
//                            dummyCourse = course.createDummy(in: course.managedObjectContext!)
//                            print("Dummy Created")
//                        }
//                        dummyCourse!.moveToSemester(targetedSemester, and: targetedCourse)
//                        viewModel.isDragging = true
//                    }
//                    print("Second Loop: Moved to course \(targetedCourse) in semester \(targetedSemester)")
//                    return .good
//                }
//                targetCourse += 1
//            }
//        }
////        if hasDummy {
////            viewModel.removeCourseFrom(targetedSemester, at: targetedCourse, in: course.managedObjectContext!)
////            hasDummy = false
////        }
//        return .bad
//
//    }

//    func courseDropped() {
//        for semester in 0..<10 {
//            viewModel.courseFrames.updateValue([CGRect](repeating: .zero, count: 10), forKey: semester)
//        }
//        if targetedSemester != course.semester {
//            course.moveToSemester(targetedSemester, and: targetedCourse)
//
//        }
////        if let context = course.managedObjectContext {
////            course.semester = Int16(targetedSemester)
////            course.position = Int32(targetedCourse)
////            try? context.save()
////        }
//        viewModel.isDragging = false
//    }

//    func turnOnDrag() {
//        if viewModel.isDragging {
//            return
//        }
//        else {
//            targetedCourse = Int(course.position)
//            targetedSemester = Int(course.semester)
//            for semester in 0..<10 {
//                viewModel.courseFrames.updateValue([CGRect](repeating: .zero, count: 10), forKey: semester)
//            }
//            viewModel.isDragging = true
////            dummyCourse = Course.withName("dummyCourse", context: course.managedObjectContext!)
////            dummyCourse?.semester = Int16(targetedSemester)
////            dummyCourse?.position = Int32(targetedCourse)
////            course.semester = 12
//        }
//    }

//
//  ConcentrationAdder.swift
//  ClassPlanner
//
//  Created by Edvin Berhan on 2021-04-24.
//

//import SwiftUI
//
//
//
//struct ConcentrationAdder: View {
//
//    @Environment(\.managedObjectContext) var context
//    @Binding var isPresented: Bool
//    @State private var name: String = ""
//    @State private var notes: String = ""
////    @State var draft: CourseInfo
////    var index: Int
//
//
//    var body: some View {
//        Form {
//            TextField("Name", text: $name)
//            TextField("Notes", text: $notes, onCommit:  {
//
//            })
//        }
//    }
//}
//
//struct ConcentrationAdder_Previews: PreviewProvider {
//    static var previews: some View {
//        ConcentrationAdder(isPresented: .constant(true))
//    }
//}

