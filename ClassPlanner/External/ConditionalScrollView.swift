//
//  ConditionalScrollView.swift
//  ClassPlanner
//
//  Created by Edvin Berhan on 2021-06-04.
//

import SwiftUI

struct ConditionalScrollView<V>: View where V: View{
    
    var wanted: CGFloat
    var given: CGFloat
    var content: () -> V
    
    var body: some View {
        if wanted > given {
            ScrollView(content: content)
        }
        else {
            Group(content: content)
        }
    }
}
