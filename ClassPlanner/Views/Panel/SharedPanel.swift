//
//  SharedPanel.swift
//  ClassPlanner
//
//  Created by Edvin Berhan on 2021-06-06.
//

import SwiftUI

struct PanelHeaderView<V>: View where V: View{
    
    let addAction: () -> ()
    
    @Binding var searchQuery: String
    
    let panelContent: () -> V
    
    var body: some View {
        VStack(spacing: 2) {
            HStack {
                SearchTextField(query: _searchQuery)
                Spacer()
                Button(action: { addAction() }, label: {
                    Text("􀅼")
                })
               
            }
            .padding(.horizontal, 5)
            .padding(.bottom, 2)
            
            panelContent()
        }
    }
}
