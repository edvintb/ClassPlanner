//
//  ConcentrationView.swift
//  ClassPlanner
//
//  Created by Edvin Berhan on 2021-04-23.
//

import SwiftUI

struct ConcentrationView: View {
    
    @EnvironmentObject var viewModel: CourseVM
    @Environment(\.managedObjectContext) var context
    @ObservedObject var concentration: Concentration
    @FetchRequest private var categories: FetchedResults<Category>
    
    @State private var dragOffset: CGSize = .zero
    @State private var isEditingName: Bool = false
    @State private var isTargeted: Bool = false
    
    private var empty: Bool {
        concentration.name == ""
    }
    private var isDragging: Bool {
        dragOffset != .zero
    }
    
    init(_ concentration: Concentration) {
        self.concentration = concentration
        let request = Category.fetchRequest(NSPredicate(format: "concentration == %@", argumentArray: [concentration]))
        _categories = FetchRequest(fetchRequest: request)
    }
    
    var body: some View {
        // Why can't I use the textfield in place????
//        TextField("Name", text: $concentration.name, onCommit: { try? context.save() })
        ZStack {
            RoundedRectangle(cornerRadius: frameCornerRadius)
                .stroke()
                .opacity(0.2)
            VStack(alignment: .leading, spacing: 1) {
                HStack {
                    titleText
    //                Text("Categories: \(categories.count)")
    //                Text("Index: \(concentration.index)")
                    Spacer()
                    Text("Delete").onTapGesture { withAnimation(Animation.easeInOut(duration: 0.5)) {
                        viewModel.deleteConcentration(concentration)
                        }
                    }
                }.gesture(dragGesture)
                Divider()
                HStack {
                    ForEach (categories) { category in
                        CategoryView(category: category)
                    }
                    EmptyCategoryView(concentration: concentration)
                }
                .environmentObject(viewModel)
            }.padding(7)

        }
        .scaleEffect(isTargeted ? 1.01 : 1)
        .onHover { isTargeted = viewModel.hoverOverConcentration(concentration, entered: $0) }
        .offset(dragOffset)
        

    }
    
    var dragGesture: some Gesture {
        DragGesture(coordinateSpace: .global)
            .onChanged {
                dragOffset = CGSize(width: $0.translation.width, height: -$0.translation.height)
                if viewModel.dragConcentration == nil { viewModel.setDragConcentration(to: concentration) }
            }
            .onEnded { _ in
                viewModel.concentrationDragEnded()
                dragOffset = .zero
            }
    }
    
    var nameEditor: some View {
        VStack {
            TextField("Name", text: $concentration.name, onCommit: {
                        isEditingName = false
                        try? context.save()
            })
            
        }
    }
    
    var titleText: some View {
        Text(empty ? "Name" : concentration.name)
            .font(.system(size: 20))
            .opacity(empty ? 0.4 : 1)
            .onTapGesture { isEditingName.toggle() }
            .popover(isPresented: $isEditingName, content: { nameEditor.padding(5) })
    }
    
    func delete(category: Category) -> some View {
        context.delete(category)
        return Text("I was a category")
    }
    
    
}

//struct ConcentrationView_Previews: PreviewProvider {
//
//    static var previews: some View {
//        ConcentrationView()
//    }
//}

