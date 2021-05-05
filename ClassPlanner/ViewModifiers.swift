//
//  ViewModifiers.swift
//  ClassPlanner
//
//  Created by Edvin Berhan on 2021-03-27.
//

import SwiftUI

struct FrameAdder: ViewModifier {
    
    @Binding var frames: [CGRect]
    var position: Int
    
    func body(content: Content) -> some View {
        content
            .overlay(GeometryReader { geometry in
                Color.clear
                    .onAppear {
                        self.frames[position] = geometry.frame(in: .global)
                    }
            })
    }
}

extension View {
    func addFrameTo(_ frames: Binding<[CGRect]>, at position: Int) -> some View {
        self.modifier(FrameAdder(frames: frames, position: position))
    }
}
