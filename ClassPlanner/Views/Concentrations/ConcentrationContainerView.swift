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
    @FetchRequest private var concentrations: FetchedResults<Concentration>
//    @State private var isAdding: Bool = false
    
    init(viewModel: CourseVM) {
        self.viewModel = viewModel
        let request = Concentration.fetchRequest(.all)
        _concentrations = FetchRequest(fetchRequest: request)
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: nil) {
            HStack {
                Text("Concentrations")
                Spacer()
            }
            ScrollView {
                ForEach (concentrations) {
                    ConcentrationView($0).zIndex( viewModel.dragConcentration == $0 ? 1 : 0)
                }
                EmptyConcentrationView()
            }
        }
        .padding([.horizontal], 10)
        .environmentObject(viewModel)
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
