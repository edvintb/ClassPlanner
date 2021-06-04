//
//  ConcenterationEditorView.swift
//  ClassPlanner
//
//  Created by Edvin Berhan on 2021-06-04.
//

import SwiftUI

struct ConcentrationEditorView: View {
    
    let concentration: Concentration
    
    var body: some View {
        VStack {
            Spacer()
            Text("Concentration: \(concentration.name)")
            Spacer()
        }
    }
}
