//
//  EmptyCategoryView.swift
//  ClassPlanner
//
//  Created by Edvin Berhan on 2021-05-02.
//

import SwiftUI

struct EmptyCategoryView: View {
    
    @ObservedObject var concentration: Concentration
    
    @State private var isTargeted: Bool = false
    
    var body: some View {
        VStack {
            RoundedRectangle(cornerRadius: frameCornerRadius).stroke()
                .contentShape(RoundedRectangle(cornerRadius: frameCornerRadius))
                .opacity(isTargeted ? emptyHoverOpacity : 0)
                .onHover { isTargeted = $0 }
                .onTapGesture { concentration.addCategory() }
        }
//            RoundedRectangle(cornerRadius: frameCornerRadius).opacity(0.001)
//                .frame(minWidth: 0, maxWidth: .infinity, minHeight: /*@START_MENU_TOKEN@*/0/*@END_MENU_TOKEN@*/, maxHeight: categoryHeight, alignment: .center)
    }
}
//    var addGesture: some Gesture {
//        TapGesture().onEnded {
//            print("Tapped")
//        }
//    }

//
//struct EmptyCategoryView_Previews: PreviewProvider {
//    static var previews: some View {
//        EmptyCategoryView()
//    }
//}

//
