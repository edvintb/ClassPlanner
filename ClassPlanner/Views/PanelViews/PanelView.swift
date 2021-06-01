//
//  PanelView.swift
//  ClassPlanner
//
//  Created by Edvin Berhan on 2021-05-15.
//

import SwiftUI

struct PanelView: View {
    
    @ObservedObject var scheduleStore: ScheduleStore
    @ObservedObject var courseStore: CourseStore
    @ObservedObject var panel: PanelVM
    
    @Environment(\.managedObjectContext) var context
    
    var body: some View {
        VStack(spacing: 0) {
            Spacer().frame(width: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, height: 7, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
            HStack {
                Group {
                    Spacer()
                    Text("Editor")
                        .foregroundColor(panel.currentPanelSelection == .editor(selection: .none) ? .blue : nil)
                        .onTapGesture { panel.setPanelSelection(to: .editor(selection: panel.currentEditSelection)) }
                    Spacer()
                    Text("Courses")
                        .foregroundColor(panel.currentPanelSelection == .courses ? .blue : nil)
                        .onTapGesture { panel.setPanelSelection(to: .courses) }
                    Spacer()
                    Text("Concen")
                        .foregroundColor(panel.currentPanelSelection == .concentrations ? .blue : nil)
                        .onTapGesture { panel.setPanelSelection(to: .concentrations) }
                    Spacer()
                }
                Group {
                    Text("Schedules")
                        .foregroundColor(panel.currentPanelSelection == .schedules ? .blue : nil)
                        .onTapGesture { panel.setPanelSelection(to: .schedules) }
                    Spacer()
                    Text("Other People")
                        .foregroundColor(panel.currentPanelSelection == .otherPeople ? .blue : nil)
                        .onTapGesture { panel.setPanelSelection(to: .otherPeople) }
                    Spacer()
                }
            }
            Spacer().frame(width: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, height: 5, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
            Divider()
            

            getPanelContent(panel.currentPanelSelection)
        }
        
        //            TabView(selection: $viewModel.currentPanelSelection,
        //                    content:  {
        //                        Text("Tab Content 1").tabItem { /*@START_MENU_TOKEN@*/Text("Tab Label 1")/*@END_MENU_TOKEN@*/ }.tag(1)
        //                        Text("Tab Content 2").tabItem { /*@START_MENU_TOKEN@*/Text("Tab Label 2")/*@END_MENU_TOKEN@*/ }.tag(2)
        //                    })
    }
    
    
    @ViewBuilder
    func getPanelContent(_ selection: PanelOption) -> some View {
        switch selection {
        case .courses:
            PanelCoursesView(courseStore: courseStore, scheduleStore: scheduleStore)
        case .concentrations:
            Text("Concentrations")
        case .editor(let editSelection):
            getEditor(editSelection).environmentObject(panel)
        case .schedules:
            PanelSchedules(panel: panel, store: scheduleStore)
        case .otherPeople:
            Text("Other People")
        }
    }
    
    @ViewBuilder
    func getEditor(_ selection: EditOption) -> some View {
        switch selection {
        case .course(let course):
            CourseEditorView(course: course, scheduleStore: scheduleStore, panel: panel)

        case .category(let category):
            CategoryEditorView(category: category, courseStore: CourseStore(context: context, panel: panel))
        case .concentration(let concentration):
            Text("Concentration: \(concentration.name)")
        case .schedule(let schedule):
            ScheduleEditorView(schedule: schedule, scheduleStore: scheduleStore)
                        .alert(isPresented: $scheduleStore.doubleNameAlert) {
                            Alert(title: Text("Naming Conflict"),
                                  message: Text("A schedule with that name already exists. Please pick another name."),
                                  dismissButton: .default(Text("OK"))
                        )}
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

//struct PanelView_Previews: PreviewProvider {
//    static var previews: some View {
//        PanelView()
//    }
//}
