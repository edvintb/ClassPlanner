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
    @EnvironmentObject var viewModel: CourseVM
    
    @State private var dragOffset: CGSize = .zero
    @State private var isTargeted: Bool = false
    @State private var isFrontUp: Bool = true
    @State private var isEditing: Bool = false
    @State private var color: Color?
    
    private var empty: Bool {
        course.name == ""
    }
    
    init(course: Course) {
        self.course = course
        _isFrontUp = State(wrappedValue: course.name != "")
    }
    
    var body: some View {
        ZStack(alignment: .center) {
            RoundedRectangle(cornerRadius: frameCornerRadius).stroke()
                .foregroundColor(color)
                .contentShape(RoundedRectangle(cornerRadius: frameCornerRadius))
                .shadow(color: isTargeted ? .green : color ?? .white, radius: isTargeted ? 10 : 0)
            
            if empty            { Text("+").font(.system(size: 2.5*titleSize)) }
            else if isFrontUp   { front.padding(5) }
            else                { back }
        }
        .opacity(dragOffset != .zero && viewModel.insideConcentration ? 0.001 : empty ? 0.2 : 1)
        .scaleEffect(isTargeted ? hoverScaleFactor : 1)
        .onHover { isTargeted = viewModel.hoverOverCourse(course: course, $0) }
        .zIndex(dragOffset == .zero ? 0 : 1)
        .offset(dragOffset)
        .gesture(tapGesture)
        .gesture(dragGesture)
        .frame(width: courseWidth, height: courseHeight, alignment: .center)
        .padding([.horizontal], 5)
        .popover(isPresented: $isEditing, content: {
            CourseEditorView(color: $color, isPresented: $isEditing)
                .environmentObject(viewModel)
                .environmentObject(course)
        })
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
                Text("+").font(.system(size: 1.2*titleSize, weight: .semibold)).onTapGesture { isEditing.toggle() }
            }
                .padding([.horizontal], 7)
            Divider()
                .padding([.horizontal], 5)
            ZStack {
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
                viewModel.objectWillChange.send()
                if viewModel.dragCourse == nil { viewModel.setDragCourse(to: course) }
            }
            .onEnded { _ in
                viewModel.courseDragEnded()
                dragOffset = .zero
            }
    }
    
    
    var tapGesture: some Gesture {
        TapGesture().onEnded {
            withAnimation(Animation.easeInOut(duration: 0.2)) {
                if empty { isEditing.toggle() }
                else { isFrontUp.toggle() }
            }
        }
    }
    
    func leftProperties() -> some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(" 🕑 \(NSNumber(value: course.workload), formatter: numberFormatter)")
            Text("  𝗤  ").foregroundColor(.red) + Text("\(NSNumber(value: course.qscore), formatter: numberFormatter)")
            Text(" 👥 \(NSNumber(value: course.enrollment), formatter: numberFormatter)")
            
        }
        .font(.system(size: iconSize, weight: .regular, design: .default))
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    func rightProperties() -> some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(" Pos: \(NSNumber(value: course.position), formatter: numberFormatter)")
            Text("\(course.fall ? "🍁 " : " - ")/\(course.spring ? " 🌱" : " -")")
            Text("  𝗤  ").foregroundColor(.red) + Text("\(NSNumber(value: course.qscore), formatter: numberFormatter)")
        }
        .font(.system(size: iconSize, weight: .regular, design: .default))
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    var numberFormatter: NumberFormatter {
        let numberFormatter = NumberFormatter()
        numberFormatter.maximumSignificantDigits = 4
        numberFormatter.roundingMode = .ceiling
        numberFormatter.zeroSymbol = ""
        return numberFormatter
    }
    
//    var deleteGesture: some Gesture {
//        TapGesture().onEnded { viewModel.deleteCourse(course) }
//    }
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


