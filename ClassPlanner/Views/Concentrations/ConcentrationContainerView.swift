//
//  ConcentrationContainerView.swift
//  ClassPlanner
//
//  Created by Edvin Berhan on 2021-05-03.
//

import SwiftUI

struct ConcentrationContainerView: View {
    
    @ObservedObject var concentrationVM: ConcentrationVM
    
    // Needed if I want to color concentrations
    @Environment(\.colorScheme) var colorScheme
    @FetchRequest private var concentrations: FetchedResults<Concentration>

    init(concentrationVM: ConcentrationVM) {
        self.concentrationVM = concentrationVM
        let request = Concentration.fetchRequest(.all)
        _concentrations = FetchRequest(fetchRequest: request)
    }
    
    var body: some View {
        GeometryReader { geo in
            ScrollView([.vertical, .horizontal]) {
                VStack(alignment: .leading) {
                Spacer(minLength: 5)
                ForEach (concentrations) { concentration in
                    ConcentrationView(concentration, vm: concentrationVM)
                        .padding([.horizontal], 10)
                }
                EmptyConcentrationView()
                    .padding([.horizontal], 10)
                }
                .frame(minWidth: geo.frame(in: .local).width , maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, minHeight: geo.frame(in: .local).height, maxHeight: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, alignment: .topLeading)

            }
        }
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
