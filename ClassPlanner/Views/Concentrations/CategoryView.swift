//
//  CategoryView.swift
//  ClassPlanner
//
//  Created by Edvin Berhan on 2021-05-02.
//

import SwiftUI

struct CategoryView: View {
    
    @ObservedObject var category: Category
    
    @EnvironmentObject var viewModel: CourseVM
    @Environment(\.managedObjectContext) var context
//    @FetchRequest private var categoryCourses: FetchedResults<Course>
    
    @State private var isEditingName: Bool = false
    @State private var dragOffset: CGSize = .zero
    @State private var isTargeted: Bool = false
    
    private var empty: Bool {
        category.name == ""
    }
    var courses: [Course] {
        category.courses.sorted { $0.semester < $1.semester }
    }
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            RoundedRectangle(cornerRadius: frameCornerRadius)
                .stroke()
                .opacity(0.2)
            VStack(alignment: .leading) {
                categoryName
                ForEach (courses) { course in
                    Text("- \(course.name)")
                }
                Text("\(category.index)")
                Text(category.concentration?.name ?? "-")
            }.padding(4)
        }
        .scaleEffect(isTargeted ? 1.03 : 1)
        .onHover { isTargeted = viewModel.hoverOverCategory(category, entered: $0) }
        .offset(dragOffset)
        .contentShape(RoundedRectangle(cornerRadius: frameCornerRadius))
        .frame(width: categoryWidth, height: categoryHeight, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
        .gesture(dragGesture)
        .gesture(deleteGesture)
        
    }
    
    var dragGesture: some Gesture {
        DragGesture(coordinateSpace: .global)
            .onChanged {
                dragOffset = CGSize(width: $0.translation.width, height: -$0.translation.height)
                if viewModel.dragCategory == nil { viewModel.setDragCategory(to: category) }
            }
            .onEnded { _ in
                print("Ended")
                viewModel.categoryDragEnded()
                dragOffset = .zero
            }
    }
    
    
    var deleteGesture: some Gesture {
        TapGesture(count: 2).onEnded { withAnimation {
            viewModel.deleteCategory(category: category)
            }
        }
    }
    
    var categoryName: some View {
        Text(empty ? "Name" : category.name)
            .opacity(empty ? 0.4 : 1)
            .onTapGesture { isEditingName.toggle() }
            .popover(isPresented: $isEditingName, content: { nameEditor.padding(5) })
    }
    
    var nameEditor: some View {
        VStack {
            TextField("Name", text: $category.name, onCommit: {
                        isEditingName = false
                        try? context.save()
            })
        }
    }
}
