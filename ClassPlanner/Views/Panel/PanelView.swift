//
//  PanelView.swift
//  ClassPlanner
//
//  Created by Edvin Berhan on 2021-05-15.
//

import SwiftUI

struct PanelView: View {
    
    @EnvironmentObject var shared: SharedVM
    
    @ObservedObject var scheduleStore: ScheduleStore
    @ObservedObject var courseStoreVM: CourseStoreVM
    @ObservedObject var courseSuggestionVM: CourseSuggestionVM
    @ObservedObject var categorySuggestionVM: CategorySuggestionVM
    @ObservedObject var concentrationVM: ConcentrationVM
    @ObservedObject var prereqSuggestionVM: PrereqSuggestionVM
    @ObservedObject var schedule: ScheduleVM
    
    @Environment(\.managedObjectContext) var context
    
    @State private var isDropping: Bool = false
    
    // For onboarding
    @State private var isShowingCourseEditorOnboarding: Bool = false
    @State private var isShowingConcEditorOnboarding: Bool = false
    @State private var isShowingCategoryEditorOnboarding: Bool = false
    
    @State private var isShowingMajorStoreOnboarding: Bool = false

    
    var body: some View {
        VStack(spacing: topSectionStackSpacing) {
            symbolsView
                .frame(height: topSectionheight, alignment: .center)
            Divider().padding(.bottom, 3)
            getPanelContent(shared.currentPanelSelection)
        }
        .onDrop(of: ["public.utf8-plain-text"], isTargeted: $isDropping) { drop(providers: $0) }
        .onReceive(shared.$isShowingOnboarding.dropFirst()) { show in
            isShowingCourseEditorOnboarding = show
            isShowingConcEditorOnboarding = show
            isShowingCategoryEditorOnboarding = show
            isShowingMajorStoreOnboarding = show
        }
    }
    
    
    var symbolsView: some View {
        HStack {
            Spacer()
            ForEach (PanelOption.allCases, id: \.self) { option in
                Text(option.string)
                    .foregroundColor(shared.currentPanelSelection == option ? .blue : nil)
                    .contentShape(Rectangle())
                    .onTapGesture { shared.setPanelSelection(to: option) }
                    .font(.system(size: 16, weight: .regular, design: .default))
                Spacer()
            }
        }
        .padding(.top, topSectionPadding)
    }
    
    
    @ViewBuilder
    func getPanelContent(_ selection: PanelOption) -> some View {
        switch selection {
        case .editor:
            getEditor(shared.currentEditSelection)
        case .courses:
            CourseStoreView(storeVM: courseStoreVM)
        case .concentrations:
            ConcentrationStoreView(concentrationVM: concentrationVM, isShowingOnboarding: $isShowingMajorStoreOnboarding)
        case .schedules:
            ScheduleStoreView(store: scheduleStore)
        }
    }
    
    @ViewBuilder
    func getEditor(_ selection: EditOption) -> some View {
        switch selection {
        case .course(let course):
            CourseEditorView(
                course: course,
                courseSuggestionVM: courseSuggestionVM,
                prereqSuggestionVM: prereqSuggestionVM,
                context: context,
                isShowingOnboarding: $isShowingCourseEditorOnboarding)
            
        case .category(let category):
                CategoryEditorView(
                    category: category,
                    categorySuggestionVM: categorySuggestionVM,
                    context: context,
                    isShowingOnboarding: $isShowingCategoryEditorOnboarding
                )
            
        case .concentration(let concentration):
                ConcentrationEditorView(
                    concentration: concentration,
                    concentrationVM: concentrationVM,
                    schedule: schedule,
                    isShowingOnboarding: $isShowingConcEditorOnboarding
                )
        case .schedule(let schedule):
                ScheduleEditorView(schedule: schedule, scheduleStore: scheduleStore)
                    .onDisappear { scheduleStore.setName(schedule.name, for: schedule) }
        case .none:
            Text("No Selection")
                .font(.system(size: 15))
                .opacity(grayTextOpacity)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
        }
    }
    
    func drop(providers: [NSItemProvider]) -> Bool {
        let found = providers.loadFirstObject(ofType: String.self) { location in
            if let uri = URL(string: location) {
                if let schedule = shared.currentSchedule {
                    if let droppedObject = NSManagedObject.fromURI(uri: uri, context: context) {
                        withAnimation {
                            if let course = droppedObject as? Course {
                                schedule.removeCourse(course)
                                return
                            }
                            if let concentration = droppedObject as? Concentration {
                                concentrationVM.removeFromCurrentConcentrations(concentration)
                                return
                            }
//                            if let category = droppedObject as? Category {
//                                category.delete()
//                                return
//                            }
                        }
                    }
                }
            }
        }
        return found
    }
}


//            TabView(selection: $viewModel.currentPanelSelection,
//                    content:  {
//                        Text("Tab Content 1").tabItem { /*@START_MENU_TOKEN@*/Text("Tab Label 1")/*@END_MENU_TOKEN@*/ }.tag(1)
//                        Text("Tab Content 2").tabItem { /*@START_MENU_TOKEN@*/Text("Tab Label 2")/*@END_MENU_TOKEN@*/ }.tag(2)
//                    })


//                Group {
//                    Spacer()
//                    Text("Editor")
//                        .foregroundColor(panel.currentPanelSelection == .editor(selection: .none) ? .blue : nil)
//                        .onTapGesture { panel.setPanelSelection(to: .editor(selection: panel.currentEditSelection)) }
//                    Spacer()
//                    Text("Courses")
//                        .foregroundColor(panel.currentPanelSelection == .courses ? .blue : nil)
//                        .onTapGesture { panel.setPanelSelection(to: .courses) }
//                    Spacer()
//                    Text("Concen")
//                        .foregroundColor(panel.currentPanelSelection == .concentrations ? .blue : nil)
//                        .onTapGesture { panel.setPanelSelection(to: .concentrations) }
//                    Spacer()
//                }
//                Group {
//                    Text("Schedules")
//                        .foregroundColor(panel.currentPanelSelection == .schedules ? .blue : nil)
//                        .onTapGesture { panel.setPanelSelection(to: .schedules) }
//                    Spacer()
//                    Text("Other People")
//                        .foregroundColor(panel.currentPanelSelection == .otherPeople ? .blue : nil)
//                        .onTapGesture { panel.setPanelSelection(to: .otherPeople) }
//                    Spacer()
//                }

//struct PanelView_Previews: PreviewProvider {
//    static var previews: some View {
//        PanelView()
//    }
//}
