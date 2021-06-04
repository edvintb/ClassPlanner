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
            .frame(height: concentrationHeight)
            .contentShape(RoundedRectangle(cornerRadius: frameCornerRadius))
            .opacity(isTargeted ? emptyHoverOpacity : 0)
            .onHover { isTargeted = $0 }
            .onTapGesture { Concentration.createEmpty(in: context) }
    }
}
