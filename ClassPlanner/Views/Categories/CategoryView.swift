//
//  CategoryView.swift
//  ClassPlanner
//
//  Created by Edvin Berhan on 2021-05-02.
//

import SwiftUI

struct CategoryView: View {
    
    @ObservedObject var category: Category
    
    @EnvironmentObject var viewModel: ScheduleVM
    @Environment(\.managedObjectContext) var context
    @Environment(\.colorScheme) var colorScheme
    
    @State private var dragOffset: CGSize = .zero
    @State private var isDropping: Bool = false
    
    private var color: Color { viewModel.getColor(category.color, dark: colorScheme == .dark) }

    private var courses: [Course] { category.courses.sorted { $0.name < $1.name } }
    
    var body: some View {
        Group {
            if courses.count > 5 {
                ScrollView {
                    VStack(alignment: .leading, spacing: 0) {
                        title.gesture(dragGesture).padding([.trailing], 4)
                        Divider().padding([.trailing], 4)
                        ForEach (courses) { course in
                            courseView(course: course)
                                .onDrag { NSItemProvider(object: course.name as NSString) }
                        }
                        Spacer(minLength: 4)
                    }
                }
            }
            else {
                VStack(alignment: .leading, spacing: 0) {
                    title.gesture(dragGesture)
                    Divider()
                    ForEach (courses) { course in
                        courseView(course: course)
                            .onDrag { NSItemProvider(object: course.name as NSString) }
                    }
                    Spacer()
                }
            }
        }
        .scaleEffect(isDropping ? hoverScaleFactor : 1)
        .frame(width: courseWidth, height: courseHeight, alignment: .leading)
        .onHover { isDropping = viewModel.hoverOverCategory(category, entered: $0) }
        .offset(dragOffset)
        .contentShape(RoundedRectangle(cornerRadius: frameCornerRadius))
        .frame(width: categoryWidth, height: categoryHeight, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
        .onDrop(of: ["public.utf8-plain-text"], isTargeted: $isDropping) { drop(providers: $0) }
        
    }
    
    
    func courseView(course: Course) -> some View {
        ZStack {
            Text(course.name)
                .font(.system(size: 12))
                .foregroundColor(viewModel.getColor(course.color, dark: colorScheme == .dark))
        }
    }
    
    func drop(providers: [NSItemProvider]) -> Bool {
        print("Found")
        print(providers)
        let found = providers.loadFirstObject(ofType: String.self) { string in
            let newCourse = Course.withName(string as String, context: context)
            withAnimation {
                category.addCourse(newCourse)
            }
        }
        return found
    }
    
    
    var title: some View {
        let emptyName = category.name == ""
        let noRequired = category.numberOfRequired == 0
        return
            HStack {
                Text(emptyName ? "Name" : category.name)
                    .opacity(emptyName ? emptyHoverOpacity : 1)
                    .foregroundColor(color)
                Spacer()
                Text("\(category.numberOfRequired)")
                    .opacity(noRequired ? emptyHoverOpacity : 1)
                    
            }
            .lineLimit(2)
            .font(.system(size: 13))
            .contentShape(Rectangle())
            .onTapGesture { viewModel.setEditCategory(category) }
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
