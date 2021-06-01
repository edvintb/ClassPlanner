//
//  EmptyConcentrationView.swift
//  ClassPlanner
//
//  Created by Edvin Berhan on 2021-05-02.
//

import SwiftUI

struct EmptyConcentrationView: View {
    
    @Environment(\.managedObjectContext) var context
    @State private var isTargeted: Bool = false
    
    var body: some View {
        RoundedRectangle(cornerRadius: frameCornerRadius).stroke()
            .frame(minWidth: /*@START_MENU_TOKEN@*/0/*@END_MENU_TOKEN@*/, maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, minHeight: concentrationHeight, maxHeight: concentrationHeight, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
            .contentShape(RoundedRectangle(cornerRadius: frameCornerRadius))
            .opacity(isTargeted ? emptyHoverOpacity : 0)
            // Change to be able to drop concentrations here?
            .onHover { isTargeted = $0 }
            .onTapGesture { Concentration.createEmpty(in: context) }
    }
}


//
//struct EmptyConcentrationView_Previews: PreviewProvider {
//    static var previews: some View {
//        EmptyConcentrationView()
//    }
//}
