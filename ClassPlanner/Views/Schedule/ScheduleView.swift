//
//  ScheduleView.swift
//  ClassPlanner
//
//  Created by Edvin Berhan on 2021-05-18.
//

import SwiftUI

struct ScheduleView: View {
    
    let leftEdgePadding: CGFloat = 8
    @EnvironmentObject var shared: SharedVM
    @ObservedObject var store: ScheduleStore
    @ObservedObject var schedule: ScheduleVM
    
    // For onboarding
    @State private var isShowingOnboarding: Bool = !UserDefaults.standard.bool(forKey: scheduleOnboardingKey)
    private func setScheduleOnboarding(show: Bool) {
        withAnimation {
            self.isShowingOnboarding = show
            UserDefaults.standard.setValue(!show, forKey: scheduleOnboardingKey)
        }
    }
    
//    private var maxNumberCoursesInSemester: CGFloat {
//        CGFloat(schedule.semesters.map { schedule.courses(for: $0).count }.max() ?? 0)
//    }
    
    private var isCatalina: Bool {
        if #available(macOS 11.0, *) { return false }
        else { return true }
    }
    
    // Adopt the frame to scroll less
    var body: some View {
        GeometryReader { geo in
            ScrollView([.vertical, .horizontal], showsIndicators: isCatalina) {
                VStack(alignment: .leading, spacing: 7) {
                    scheduleTop(schedule: schedule)
                    Divider().padding(.bottom, 3)
                    semesters
                    Spacer().frame(height: geo.size.height - 215)
                }
                .frame(minWidth: geo.size.width - 15, alignment: .topLeading)
                .onReceive(shared.$isShowingOnboarding.dropFirst()) { show in
                    setScheduleOnboarding(show: show)
                }
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
    
    func scheduleTop(schedule: ScheduleVM) -> some View {
        HStack(spacing: 20) {
            Text(schedule.name)
                .font(.system(size: 20))
                .foregroundColor(schedule.color)
            Text(String(format: "\(gradeSymbol) %.2f", schedule.gradeAverage))
                .font(.system(size: 17))
            Text("\(schedule.courseUrlSet.count) Course\(schedule.courseUrlSet.count == 1 ? "" : "s")")
                .font(.system(size: 17))
            Button(
                action: { schedule.turnCourseViews() },
                label: { Text("⟳") }
            )
            helpButton
            Spacer()
        }
        .contentShape(Rectangle())
        .onTapGesture { shared.setEditSelection(to: .schedule(schedule: schedule)) }
        .padding([.horizontal, .top], leftEdgePadding)
        .popover(isPresented: $isShowingOnboarding) {
            ScheduleOnboardingView(
                isShowingOnboarding: $isShowingOnboarding,
                setScheduleOnboarding: self.setScheduleOnboarding
            )
        }
    }
    
    var helpButton: some View {
        Button(shared.isShowingOnboarding ? "Hide Help" : "Show Help", action: shared.toggleOnboarding)
    }
    
    var semesters: some View {
        let semesters = schedule.semesters
        return
            HStack {
                Spacer().frame(width: 5)
                ForEach (semesters, id: \.self) { semester in
                    SemesterView(semester: semester, schedule: schedule)
                        .padding(.horizontal, courseHorizontalSpacing)
                    if semester % 2 == 1 {
                        Divider()
                    }
                }
                Spacer().frame(width: 5)
                VStack {
                    Button(action: schedule.addSemester, label: {
                        Text("Add Semester")
                    })
                    Spacer()
                }
                .padding(.trailing, leftEdgePadding)
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

