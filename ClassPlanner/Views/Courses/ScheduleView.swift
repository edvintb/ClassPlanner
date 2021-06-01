//
//  ScheduleView.swift
//  ClassPlanner
//
//  Created by Edvin Berhan on 2021-05-18.
//

import SwiftUI

struct ScheduleView: View {
    
    @EnvironmentObject var panel: PanelVM
    @ObservedObject var store: ScheduleStore
    @ObservedObject var schedule: ScheduleVM
    
    var body: some View {
        GeometryReader { geo in
            ScrollView([.vertical, .horizontal]) {
                VStack(alignment: .leading, spacing: 2) {
                    scheduleName(schedule: schedule)
                    Divider()
                        .padding([.leading, .bottom], 3)
                        .frame(width: (courseWidth + 2*courseSpacing)*CGFloat(schedule.semesters.count))
                    HStack {
                        ForEach (schedule.semesters, id: \.self) { semester in
                            SemesterView(for: semester, schedule: schedule)
                        }
                    }
                    .frame(minWidth: geo.frame(in: .local).width, minHeight: geo.frame(in: .local).height, alignment: .topLeading)
                    }
                }
            }
    }
    
    func scheduleName(schedule: ScheduleVM) -> some View {
        Text(schedule.name)
            .foregroundColor(schedule.color)
            .font(.system(size: 20))
            .contentShape(Rectangle())
            .onTapGesture { panel.setEditSelection(to: .schedule(schedule: schedule)) }
            .padding([.horizontal, .top], 8)
    }
}


struct CurrentScheduleView: View {
    
    @ObservedObject var schedule: ScheduleVM
    
    var body: some View {
        Text("Hello")
    }
    
//    var nameEditor: some View {
//        VStack {
//            TextField("Name", text: $concentration.name, onCommit: {
//                isEditingName = false
//            })
//            
//        }
//    }
//    
//    func titleText(name: String) -> some View {
//        Text(name)
//            .font(.system(size: 20))
//            .onTapGesture { isEditingName.toggle() }
//            .popover(isPresented: $isEditingName, content: { nameEditor.padding(5) })
//    }
}
//                GeometryReader{ geo in
//                if viewModel.draggedPanelToSchedule {
//                    if let course = viewModel.dragCourse {
//                        CourseView(course: course)
//                        .frame(width: courseWidth, height: courseHeight, alignment: .center)
//                            .position(geo.convert(pos(), from: .global))
//        //                    .offset(x: NSEvent.mouseLocation.x, y: -NSEvent.mouseLocation.y)
////                            .offset(getOffset(from: geo.convert(pos(), from: .global), in: geo.frame(in: .global)))
////                        .onHover { _ in print(geo.frame(in: .global)); print(pos); print(geo.convert(pos(), from: .global))}
//                        .environmentObject(viewModel)
//                        .zIndex(1)
//                    }
//                }
//            }
//            .background(Color.red)

//
//    func getOffset(from point: CGPoint, in frame: CGRect) -> CGSize {
//        let height = point.y
//        let width = point.x - frame.width/2
//        return CGSize(width: width, height: height)
//    }

