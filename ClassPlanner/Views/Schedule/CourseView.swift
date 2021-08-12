//
//  ContentView.swift
//  ClassPlanner
//
//  Created by Edvin Berhan on 2021-03-20.
//

import SwiftUI
import Combine

struct CourseView: View {
    
    // Used to set editor
    @EnvironmentObject var shared: SharedVM
    
    @ObservedObject var course: Course
    
    @State private var isDropping: Bool = false
    @State private var isFrontUp: Bool
    
    private var isEditingCourse: Bool {
        if case let .course(editingCourse) = shared.currentEditSelection {
            return editingCourse == self.course
        }
        return false
    }
    
    init(course: Course) {
        self.course = course
        _isFrontUp = State(wrappedValue: !course.name.isEmpty)
    }
    
    var body: some View {
        ZStack(alignment: .center) {
            container
            if course.isEmpty { EmptyView() }
            else if isFrontUp      { front }
            else              { back }
        }
        .onDrag { NSItemProvider(object: course.stringID as NSString) }
        .gesture(tapGesture)
        .frame(height: isFrontUp || course.isEmpty ? courseHeight : courseHeight + 27, alignment: .center)
        .onReceive(shared.currentSchedule!.$isCourseFrontUp.dropFirst()) { isFrontUp in
            withAnimation {
                self.isFrontUp = course.name != "" && isFrontUp
            }
        }
    }
    
    var container: some View {
        let color = course.getColor()
        return RoundedRectangle(cornerRadius: frameCornerRadius).stroke()
            .foregroundColor(color)
            .scaleEffect(isEditingCourse ? 1.04 : 1)
            .contentShape(RoundedRectangle(cornerRadius: frameCornerRadius))
            .shadow(color: color, radius: isEditingCourse ? hoverShadowRadius : 0)
            .shadow(color: color, radius: isEditingCourse ? hoverShadowRadius : 0)
            .opacity(course.name.isEmpty && !isEditingCourse ? emptyHoverOpacity : 1)
    }
    
    var front: some View {
        Text("\(course.name)")
            .font(.system(size: 1.3*titleSize))
            .allowsTightening(true)
            .lineLimit(3)
            .multilineTextAlignment(.center)
            .truncationMode(.tail)
            .padding(5)
    }
    
    var back: some View {
        VStack(spacing: 0) {
            HStack(spacing: 0) {
                Text("\(course.name)").font(.system(size: titleSize)).frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
                Text("+").font(.system(size: 1.2*titleSize, weight: .semibold))
            }
                .contentShape(Rectangle())
                .onTapGesture { shared.setEditSelection(to: .course(course: course)) }
                .padding(.horizontal, horizontalBackPadding)
            Divider()
                .padding(.horizontal, horizontalBackPadding - 2)
            VStack(alignment: .leading, spacing: 0) {
                HStack {
                    leftProperties()
                    rightProperties()
                }
                HStack(spacing: 0) {
                    Text("\(dateSymbol) ")
                    Text(dayString)
                    Spacer()
                    Text(DateFormatter.localizedString(from: course.time, dateStyle: .none, timeStyle: .short))
                }
                .font(.system(size: dayString.count < 6 ? iconSize : iconSize - 2  , weight: .regular, design: .default))
                .padding(.vertical, courseBackSpacing)
            }
            .padding(.top, 3)
            .padding(.bottom, horizontalBackPadding)
            .padding(.horizontal, horizontalBackPadding)
        }
        .lineLimit(1)
        .truncationMode(.tail)
    }
    
    var dayString: String {
        var days: String = ""
        if course.monday { days += "M" }
        if course.tuesday { days += "Tu" }
        if course.wednesday { days += "W" }
        if course.thursday { days += "Th" }
        if course.friday { days += "F" }
        return days.isEmpty ? " - " : days
    }
    

    func leftProperties() -> some View {
        VStack(alignment: .leading, spacing: courseBackSpacing) {
            Text("\(workloadSymbol) \(NSNumber(value: course.workload), formatter: NumberFormatter.courseFormat)")
            Text("\(qscoreSymbol) ").foregroundColor(.red) + Text("\(NSNumber(value: course.qscore), formatter: NumberFormatter.courseFormat)")
            Text("\(enrollmentSymbol) \(NSNumber(value: course.enrollment), formatter: NumberFormatter.courseFormat)")
        }
        .font(.system(size: iconSize, weight: .regular, design: .default))
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    func rightProperties() -> some View {
        VStack(alignment: .leading, spacing: courseBackSpacing) {
            Text("\(gradeSymbol)").font(.system(size: gradeSymbolSize)) + Text(" \(grade)").foregroundColor(Grade.color[course.enumGrade])
            Text("\(course.fall ? "\(fallSymbol)" : "  - ") \(course.spring ? "\(springSymbol)" : " -")")
//            Text(" \(enrollmentSymbol) \(NSNumber(value: course.enrollment), formatter: NumberFormatter.courseFormat)")
            Text(" Pre:  ") + (shared.currentSchedule?.containsPrereqs(for: course) ?? Text("-"))
        }
        .font(.system(size: iconSize, weight: .regular, design: .default))
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    var grade: String {
        if let grade = Grade.init(rawValue: course.grade) {
            return Grade.gradeString[grade] ?? "-"
        }
        return "-"
    }
    
    var tapGesture: some Gesture {
        TapGesture().onEnded {
            if course.name.isEmpty && course.isEmpty { shared.setEditSelection(to: .course(course: course)) }
            else {
                withAnimation(Animation.easeInOut(duration: 0.2)) {
                    isFrontUp.toggle()
                }
            }
        }
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


