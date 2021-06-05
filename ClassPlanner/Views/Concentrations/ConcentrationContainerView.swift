//
//  ConcentrationContainerView.swift
//  ClassPlanner
//
//  Created by Edvin Berhan on 2021-05-03.
//

import SwiftUI

struct ConcentrationContainerView: View {
    
    @EnvironmentObject var shared: SharedVM
    
    @ObservedObject var schedule: ScheduleVM
    
//    @FetchRequest private var concentrations: FetchedResults<Concentration>
    
    private var concentrations: [Concentration] {
        shared.currentConcentrations.sorted(by: { $0.index < $1.index })
    }
    
    var body: some View {
        GeometryReader { geo in
            ScrollView([.vertical]) {
                concentrationViews
                    // Set the frame to take up entire scrollView
                    .frame(minHeight: geo.size.height, alignment: .topLeading)

            }
        }
    }
    
    var concentrationViews: some View {
        VStack(alignment: .leading) {
            Spacer(minLength: 4)
            ForEach (concentrations) { concentration in
                ConcentrationWithCategories(concentration: concentration, schedule: schedule)
            }
            EmptyConcentrationView()
        }
        .padding(.horizontal, 5)
    }
}

//    @State private var isAdding: Bool = false

//    private var pos: (() -> CGPoint)?
    
//                if viewModel.insideConcentration, let course = viewModel.dragCourse, let pos = pos {
//                    ZStack {
//                        RoundedRectangle(cornerRadius: frameCornerRadius).stroke()
//                            .foregroundColor(viewModel.getColor(course.color, dark: colorScheme == .dark))
//                        Text(course.name)
//                    }
//                    .frame(width: courseWidth/2, height: courseHeight/2, alignment: .center)
//                    .position(geo.convert(pos(), from: .global))
////                    .offset(x: NSEvent.mouseLocation.x, y: -NSEvent.mouseLocation.y)
////                    .offset(getOffset(from: geo.convert(pos(), from: .global), in: geo.frame(in: .global)))
//                    .opacity(0.4)
//                }

//            .onMove(perform: { indices, newOffset in
//                indices.map { index in concentrations[index] }
//                    .forEach{ concentration in concentration.index = newOffset }
//                print("\(indices)")
//                print("\(newOffset)")
//            })
    
//    func getOffset(from point: CGPoint, in frame: CGRect) -> CGSize {
//        let height = point.y - frame.height/2
//        let width = point.x - frame.width/2
//        return CGSize(width: width, height: height)
//    }
//
//

    
    
    
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
