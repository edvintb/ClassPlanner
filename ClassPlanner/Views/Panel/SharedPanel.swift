//
//  SharedPanel.swift
//  ClassPlanner
//
//  Created by Edvin Berhan on 2021-06-06.
//

import SwiftUI

struct PanelHeaderView<V>: View where V: View{
    
    let addAction: () -> ()
    
    let includeAddButton: Bool
    
    @Binding var searchQuery: String
    
    let panelContent: () -> V
    
    var body: some View {
        VStack(spacing: 2) {
            HStack {
                SearchTextField(query: _searchQuery)
                Spacer()
                if includeAddButton {
                    Button(action: { addAction() }, label: {
                        if #available(macOS 11.0, *) {
                            Image.init(systemName: "plus")
                        }
                        else {
                            Text("+").font(.system(size: 17))
                        }
                    })
                }
            }
            .padding(.horizontal, 5)
            .padding(.bottom, 2)
            
            panelContent()
        }
    }
}

struct NoResultsView: View {
    
    var body: some View {
            Text("No Results").opacity(transparentTextOpacity).font(.system(size: 20))
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
    }
}
