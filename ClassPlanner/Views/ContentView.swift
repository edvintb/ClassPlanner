//
//  ContentView.swift
//  ClassPlanner
//
//  Created by Edvin Berhan on 2021-04-24.
//

import SwiftUI

struct ContentView: View {
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            let vm = CourseVM()
            ScheduleView(viewModel: vm)
            ConcentrationContainerView(viewModel: vm)
        }
    }
}

//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        ContentView()
//    }
//}
