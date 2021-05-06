//
//  ContentView.swift
//  ClassPlanner
//
//  Created by Edvin Berhan on 2021-04-24.
//

import SwiftUI

struct ContentView: View {
    
    var body: some View {
        VStack(alignment: .leading, spacing: /*@START_MENU_TOKEN@*/nil/*@END_MENU_TOKEN@*/) {
            let vm = CourseVM()
            ScheduleView(viewModel: vm).zIndex(1)
            ConcentrationContainerView(viewModel: vm)
        }
    }
}

//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        ContentView()
//    }
//}
