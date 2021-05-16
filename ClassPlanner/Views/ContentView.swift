//
//  ContentView.swift
//  ClassPlanner
//
//  Created by Edvin Berhan on 2021-04-24.
//

import SwiftUI

struct ContentView: View {
    
    @ObservedObject var vm: CourseVM
//    @Environment(\.managedObjectContext) var context
    
    var body: some View {
//        NavigationView {
//            EditorView(viewModel: vm).frame(minWidth: editorWidth*1.1, idealWidth: editorWidth*1.2, maxWidth: .infinity, alignment: .top).padding(5)
            HSplitView {
                PanelView(viewModel: vm)
                    .frame(minWidth: editorWidth*1.1, idealWidth: editorWidth*1.2, maxWidth: .infinity, alignment: .top)
                VSplitView {
                    ScheduleView(viewModel: vm)
                                .frame(minHeight: 200, idealHeight: 200, maxHeight: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                    ConcentrationContainerView(viewModel: vm)
                                .frame(minHeight: 150, idealHeight: 150, maxHeight: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                }
                .frame(minWidth: 200, idealWidth: 600, maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
            }
//        }
        

    }
}

//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        ContentView()
//    }
//}
