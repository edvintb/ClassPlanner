//
//  ConcentrationContainerView.swift
//  ClassPlanner
//
//  Created by Edvin Berhan on 2021-05-03.
//

import SwiftUI

struct ConcentrationContainerView: View {
    
    @ObservedObject var viewModel: CourseVM
    @Environment(\.managedObjectContext) var context
    @Environment(\.colorScheme) var colorScheme
    @FetchRequest private var concentrations: FetchedResults<Concentration>
//    @State private var isAdding: Bool = false

    @State private var pointOfEnter: CGPoint?
    
    init(viewModel: CourseVM) {
        self.viewModel = viewModel
        let request = Concentration.fetchRequest(.all)
        _concentrations = FetchRequest(fetchRequest: request)
    }
    
    var body: some View {
        GeometryReader { geo in
            ZStack {
                VStack(alignment: .leading, spacing: nil) {
//                    HStack {
//                        Text("Concentrations")
//                        Spacer()
//                    }
 
                    ScrollView([.vertical, .horizontal]) {
                        VStack(alignment: .leading) {
                        Spacer(minLength: 5)
                        ForEach (concentrations) {
                            ConcentrationView($0)
                                .zIndex( viewModel.dragConcentration == $0 ? 1 : 0)
                                .padding([.horizontal], 10)
                        }
                        EmptyConcentrationView()
                            .padding([.horizontal], 10)
                        }
                    }
                }
                if viewModel.insideConcentration, let course = viewModel.dragCourse, let pos = viewModel.mouseLocation {
                    ZStack {
                        RoundedRectangle(cornerRadius: frameCornerRadius).stroke()
                            .foregroundColor(viewModel.getColor(course.color, dark: colorScheme == .dark))
                        Text(course.name)
                    }
                    .frame(width: courseWidth/2, height: courseHeight/2, alignment: .center)
                    .position(geo.convert(pos, from: .global))
                    .opacity(0.4)
                }
            }
        }
        .environmentObject(viewModel)
        .onHover { viewModel.insideConcentration = $0}
//            .onMove(perform: { indices, newOffset in
//                indices.map { index in concentrations[index] }
//                    .forEach{ concentration in concentration.index = newOffset }
//                print("\(indices)")
//                print("\(newOffset)")
//            })
        }
    
    
}
    
    
    
//
//    var addGesture: some Gesture {
//        TapGesture()
//            .onEnded {
//                isAdding = !isAdding
//                print(isAdding)
//        }
//    }
    


//struct ConcentrationContainerView_Previews: PreviewProvider {
//    static var previews: some View {
//        ConcentrationContainerView()
//    }
//}
