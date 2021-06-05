//
//  ViewModifiers.swift
//  ClassPlanner
//
//  Created by Edvin Berhan on 2021-05-17.
//

import SwiftUI

struct EditorTitleView: View {
    
    let title: String
    
    var body: some View {
        Text(title.isEmpty ? "Name" : title)
            .font(.system(size: 20))
            .lineLimit(2)
            .fixedSize(horizontal: false, vertical: true)
            .padding([.horizontal], 15)
            .opacity(title.isEmpty ? emptyOpacity : 1)
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

struct EditorColorGrid: View {
    
    // Make them all colorpickers for Big Sur
    
    let tapAction: (Int) -> ()
    
    var body: some View {
        Grid(Array(1..<Color.colorSelection.count), id: \.self) { index in
            RoundedRectangle(cornerRadius: frameCornerRadius)
                .foregroundColor(Color.colorSelection[index])
                .onTapGesture { tapAction(index) }
                .padding(3)
        }
        .frame(minHeight: 2*courseHeight)
    }
}

struct NoteEditor: View {
    
    @Binding var text: String
    
    let onCommit: () -> ()
    
    var body: some View {
        HStack {
            Text(" \(noteSymbol)")
            ZStack {
                if #available(OSX 11.0, *) {
                    TextEditor(text: $text)
                        .cornerRadius(textFieldCornerRadius)
                        .focusable()
                } else {
                    TextField("Notes...", text: $text, onCommit: onCommit)
                        .cornerRadius(textFieldCornerRadius)
                        .focusable()
                }
            }
        }
    }
}


struct NameEditor<V>: View where V: View {
    
    let entryView: V
    
    var body: some View {
        HStack {
            Text(" \(nameSymbol)").font(.system(size: 16, weight: .thin, design: .serif))
            entryView
        }
    }
}

struct EditorHeader: View {
    
    let title: String
    let notes: String
    let color: Color
    
    
    var body: some View {
        Spacer(minLength: 7)
        EditorTitleView(title: title).foregroundColor(color)
        Divider().padding(5)
        EditorNotes(notes: notes)
        Spacer(minLength: 12)
    }
}




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


//extension View {
//    func editorTitle() -> some View {
//        self.modifier(EditorTitleModifier())
//    }
//}
