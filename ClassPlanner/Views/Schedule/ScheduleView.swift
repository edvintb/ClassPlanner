//
//  ScheduleView.swift
//  ClassPlanner
//
//  Created by Edvin Berhan on 2021-05-18.
//

import SwiftUI

struct ScheduleView: View {
    
    @EnvironmentObject var shared: SharedVM
    @ObservedObject var store: ScheduleStore
    @ObservedObject var schedule: ScheduleVM
    
    @State private var isShowingContent: Bool = false
    
    var body: some View {
        GeometryReader { geo in
            ScrollView([.vertical, .horizontal]) {
                VStack(alignment: .leading, spacing: 7) {
                    scheduleName(schedule: schedule)
                    Divider().padding(.bottom, 3)
                        .frame(width: (courseWidth + 8)*CGFloat(schedule.semesters.count))
                    semesters
                    Spacer().frame(height: geo.size.height)
                }
                .frame(minWidth: geo.size.width, alignment: .topLeading)
//            }
//            ScrollView([.vertical, .horizontal]) {
//                if isShowingContent {
//                    scrollViewContent
//                        .frame(minWidth: geo.size.width, alignment: .topLeading)
//                }
//            }
//            .onAppear { isShowingContent = true }
            }
        }
        
    }
    
//    var scrollViewContent: some View {
//        VStack(alignment: .leading, spacing: 2) {
//            scheduleName(schedule: schedule)
//            Divider().padding([.leading, .bottom], 3)
//                .frame(width: (courseWidth + 8)*CGFloat(schedule.semesters.count))
//            semesters
////            Spacer().frame(height: geo.size.height)
//        }
//    }
    
    func scheduleName(schedule: ScheduleVM) -> some View {
        HStack(spacing: 20) {
            Text(schedule.name)
                .font(.system(size: 20))
                .foregroundColor(schedule.color)
            Text(String(format: "\(gradeSymbol) %.1f", schedule.gradeAverage))
                .font(.system(size: 13))
        }
        
        .contentShape(Rectangle())
        .onTapGesture { shared.setEditSelection(to: .schedule(schedule: schedule)) }
        .padding([.horizontal, .top], 8)
    }
    
    var semesters: some View {
        let semesters = schedule.semesters
        return
            HStack {
                Spacer().frame(width: 5)
                ForEach (semesters, id: \.self) { semester in
                    SemesterView(semester: semester, schedule: schedule)
                }
                Spacer().frame(width: 5)
            }
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

