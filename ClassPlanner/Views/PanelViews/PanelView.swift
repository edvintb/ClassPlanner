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
    @ObservedObject var panelVM: PanelVM
    
    @Environment(\.managedObjectContext) var context
    
    var body: some View {
        VStack(spacing: 0) {
            Spacer().frame(width: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, height: 7, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
            HStack {
                Group {
                    Spacer()
                    Text("Courses")
                        .foregroundColor(panelVM.currentPanelSelection == .courses ? .blue : nil)
                        .onTapGesture { panelVM.currentPanelSelection = .courses }
                    Spacer()
                    Text("Concen")
                        .foregroundColor(panelVM.currentPanelSelection == .concentrations ? .blue : nil)
                        .onTapGesture { panelVM.currentPanelSelection = .concentrations }
                    Spacer()
                }
                Group {
                    Text("Editor")
                        .foregroundColor(panelVM.currentPanelSelection == .editor(selection: .none) ? .blue : nil)
                        .onTapGesture { panelVM.currentPanelSelection = .editor(selection: .none) }
                    Spacer()
                    Text("Schedules")
                        .foregroundColor(panelVM.currentPanelSelection == .schedules ? .blue : nil)
                        .onTapGesture { panelVM.currentPanelSelection = .schedules }
                    Spacer()
                    Text("Other People")
                        .foregroundColor(panelVM.currentPanelSelection == .otherPeople ? .blue : nil)
                        .onTapGesture { panelVM.currentPanelSelection = .otherPeople }
                    Spacer()
                }
            }
            Spacer().frame(width: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, height: 5, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
            Divider()
            
//            TabView(selection: $viewModel.currentPanelSelection,
//                    content:  {
//                        Text("Tab Content 1").tabItem { /*@START_MENU_TOKEN@*/Text("Tab Label 1")/*@END_MENU_TOKEN@*/ }.tag(1)
//                        Text("Tab Content 2").tabItem { /*@START_MENU_TOKEN@*/Text("Tab Label 2")/*@END_MENU_TOKEN@*/ }.tag(2)
//                    })
            getPanelContent(panelVM.currentPanelSelection)
        }
    }
    
    
    @ViewBuilder
    func getPanelContent(_ selection: PanelOption) -> some View {
        switch selection {
        case .courses:
            PanelCoursesView(courseStore: courseStore)
        case .concentrations:
            Text("Concentrations")
        case .editor(let editSelection):
            getEditor(editSelection)
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
            CourseEditorView(course: course)
        case .category(let category):
            CategoryEditorView(category: category, courseStore: CourseStore(context: context))
        case .concentration(let concentration):
            Text("Concentration: \(concentration.name)")
        case .none:
            VStack {
                Text("No Selection")
                    .font(.system(size: 15))
                    .opacity(0.3)
            }
            
        }
        
        
    }
}

//struct PanelView_Previews: PreviewProvider {
//    static var previews: some View {
//        PanelView()
//    }
//}
