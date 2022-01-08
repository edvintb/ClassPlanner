//
//  ViewModifiers.swift
//  ClassPlanner
//
//  Created by Edvin Berhan on 2021-05-17.
//

import SwiftUI

struct EditorTypeView<V>: View where V: View{
    let editorName: String
    let infoTappedAction: () -> ()
    let isCategory: Bool = false
    let createBackButton: () -> V
    
    var body: some View {
        ZStack {
            createBackButton()
            Text(editorName)
                .font(.system(size: 15))
                .opacity(grayTextOpacity)
                .frame(maxWidth: .infinity, alignment: .center)
            if #available(macOS 11.0, *) {
                Image(systemName: "info.circle")
                    .frame(maxWidth: .infinity, alignment: .trailing)
                    .onTapGesture {
                        infoTappedAction()
                    }
            } else {
                Button("Info", action: infoTappedAction)
                    .frame(maxWidth: .infinity, alignment: .trailing)
            }
        }
        .padding(.horizontal, 10)
    }
    
}

struct EditorTitleView: View {
    
    let title: String
    
    var body: some View {
        Text(title.isEmpty ? "" : title)
            .font(.system(size: 20))
            .lineLimit(2)
            .fixedSize(horizontal: false, vertical: true)
            .padding([.horizontal], 15)
            .opacity(title.isEmpty ? emptyOpacity : 1)
    }
}

struct EditorNotes: View {
    
    let notes: String
    let isCourse: Bool
    
    var body: some View {
        ScrollView(showsIndicators: isCatalina) {
            Text(notes)
                .font(.system(size: 13))
                .opacity(0.5)
                .transition(.opacity)
                .fixedSize(horizontal: false, vertical: false)
                .lineSpacing(2)
                .padding(.horizontal, 10)
                
        }.frame(height: CGFloat(min((notes.count / 3 + 30), isCourse ? 100 : 135)))
    }
}

struct EditorHeader: View {
    
    init(title: String, notes: String, color: Color, isCourse: Bool = false) {
        self.title = title
        self.notes = notes
        self.color = color
        self.isCourse = isCourse
    }
    
    let title: String
    let notes: String
    let color: Color
    let isCourse: Bool
    
    
    var body: some View {
        EditorTitleView(title: title).foregroundColor(color)
        Divider().padding(5)
        EditorNotes(notes: notes, isCourse: isCourse)
        Spacer().frame(height: 12)
    }
}


struct NoteEditor: View {
    
    @Binding var text: String
    
    let onCommit: () -> ()
    
    var body: some View {
        HStack {
            Text(" \(noteSymbol)").font(.system(size: editorIconFontSize))
            TextField("Notes...", text: $text, onCommit: onCommit)
                .cornerRadius(textFieldCornerRadius)
                .focusable()
        }
    }
}


struct NameEditor<V>: View where V: View {
    
    let entryView: V
    
    var body: some View {
        HStack {
            Text(" \(nameSymbol)").font(.system(size: editorIconFontSize))
            entryView
        }
    }
}

struct EditorColorGrid: View {
    
    let tapAction: (ColorOption) -> ()
    
    static let colorOrder: [ColorOption] = [.white, .lightBlue, .darkBlue, .purple, .lightPink, .darkPink, .red, .yellow, .orange, .brown, .oliveGreen, .jungleGreen]
    
    var body: some View {
        HStack(spacing: 2) {
            ForEach(EditorColorGrid.colorOrder) { option in
                gridView(colorOption: option)
            }
        }
        .frame(height: editorColorGridHeight)
        .padding(.vertical, 4)
    }
    
    private func gridView(colorOption: ColorOption) -> some View {
        RoundedRectangle(cornerRadius: frameCornerRadius)
            .foregroundColor(colorOption.color)
            .onTapGesture { tapAction(colorOption) }
            .padding(3)
    }
    
}

//struct EditorColorPicker: View {
//
//    @Binding var selection: Int
//
//    var body: some View {
//        if #available(macOS 11.0, *) {
//            Picker("", selection: $selection) {
//                ForEach(Color.colorSelection, id: \.self) { currentColor in
//                    // RoundedRectangle(cornerRadius: frameCornerRadius)
//                    Text("Text")
//                        .frame(maxWidth: .infinity)
//                        .overlay(Rectangle())
//                        .foregroundColor(currentColor)
//                        .background(currentColor)
//                        .tag(Color.colorSelection.firstIndex(of: currentColor) ?? 0)
//                }
//            }
//            .pickerStyle(.menu)
//            Text("Selected color \(selection)")
//        } else {
//            Picker("Select a paint color", selection: $selection) {
//                ForEach(Color.colorSelection, id: \.self) { currentColor in
//                    RoundedRectangle(cornerRadius: frameCornerRadius)
//                        .foregroundColor(currentColor)
//                }
//            }
//        }
//    }
//}

struct CourseRowView: View {
    
    let containCondition: Bool
    @ObservedObject var course: Course
    
    var body: some View {
        HStack {
            Text(course.name == "" ? "No name" : course.name)
                .foregroundColor(course.getColor())
            Spacer()
            if containCondition {
                Text(courseContainedSymbol)
                    .foregroundColor(checkMarkColor)
            }
        }
    }
}

struct EditorButtons: View {
    
    @State private var isDeleting: Bool = false
    
    let deleteAction: () -> ()
    let closeAction: () -> ()
    
    var body: some View {
        HStack {
            Button(action: { isDeleting.toggle() },
                   label: { Text("Delete").foregroundColor(.red) })
            Spacer()
            Button("Close") {
                withAnimation {
                    closeAction()
                }
            }
        }
        .alert(isPresented: $isDeleting, content: {
            Alert(title: Text("Are you sure?"),
                  message: Text(
                    "Deleting removes the object completely."),
                  primaryButton:
                    .cancel({ self.isDeleting = false }),
                  secondaryButton:
                    .destructive(Text("OK"), action: withAnimation { deleteAction })
                )
            }
        )
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
