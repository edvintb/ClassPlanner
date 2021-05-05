//
//  EmptyCategoryView.swift
//  ClassPlanner
//
//  Created by Edvin Berhan on 2021-05-02.
//

import SwiftUI

struct EmptyCategoryView: View {
    
    let concentration: Concentration
    @Environment(\.managedObjectContext) var context
    @EnvironmentObject var viewModel: CourseVM
    @State private var isTargeted: Bool = false
    
    var body: some View {
        HStack {
            RoundedRectangle(cornerRadius: frameCornerRadius).stroke()
                .contentShape(RoundedRectangle(cornerRadius: frameCornerRadius))
                .frame(width: categoryWidth, height: categoryHeight, alignment: .center)
                .opacity(isTargeted ? emptyHoverOpacity : 0)
                .onHover { isTargeted = $0 }
                .onTapGesture { viewModel.addEmptyCategory(to: concentration, in: context) }
            RoundedRectangle(cornerRadius: frameCornerRadius).opacity(0.001)
                .frame(minWidth: 0, maxWidth: .infinity, minHeight: /*@START_MENU_TOKEN@*/0/*@END_MENU_TOKEN@*/, maxHeight: categoryHeight, alignment: .center)
                .background(Color.red)
        }
    }
    
//    var addGesture: some Gesture {
//        TapGesture().onEnded {
//            print("Tapped")
//        }
//    }
}
//
//struct EmptyCategoryView_Previews: PreviewProvider {
//    static var previews: some View {
//        EmptyCategoryView()
//    }
//}

//
