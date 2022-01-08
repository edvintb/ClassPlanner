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
    
    @State private var isCopied: Bool = false
    @State private var isShowingSettings: Bool = false
    
    var body: some View {
        VStack(spacing: topSectionStackSpacing) {
            scheduleTop(schedule: schedule).frame(height: topSectionheight)
            Divider().padding(.bottom, 3)
            GeometryReader { geo in
                ScrollView([.vertical, .horizontal], showsIndicators: true) {
                    VStack(alignment: .leading, spacing: topSectionStackSpacing) {
                        semestersView
                    }
                    .frame(minHeight: geo.size.height)
                }
            }
        }.sheet(isPresented: $isShowingSettings) {
            VStack(alignment: .trailing, spacing: 10) {
                Text("Settings")
                    .font(.title)
                    .frame(maxWidth: .infinity, alignment: .leading)
                SettingsView()
                Button(action: { isShowingSettings = false }, label: { Text("Close") })
            }
            .padding(20)
        }
    }
    
    func scheduleTop(schedule: ScheduleVM) -> some View {
        HStack(spacing: 20) {
            Text(schedule.name)
                .font(.system(size: 20))
                .foregroundColor(schedule.colorOption.color)
            Text(String(format: "\(gradeSymbol) %.2f", schedule.gradeAverage))
                .font(.system(size: 17))
//            Text("\(schedule.courseUrlSet.count) Course\(schedule.courseUrlSet.count == 1 ? "" : "s")")
//                .font(.system(size: 17))
            turnAllCoursesButton
            helpButton
            copyButton
            if isCopied {
                Text("A copy can be found in the Schedules tab")
            }
            Spacer()
            settingsButton
        }
        .contentShape(Rectangle())
        .onTapGesture { shared.setEditSelection(to: .schedule(schedule: schedule)) }
        .padding([.horizontal, .top], topSectionPadding)
    }
    
    var turnAllCoursesButton: some View {
        Button(
            action: { schedule.turnCourseViews() },
            label: { Text("▲▼") }
        )
    }
    
    var helpButton: some View {
        Button(
            action: {
                shared.showWelcomeSheet()
            },
            label: {
                if #available(macOS 11.0, *) {
                    Image(systemName: "info.circle")
                } else {
                    Text("Help")
                }
        })
    }
    
    var copyButton: some View {
        Button(
            action: {
                store.copySchedule(schedule: schedule)
                withAnimation {
                    isCopied = true
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {withAnimation {
                    isCopied = false
                }})
            },
            label: {
                if #available(macOS 11.0, *) {
                    Image(systemName: "doc.on.doc")
                } else {
                    Text("Copy")
                }
        })
    }
    
    var settingsButton: some View {
        Button(
            action: { isShowingSettings.toggle() },
            label: {
                if #available(macOS 11.0, *) {
                    Image(systemName: "gearshape")
                } else {
                    Text("Settings")
                }
            }
        )
    }
    
    
    
    var semestersView: some View {
        HStack {
            Spacer().frame(width: 5)
            ForEach (schedule.fetchCreateSemesters(for: 0..<shared.semestersToShow), id: \.self) { semester in
                SemesterView(semester: semester, shouldShowOnboarding: semester == 0, schedule: schedule, store: store)
                    .padding(.horizontal, courseHorizontalSpacing)
                if shared.isSemesterSystem && semester % 2 == 1 && semester != shared.semestersToShow - 1 {
                    Divider()
                }
                else if !shared.isSemesterSystem && semester % 4 == 3 && semester != shared.semestersToShow - 1 {
                    Divider()
                }
            }
            Spacer().frame(width: 5)
        }
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

