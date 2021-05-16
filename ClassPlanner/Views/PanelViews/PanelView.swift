//
//  PanelView.swift
//  ClassPlanner
//
//  Created by Edvin Berhan on 2021-05-15.
//

import SwiftUI

struct PanelView: View {
    
    @ObservedObject var viewModel: CourseVM
    
    var body: some View {
        VStack(spacing: 0) {
            Spacer().frame(width: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, height: 7, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
            HStack {
                Group {
                    Spacer()
                    Text("Courses")
                        .foregroundColor(viewModel.currentPanelSelection == .courses ? .blue : nil)
                        .onTapGesture { viewModel.currentPanelSelection = .courses }
                    Spacer()
                    Text("Concen")
                        .foregroundColor(viewModel.currentPanelSelection == .concentrations ? .blue : nil)
                        .onTapGesture { viewModel.currentPanelSelection = .concentrations }
                    Spacer()
                }
                Group {
                    Text("Editor")
                        .foregroundColor(viewModel.currentPanelSelection == .editor(selection: .none) ? .blue : nil)
                        .onTapGesture { viewModel.currentPanelSelection = .editor(selection: viewModel.currentEditSelection) }
                    Spacer()
                    Text("Schedules")
                        .foregroundColor(viewModel.currentPanelSelection == .schedules ? .blue : nil)
                        .onTapGesture { viewModel.currentPanelSelection = .schedules }
                    Spacer()
                    Text("Other People")
                        .foregroundColor(viewModel.currentPanelSelection == .otherPeople ? .blue : nil)
                        .onTapGesture { viewModel.currentPanelSelection = .otherPeople }
                    Spacer()
                }
            }
            Spacer().frame(width: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, height: 5, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
            Divider()
            getPanelContent(viewModel.currentPanelSelection).environmentObject(viewModel)
            Spacer()
        }
    }
    
    
    @ViewBuilder
    func getPanelContent(_ selection: PanelOption) -> some View {
        switch selection {
        case .courses:
            PanelCoursesView()
        case .concentrations:
            Text("Concentrations")
        case .editor(let editSelection):
            getEditor(editSelection)
        case .schedules:
            Text("Schedules")
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
            CategoryEditorView(category: category)
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
