//
//  ColorGrid.swift
//  ClassPlanner
//
//  Created by Edvin Berhan on 2021-05-17.
//

import SwiftUI

struct EditorColorGrid: View {
    
    let tapAction: (Int) -> ()
    
    var body: some View {
        Grid(Array(1..<Color.colorSelection.count), id: \.self) { index in
            RoundedRectangle(cornerRadius: frameCornerRadius)
                .foregroundColor(Color.colorSelection[index])
                .onTapGesture { tapAction(index) }
                .padding(3)
        }
        .frame(height: 2*courseHeight)
    }
}
