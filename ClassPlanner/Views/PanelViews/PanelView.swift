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
    @ObservedObject var courseStore: CourseStore
    @ObservedObject var courseSuggestionVM: CourseSuggestionVM
    
    @Environment(\.managedObjectContext) var context
    
    var body: some View {
        VStack(spacing: 0) {
            Spacer().frame(width: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, height: 7, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
            HStack {
                Spacer()
                ForEach (PanelOption.allCases, id: \.self) { option in
                    Text(PanelOption.symbols[option] ?? "X")
                        .foregroundColor(shared.currentPanelSelection == option ? .blue : nil)
                        .onTapGesture { shared.setPanelSelection(to: option) }
                    Spacer()
                }
            }
            Spacer().frame(width: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, height: 5, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
            Divider()
            

            getPanelContent(shared.currentPanelSelection)
        }

    }
    
    
    @ViewBuilder
    func getPanelContent(_ selection: PanelOption) -> some View {
        switch selection {
        case .editor:
            getEditor(shared.currentEditSelection)
        case .courses:
            PanelCoursesView(courseStore: courseStore, scheduleStore: scheduleStore)
        case .concentrations:
            PanelConcentrations()
        case .schedules:
            PanelSchedules(store: scheduleStore)
        case .otherPeople:
            Text("Other People")
        }
    }
    
    @ViewBuilder
    func getEditor(_ selection: EditOption) -> some View {
        switch selection {
        case .course(let course):
            CourseEditorView(course: course, scheduleStore: scheduleStore, courseSuggestionVM: courseSuggestionVM, context: context)
        case .category(let category):
            CategoryEditorView(category: category, courseStore: CourseStore(context: context))
        case .concentration(let concentration):
            Text("Concentration: \(concentration.name)")
        case .schedule(let schedule):
            ScheduleEditorView(schedule: schedule, scheduleStore: scheduleStore)
                .alert(item: $scheduleStore.existingNameAlert) { nameString in
                    Alert(title: Text("Naming Conflict"),
                          message: Text("Existing schedule with name: \(nameString.value) \nPlease pick another name."),
                          dismissButton: .default(Text("OK")))
                }
                .onDisappear { scheduleStore.setName(schedule.name, for: schedule) }
//
//                .alert(isPresented: $scheduleStore.doubleNameAlert) {
//                    Alert(title: Text("Naming Conflict"),
//                          message: Text("A schedule with that name already exists.\nPlease pick another name."),
//                          dismissButton: .default(Text("OK"))
//                )}
                
//                        .alert(isPresented: $scheduleStore.emptyNameAlert) {
//                            Alert(title: Text("Empty Name"),
//                                  message: Text("A schedule must have a name."),
//                                  dismissButton: .default(Text("OK"))
//                        )}
//                .onDisappear { scheduleStore.setName(schedule.name, for: schedule) }
        case .none:
            VStack {
                Spacer()
                Text("No Selection")
                    .font(.system(size: 15))
                    .opacity(0.3)
                Spacer()
            }
            
        }
        
        
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
