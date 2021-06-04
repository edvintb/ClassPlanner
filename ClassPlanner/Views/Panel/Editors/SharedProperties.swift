//
//  ViewModifiers.swift
//  ClassPlanner
//
//  Created by Edvin Berhan on 2021-05-17.
//

import SwiftUI

//struct EditorTitleModifier: ViewModifier {
//    
//    func body(content: Content) -> some View {
//        content
//            .font(.system(size: 20))
//            .lineLimit(2)
//            .fixedSize(horizontal: false, vertical: true)
//            .padding([.horizontal], 15)
//    }
//
//}

struct EditorTitleView: View {
    
    let title: String
    var empty: Bool { title.isEmpty }
    
    var body: some View {
        Text(empty ? "Name" : title)
            .font(.system(size: 20))
            .lineLimit(2)
            .fixedSize(horizontal: false, vertical: true)
            .padding([.horizontal], 15)
            .opacity(empty ? 0.2 : 1)
    }
}

struct EditorNotes: View {
    
    var notes: String
    var empty: Bool { notes.isEmpty }
    
    var body: some View {
         Text(empty ? "Notes..." : notes)
            .font(.system(size: 12))
            .opacity(empty ? 0.2 : 0.5)
            .lineLimit(nil)
            .fixedSize(horizontal: false, vertical: false)
            .padding([.horizontal], 10)
    }
}


extension View {
    func editorTitle() -> some View {
        self.modifier(EditorTitleModifier())
    }
}
