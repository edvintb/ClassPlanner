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
    @ObservedObject var panel: PanelVM
    
    @Environment(\.managedObjectContext) var context
    
    var body: some View {
        VStack(spacing: 0) {
            Spacer().frame(width: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, height: 7, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
            HStack {
                Spacer()
                ForEach(PanelOption.allCases, id: \.self) { option in
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
        
        //            TabView(selection: $viewModel.currentPanelSelection,
        //                    content:  {
        //                        Text("Tab Content 1").tabItem { /*@START_MENU_TOKEN@*/Text("Tab Label 1")/*@END_MENU_TOKEN@*/ }.tag(1)
        //                        Text("Tab Content 2").tabItem { /*@START_MENU_TOKEN@*/Text("Tab Label 2")/*@END_MENU_TOKEN@*/ }.tag(2)
        //                    })
    }
    
    
    @ViewBuilder
    func getPanelContent(_ selection: PanelOption) -> some View {
        switch selection {
        case .editor:
            getEditor(shared.currentEditSelection)
        case .courses:
            PanelCoursesView(courseStore: courseStore)
        case .concentrations:
            VStack {
                Spacer()
                Text("Concentrations")
                Spacer()
            }
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
            // Giving it a new courseStore or keeping the same one??
            CategoryEditorView(category: category, courseStore: courseStore)
        case .concentration(let concentration):
            Text("Concentration: \(concentration.name)")
        case .schedule(let schedule):
            ScheduleEditorView(schedule: schedule, scheduleStore: scheduleStore)
                        .alert(isPresented: $scheduleStore.doubleNameAlert) {
                            Alert(title: Text("Naming Conflict"),
                                  message: Text("A schedule with that name already exists.\nPlease pick another name."),
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




//            HStack {
//                Group {
//                    Spacer()
//                    Text("Editor")
//                        .foregroundColor(shared.currentPanelSelection == .editor(selection: .none) ? .blue : nil)
//                        .onTapGesture { shared.setPanelSelection(to: .editor(selection: shared.currentEditSelection)) }
//                    Spacer()
//                    Text("Courses")
//                        .foregroundColor(shared.currentPanelSelection == .courses ? .blue : nil)
//                        .onTapGesture { shared.setPanelSelection(to: .courses) }
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
//            }
//struct PanelView_Previews: PreviewProvider {
//    static var previews: some View {
//        PanelView()
//    }
//}
