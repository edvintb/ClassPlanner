//
//  ContentView.swift
//  ClassPlanner
//
//  Created by Edvin Berhan on 2021-03-20.
//

import SwiftUI

struct ScheduleCourseView: View {
    
    // Used to get current schedule
    @EnvironmentObject var shared: SharedVM
    
    @ObservedObject var course: Course
    
    @State private var isDropping: Bool = false
    
    var body: some View {
        CourseView(course: course)
            .onDrop(of: ["public.utf8-plain-text"], isTargeted: $isDropping) { drop(providers: $0) }
            .scaleEffect(isDropping ? hoverScaleFactor : 1)
            .opacity(course.name == "" ? emptyHoverOpacity : 1)
    }
    
    
    func drop(providers: [NSItemProvider]) -> Bool {
        let found = providers.loadFirstObject(ofType: String.self) { id in
            if let schedule = shared.currentSchedule {
                if let newCourse = getDroppedCourse(id: id) {
                    if let pos = schedule.getPosition(course: course) {
                        withAnimation {
                            schedule.moveCourse(newCourse, to: pos)
                        }
                    }
                }
            }
        }
        return found
    }
    
    private func getDroppedCourse(id: String) -> Course? {
        if let context = course.managedObjectContext {
            if let uri = URL(string: id) {
                if let newCourse = Course.fromURI(uri: uri, context: context) {
                    if newCourse == course { return nil }
                    return newCourse
                }
            }
        }
        return nil
    }
}



//        .opacity(isDragging && viewModel.insideConcentration ? 0.001 : empty ? 0.2 : 1)
//        .opacity(visible ? 1 : 0)
//        .gesture(dragGesture)
//        .onHover { isTargeted = viewModel.hoverOverCourse(course: course, $0) }
//        .zIndex(isDragging ? 1 : 0)
//        .offset(dragOffset)


//    @State private var isTargeted: Bool = false
//    @State private var visible: Bool = true
//    @State private var dragOffset: CGSize = .zero
//    var isDragging: Bool { dragOffset != .zero }
    
    //    var dragGesture: some Gesture {
    //        DragGesture(coordinateSpace: .global)
    //            .onChanged {
    ////              repositionCorrection = CGFloat(viewModel.startPosition! - course.position)
    //                dragOffset = CGSize(width: $0.translation.width, height: -$0.translation.height)
    //                viewModel.drag()
    //                if viewModel.dragCourse == nil { viewModel.setDragCourse(to: course) }
    //            }
    //            .onEnded { _ in
    //                visible = false
    //                withAnimation {
    //                    viewModel.courseDragEnded()
    //                    dragOffset = .zero
    //                }
    //                withAnimation(Animation.default.delay(0.05)) {
    //                    visible = true
    //                }
    //            }
    //    }
    
