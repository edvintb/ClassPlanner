//
//  ConcentrationView.swift
//  ClassPlanner
//
//  Created by Edvin Berhan on 2021-04-23.
//

import SwiftUI

//struct ConcentrationWithCategories: View {
//    
//    
//    @EnvironmentObject var shared: SharedVM
//    @ObservedObject var concentration: Concentration
//    @Environment(\.managedObjectContext) var context
//    
//    private var categories: [Category] {
//        concentration.categories.sorted(by: {$0.index < $1.index })
//    }
//    
//    @State private var isDropping: Bool = false
//
//    // Needs to tell categories to change with schedule
//    @ObservedObject var schedule: ScheduleVM
//
//    var body: some View {
//        ConcentrationView(concentration: concentration, schedule: schedule)
//            .onDrop(of: ["public.utf8-plain-text"], isTargeted: $isDropping) { drop(providers: $0) }
//    }
    
//    func testCategories() -> some View {
//        HStack {
//            ForEach (categories) { category in
//                    CategoryView(category: category, schedule: schedule)
//            }
//            EmptyCategoryView(concentration: concentration)
//        }
//        .padding([.horizontal], 7)
//    }
    
    
//    func categoryViews(size: CGSize) -> some View {
//        let categories = self.categories
//        return
//            HStack {
//                ForEach (categories) { category in
////                    ConditionalScrollView(wanted: CGFloat(category.courses.count + 1) * categoryCourseFontSize*1.5, given: size.height) {
//                        CategoryView(category: category, schedule: schedule)
////                    }
//                }
//                EmptyCategoryView(concentration: concentration)
//            }
//            .padding([.horizontal], 7)
////            .frame(height: size.height, alignment: .topLeading)
//    }
//    
//    func drop(providers: [NSItemProvider]) -> Bool {
//        let found = providers.loadFirstObject(ofType: String.self) { id in
//            if let droppedConcentration = getDroppedConcentration(id: id) {
//                withAnimation {
//                    shared.insertConcentration(droppedConcentration)
//                    // Fix moving to correct place 
//                }
//            }
//        }
//        return found
//    }
//    
//    private func getDroppedConcentration(id: String) -> Concentration? {
//        if let uri = URL(string: id) {
//            let object = NSManagedObject.fromURI(uri: uri, context: context)
//            return object as? Concentration
//        }
//        return nil
//    }
//}






struct ConcentrationView<V>: View  where V: View{
    
    let categoryViews: (Concentration) -> V
    
    @EnvironmentObject var shared: SharedVM
    @ObservedObject var concentration: Concentration
    
    private var categories: [Category] {
        concentration.categories.sorted(by: {$0.index < $1.index })
    }
    
//    @State private var dragOffset: CGSize = .zero
    @State private var isTargeted: Bool = false
    
    private var empty: Bool {
        concentration.name == ""
    }
    
    
    var body: some View {
        ZStack {
            container
            VStack(alignment: .leading, spacing: 1) {
                title
                Divider()
                categoryViews(concentration)
//                Spacer()
            }
        }
        .scaleEffect(isTargeted ? 1.01 : 1)
        .onDrag({ NSItemProvider(object: concentration.stringID as NSString) })
    }
    
    var container: some View {
        RoundedRectangle(cornerRadius: frameCornerRadius)
            .stroke()
            .opacity(emptyHoverOpacity)
            .frame(minHeight: concentrationHeight)
    }
    
    var title: some View {
        HStack {
            titleText
            Spacer()
            Text("\(concentration.index)")
        }
        .padding(7)
        .contentShape(Rectangle())
        .foregroundColor(concentration.getColor())
        .onTapGesture {
            shared.setEditSelection(to: .concentration(concentration: concentration))
        }
    }
    

    
    var titleText: some View {
        Text(empty ? "Name" : concentration.name)
            .font(.system(size: 20))
            .opacity(empty ? 0.4 : 1)
            .onTapGesture { shared.setEditSelection(to: .concentration(concentration: concentration)) } // Open Concentration Editor
    }

//
//    var dragGesture: some Gesture {
//        DragGesture(coordinateSpace: .global)
//            .onChanged {
//                dragOffset = CGSize(width: $0.translation.width, height: -$0.translation.height)
//                if concentrationVM.dragConcentration == nil { concentrationVM.setDragConcentration(to: concentration) }
//            }
//            .onEnded { _ in
//                concentrationVM.concentrationDragEnded()
//                dragOffset = .zero
//            }
//    }
    
    var deleteGesture: some Gesture {
        TapGesture()
            .onEnded { concentration.delete() }
    }
    
    
//
    
    
}

//
//func delete(category: Category) -> some View {
//        context.delete(category)
//        return Text("I was a category")
//    }

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

