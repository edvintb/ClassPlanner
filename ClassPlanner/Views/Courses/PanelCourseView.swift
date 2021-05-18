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




struct PanelCourseView: View {
    
    @ObservedObject var course: Course
    @ObservedObject var viewModel: CourseStore
    @Environment(\.colorScheme) var colorScheme
    
    @State private var isFrontUp: Bool = true
    
    private var color: Color { viewModel.getColor(course.color, dark: colorScheme == .dark) }

    var body: some View {
        ZStack(alignment: .center) {
            RoundedRectangle(cornerRadius: frameCornerRadius).stroke()
                .foregroundColor(color)
                .contentShape(RoundedRectangle(cornerRadius: frameCornerRadius))
            if isFrontUp { front }
            else         { back }
        }
        .gesture(tapGesture)
        .padding([.horizontal], 5)
        .frame(height: courseHeight, alignment: .center)

    }
    
    var front: some View {
        Text("\(course.name)")
            .font(.system(size: 1.3*titleSize))
            .allowsTightening(true)
            .lineLimit(3)
            .multilineTextAlignment(.center)
            .truncationMode(.tail)
            .frame(width: courseWidth, height: courseHeight, alignment: .center)
    }
    
    var back: some View {
        VStack(spacing: 0) {
            HStack(spacing: 0) {
                Text("\(course.name)").font(.system(size: titleSize)).frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
                Text("+").font(.system(size: 1.2*titleSize, weight: .semibold))
            }
                .contentShape(Rectangle())
//                .onTapGesture { viewModel.setEditCourse(course) }
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
    
    
    var tapGesture: some Gesture {
        TapGesture().onEnded {
            withAnimation(Animation.easeInOut(duration: 0.2)) {
                isFrontUp.toggle()
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


