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
    @Environment(\.colorScheme) var colorScheme
//    @FetchRequest private var categoryCourses: FetchedResults<Course>
    
    @State private var isEditing: Bool = false
    @State private var dragOffset: CGSize = .zero
    @State private var isTargeted: Bool = false
    
    private var color: Color { viewModel.getColor(category.color, dark: colorScheme == .dark) }

    private var courses: [Course] { category.courses.sorted { $0.name < $1.name } }
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            RoundedRectangle(cornerRadius: frameCornerRadius)
                .stroke()
                .opacity(0.001)
            VStack(alignment: .leading, spacing: 0) {
                title
                Divider()
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 0) {
                        ForEach (courses) { course in
                            Text("- ") + Text("\(course.name)")
                                .foregroundColor(viewModel.getColor(course.color, dark: colorScheme == .dark))
                                .font(.system(size: 11))
                        }
                    }
                }

                
//                Text("\(category.index)")
//                Text(category.concentration?.name ?? "-")
            }
        }
        .scaleEffect(isTargeted ? 1.03 : 1)
        .onHover { isTargeted = viewModel.hoverOverCategory(category, entered: $0) }
        .offset(dragOffset)
        .contentShape(RoundedRectangle(cornerRadius: frameCornerRadius))
        .frame(width: categoryWidth, height: categoryHeight, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
        .gesture(dragGesture)
        
    }
    
    var title: some View {
        let emptyName = category.name == ""
        let noRequired = category.numberOfRequired == 0
        return
            HStack {
                Text(emptyName ? "Name" : category.name)
                    .opacity(emptyName ? 0.4 : 1)
                    .foregroundColor(color)
                Spacer()
                Text("\(category.numberOfRequired)")
                    .opacity(noRequired ? 0.4 : 1)
            }
            .font(.system(size: 13))
            .contentShape(Rectangle())
            .onTapGesture { viewModel.setEditCategory(category) }
//            .popover(isPresented: $isEditing) {
//                    CategoryEditorView(isPresented: $isEditing).padding(5)
//                        .environmentObject(viewModel)
//                        .environmentObject(category)
//            }
    }
    
    var dragGesture: some Gesture {
        DragGesture(coordinateSpace: .global)
            .onChanged {
                dragOffset = CGSize(width: $0.translation.width, height: -$0.translation.height)
                if viewModel.dragCategory == nil { viewModel.setDragCategory(to: category) }
            }
            .onEnded { _ in
//                print("Ended")
                viewModel.categoryDragEnded()
                dragOffset = .zero
            }
    }
    

}
