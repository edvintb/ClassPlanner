//
//  ContentView.swift
//  ClassPlanner
//
//  Created by Edvin Berhan on 2021-03-20.
//

import SwiftUI

//enum DragState {
//    case good
//    case bad
//    case unknown
//}




struct CourseView: View {
    
    @ObservedObject var course: Course
    @EnvironmentObject var viewModel: ScheduleVM
    @Environment(\.colorScheme) var colorScheme
    
    @State private var dragOffset: CGSize = .zero
    @State private var isTargeted: Bool = false
    @State private var isDropping: Bool = false
    @State private var isFrontUp: Bool = true
    @State private var isEditing: Bool = false
    @State private var visible: Bool = true
    
    var isDragging: Bool { dragOffset != .zero }
    
//    @State private var editCourse: Course?
//
//    @State private var popModel: PopoverModel?
////    {
////        didSet { print("didSet to: \(isEditing)") }
////    }
//
//    struct PopoverModel: Identifiable {
//        var id: String { self.name }
//        var name: String
//    }
    
    private var color: Color { viewModel.getColor(course.color, dark: colorScheme == .dark) }
    private var empty: Bool { course.name == "" }
    
    init(course: Course) {
        self.course = course
        _isFrontUp = State(wrappedValue: course.name != "")
    }
    
    
    // Fix scrolling offset
    var body: some View {
        ZStack(alignment: .center) {
            RoundedRectangle(cornerRadius: frameCornerRadius).stroke()
                .foregroundColor(color)
                .contentShape(RoundedRectangle(cornerRadius: frameCornerRadius))
                .shadow(color: color, radius: isDropping ? hoverShadowRadius : 0)
                .shadow(color: color, radius: isDropping ? hoverShadowRadius : 0)
            
            
            if empty            { Text("\(course.position)").font(.system(size: 2.5*titleSize)) } 
            else if isFrontUp   { front.padding(5) }
            else                { back }
        }
//        .opacity(isDragging && viewModel.insideConcentration ? 0.001 : empty ? 0.2 : 1)
//        .opacity(visible ? 1 : 0)
        .opacity(empty ? 0.2 : 1)
        .scaleEffect(isDropping ? hoverScaleFactor : 1)
//        .onHover { isTargeted = viewModel.hoverOverCourse(course: course, $0) }
//        .zIndex(isDragging ? 1 : 0)
//        .offset(dragOffset)
        .gesture(tapGesture)
//        .gesture(dragGesture)
        .frame(width: courseWidth, height: courseHeight, alignment: .center)
        .padding([.horizontal], 5)
        .onDrop(of: ["public.utf8-plain-text"], isTargeted: $isDropping) { drop(providers: $0) }
        .onDrag { NSItemProvider(object: course.name as NSString) }
    }
    
    
    func drop(providers: [NSItemProvider]) -> Bool {
        print("Found")
        print(providers)
        let found = providers.loadFirstObject(ofType: String.self) { string in
            if let context = course.managedObjectContext {
                let newCourse = Course.withName(string as String, context: context)
                withAnimation {
                    if newCourse.semester == course.semester {
                        newCourse.moveInSemester(to: course.position)
                    }
                    else {
                        newCourse.moveToSemester(course.semester, and: course.position)
                    }
                }
            }
        }
        return found
    }
    
    var front: some View {
        Text("\(course.name)")
            .font(.system(size: 1.3*titleSize))
            .allowsTightening(true)
            .lineLimit(3)
            .multilineTextAlignment(.center)
            .truncationMode(.tail)
    }
    
    var back: some View {
        VStack(spacing: 0) {
            HStack(spacing: 0) {
                Text("\(course.name)").font(.system(size: titleSize)).frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
                Text("+").font(.system(size: 1.2*titleSize, weight: .semibold))
            }
                .contentShape(Rectangle())
                .onTapGesture { viewModel.setEditCourse(course) }
                .padding([.horizontal], 7)
            Divider()
                .padding([.horizontal], 5)
            VStack(alignment: .leading, spacing: 0) {
                HStack {
                    leftProperties()
                    rightProperties()
                }
            }
            .padding(5)
        }
        .lineLimit(1)
        .truncationMode(.tail)
    }

    var dragGesture: some Gesture {
        DragGesture(coordinateSpace: .global)
            .onChanged {
//              repositionCorrection = CGFloat(viewModel.startPosition! - course.position)
                dragOffset = CGSize(width: $0.translation.width, height: -$0.translation.height)
                viewModel.drag()
                if viewModel.dragCourse == nil { viewModel.setDragCourse(to: course) }
            }
            .onEnded { _ in
                visible = false
                withAnimation {
                    viewModel.courseDragEnded()
                    dragOffset = .zero
                }
                withAnimation(Animation.default.delay(0.05)) {
                    visible = true
                }
            }
    }
    
    
    var tapGesture: some Gesture {
        TapGesture().onEnded {
            if empty { viewModel.setEditCourse(course) }
            else {
                withAnimation(Animation.easeInOut(duration: 0.2)) {
                    isFrontUp.toggle()
                }
            }
        }
    }
    
    func leftProperties() -> some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(" \(workloadSymbol) \(NSNumber(value: course.workload), formatter: viewModel.numberFormatter)")
            Text("  \(qscoreSymbol)  ").foregroundColor(.red) + Text("\(NSNumber(value: course.qscore), formatter: viewModel.numberFormatter)")
            Text(" \(enrollmentSymbol) \(NSNumber(value: course.enrollment), formatter: viewModel.numberFormatter)")
            
        }
        .font(.system(size: iconSize, weight: .regular, design: .default))
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    func rightProperties() -> some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(" Pos: \(NSNumber(value: course.position), formatter: viewModel.numberFormatter)")
            Text("\(course.fall ? "\(fallSymbol) " : " - ")/\(course.spring ? " \(springSymbol)" : " -")")
            Text(" \(enrollmentSymbol) \(NSNumber(value: course.enrollment), formatter: viewModel.numberFormatter)")
            
        }
        .font(.system(size: iconSize, weight: .regular, design: .default))
        .frame(maxWidth: .infinity, alignment: .leading)
    }
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

}



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