//
//    var title: some View {
//        let emptyName = course.name == ""
//        return Text(emptyName ? "Name" : course.name)
//            .font(.system(size: 20))
//            .foregroundColor(color)
//            .opacity(emptyName ? 0.2 : 1)
//            .lineLimit(2)
//            .fixedSize(horizontal: false, vertical: true)
//            .padding([.horizontal], 15)
//
//    }
//
//
//    var notes: some View {
//        let emptyNotes = course.notes == ""
//        return Text(emptyNotes ? "Notes..." : course.notes)
//            .font(.system(size: 12))
//            .opacity(emptyNotes ? 0.2 : 0.5)
//            .lineLimit(nil)
//            .fixedSize(horizontal: false, vertical: true)
//            .padding([.horizontal], 10)
//
//    }
//
//    var semesterSelector: some View {
//        HStack(alignment: .center, spacing: 10) {
//            Spacer()
//            Button(action: { course.fall.toggle(); save() }, label: {
//                Text("🍁")
//                    .shadow(color: course.fall ? .green : .black, radius: /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)
//            })
//            Button(action: { course.spring.toggle(); save() }, label: {
//                Text("🌱")
//                    .shadow(color: course.spring ? .green : .black, radius: /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)
//            })
//            Spacer()
//        }
//    }
//
//    var noteEditor: some View {
//        ZStack {
//            if #available(OSX 11.0, *) {
//                TextEditor(text: $course.notes)
//            } else {
//                TextField("Notes...", text: $course.notes, onCommit: { save() })
//            }
//        }
//    }
//
//    var colorGrid: some View {
//        Grid(Array(1..<viewModel.colors.count), id: \.self) { index in
//            RoundedRectangle(cornerRadius: frameCornerRadius)
//            .foregroundColor(viewModel.colors[index])
//            .onTapGesture { course.color = index; save(); print(course.color) }
//            .padding(3)
//        }
//    }
//
//
//    var bottomButtons: some View {
//        HStack {
////            Button("Delete") {
////                withAnimation {
////                    self.isPresented = false
////                    viewModel.deleteCourse(course)
////                }
////            }
////            Spacer()
////            Button("Save") {
////                withAnimation { self.isPresented = false; save() }
////            }
//        }
//
//    }
//
//    func save() {
//        if let context = course.managedObjectContext {
//            do {
//                course.objectWillChange.send()
//                try context.save()
//            } catch {
//                print("Unexpected Error: \(error)")
//            }
//        }
//    }
    
    //    func toggleEdit() {
    //        editCourse = course
    //        popModel = PopoverModel(name: course.name)
    //
    //        print("Toggling Edit")
    //        if isEditing { print("Returned bc already editing"); return }
    //        if viewModel.hasCoursePopover { viewModel.toggleCoursePopover(); print("Found course popover") }
    //        if isEditing { isEditing = false }
    //        if !isEditing && !viewModel.hasCoursePopover { isEditing = true; viewModel.toggleCoursePopover() }
//    var deleteGesture: some Gesture {
//        TapGesture().onEnded { viewModel.deleteCourse(course) }
//    }
    
    //        .popover(item: $editCourse) { course in
    ////            CourseEditorView(course: course)
    ////                .environmentObject(viewModel)
    ////            Text(course.name)
    //            VStack(alignment: .leading, spacing: 0) {
    //                Spacer(minLength: 15)
    //                title.frame(width: editorWidth, alignment: .leading)
    //                Divider().padding(5)
    //                notes.frame(width: editorWidth, alignment: .leading)
    //                // Add professor & prereqs
    //                // Suggestions as typed for prereq and professor
    //                // Multiline textfields for the others
    ////                Form {
    ////                    TextField("Name", text: $course.name, onCommit: { save() })
    ////                    semesterSelector
    ////                    TextField("Workload", value: $course.workload, formatter: numberFormatter, onCommit: { save() })
    ////                    TextField("QScore", value: $course.qscore, formatter: numberFormatter, onCommit: { save() })
    ////                    TextField("Enrollment", value: $course.enrollment, formatter: numberFormatter, onCommit: { save() })
    ////                    noteEditor
    ////                    colorGrid
    ////                    bottomButtons
    ////                }
    //                semesterSelector
    //                .frame(width: editorWidth, height: editorHeight, alignment: .center)
    //                .padding()
    //
    //            }
    //        }
    //        .popover(isPresented: $isEditing) {
    //            CourseEditorView(isPresented: $isEditing)
    //                .environmentObject(viewModel)
    //                .environmentObject(course)
    //                .onDisappear(perform: {
    //                    print("Disappeared: \(isEditing)")
    //                })
    //                .onAppear(perform: {
    //                    print("Appeared: \(isEditing)")
    //                })
    //        }
//
//    var flipGesture: some Gesture {
//        TapGesture().onEnded {
//            withAnimation(Animation.easeInOut(duration: 0.2)) {
//                isFrontUp.toggle()
//            }
//        }
//    }
//
//    var editGesture: some Gesture {
//        TapGesture().onEnded {
//            isEditing.toggle()
//            print(isEditing)
//        }
//    }


//        .offset(x: 0, y: (courseHeight + courseSpacing) * (repositionCorrection ?? 0))
//        .offset(x: 0, y: (viewModel.dragSemester == course.semester && course.semester != viewModel.startSemester && course.position >= viewModel.dragPosition ?? 100) ?
//                (courseHeight + courseSpacing) : 0)


// Make check quicker for same course as well

//    var dragColor: Color {
//        switch dragState {
//        case .good:
//            return .green
//        case .bad:
//            return .red
//        case .unknown:
//            return .white
//        }
//    }


