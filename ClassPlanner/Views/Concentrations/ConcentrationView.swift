//
//  ConcentrationView.swift
//  ClassPlanner
//
//  Created by Edvin Berhan on 2021-04-23.
//

import SwiftUI

struct ConcentrationView: View {
    
    @ObservedObject var concentration: Concentration
    
    // Needed for dragging
    // Good to keep drag-method separate bc strings
    @ObservedObject var concentrationVM: ConcentrationVM
    @Environment(\.managedObjectContext) var context
    
    private var categories: [Category] {
        concentration.categories.sorted(by: {$0.index < $1.index })
    }
    
    @State private var dragOffset: CGSize = .zero
    @State private var isEditingName: Bool = false
    @State private var isTargeted: Bool = false
    
    private var empty: Bool {
        concentration.name == ""
    }
    private var isDragging: Bool {
        dragOffset != .zero
    }
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: frameCornerRadius)
                .stroke()
                .opacity(emptyHoverOpacity)
            VStack(alignment: .leading, spacing: 1) {
                title
                Divider()
                GeometryReader { geo in
                    categories(in: geo.size)
                }
            }
        }
        .frame(minHeight: concentrationHeight)
        .scaleEffect(isTargeted ? 1.01 : 1)
        .onHover { isTargeted = concentrationVM.hoverOverConcentration(concentration, entered: $0) }
        .offset(dragOffset)
        .zIndex( concentrationVM.dragConcentration == concentration ? 1 : 0)
        

    }
    
    var title: some View {
        HStack {
            titleText
            Spacer()
            Text("Delete")
                .gesture(deleteGesture)
        }
        .padding(7)
        .contentShape(Rectangle())
        .gesture(dragGesture)
    }
    
    
    func categories(in size: CGSize) -> some View {
        HStack {
            ForEach (categories) { category in
                optionalScrollView(wanted: CGFloat(category.courses.count + 1) * categoryCourseFontSize*1.5, given: size.height) {
                    CategoryView(category: category, concentrationVM: concentrationVM)
                }
            }
            EmptyCategoryView(concentration: concentration)
        }
        .padding([.horizontal], 7)
        .frame(height: size.height, alignment: .topLeading)
        .environmentObject(concentrationVM)
    }
    
    @ViewBuilder
    func optionalScrollView<V>(wanted: CGFloat, given: CGFloat, content: () -> V) -> some View where V: View {
        if wanted > given {
            ScrollView(content: content)
        }
        else {
            Group(content: content)
        }
    }
    
    var titleText: some View {
        Text(empty ? "Name" : concentration.name)
            .font(.system(size: 20))
            .opacity(empty ? 0.4 : 1)
            .onTapGesture { isEditingName.toggle() }
//            .popover(isPresented: $isEditingName, content: { nameEditor.padding(5) })
    }

    
    var dragGesture: some Gesture {
        DragGesture(coordinateSpace: .global)
            .onChanged {
                dragOffset = CGSize(width: $0.translation.width, height: -$0.translation.height)
                if concentrationVM.dragConcentration == nil { concentrationVM.setDragConcentration(to: concentration) }
            }
            .onEnded { _ in
                concentrationVM.concentrationDragEnded()
                dragOffset = .zero
            }
    }
    
    var deleteGesture: some Gesture {
        TapGesture()
            .onEnded { concentration.delete() }
    }
    
    
    func delete(category: Category) -> some View {
        context.delete(category)
        return Text("I was a category")
    }
    
    
}


// Could also access categories from concentration, but actually
// more efficient this way. Sorting on DB-side
//    @FetchRequest private var categories: FetchedResults<Category>

//
//init(_ concentration: Concentration, vm: ConcentrationVM) {
////        self.concentration = concentration
//        self.concentrationVM = vm
////
//    }

//
//let request = Category.fetchRequest(NSPredicate(format: "concentration == %@", argumentArray: [concentration]))
//        _categories = FetchRequest(fetchRequest: request)

//var nameEditor: some View {
//        VStack {
//            TextField("Name", text: $concentration.name, onCommit: {
//                        isEditingName = false
//                        try? context.save()
//            })
//
//        }
//    }


//struct ConcentrationView_Previews: PreviewProvider {
//
//    static var previews: some View {
//        ConcentrationView()
//    }
//}

