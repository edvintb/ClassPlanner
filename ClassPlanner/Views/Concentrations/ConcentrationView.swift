//
//  ConcentrationView.swift
//  ClassPlanner
//
//  Created by Edvin Berhan on 2021-04-23.
//

import SwiftUI

struct ConcentrationView<V>: View  where V: View{
    
    let categoryViews: (Concentration) -> V
    
    @EnvironmentObject var shared: SharedVM
    @ObservedObject var concentration: Concentration
    @ObservedObject var concentrationVM: ConcentrationVM
    
    @Environment(\.managedObjectContext) var context
    
    @FetchRequest private var categories: FetchedResults<Category>
    
    @State private var isDropping: Bool = false
    
    private var isEditingConcentration: Bool {
        if case let .concentration(editingConcentration) = shared.currentEditSelection {
            return editingConcentration == self.concentration
        }
        return false
    }
    
//    @Binding var isShowingConcentrationOnboarding: Bool
    @State private var isShowingCategoryOnboarding: Bool = !UserDefaults.standard.bool(forKey: concentrationEditorOnboardingKey)
    private func setCategoryOnboarding(show: Bool) {
        withAnimation {
            self.isShowingCategoryOnboarding = show
            UserDefaults.standard.setValue(!show, forKey: concentrationEditorOnboardingKey)
        }
    }
    
    private var requiredCourses: Int {
        categories.reduce(into: 0) { acc, category in
            acc += category.numberOfRequired
        }
    }
    
    private var coursesContained: Int {
        categories.reduce(into: 0) { acc, category in
            acc += category.numberOfContainedCourses(schedule: shared.currentSchedule)
        }
    }
    
    // The fetch request makes for better updating?? Should we use this in other places too, like GPA?
    init(categoryViews: @escaping (Concentration) -> V, concentration: Concentration, concentrationVM: ConcentrationVM, isShowingConcentrationOnboarding: Binding<Bool>) {
        self.categoryViews = categoryViews
        self.concentration = concentration
        self.concentrationVM = concentrationVM
        let predicate = NSPredicate(format: "concentration == %@", argumentArray: [concentration])
        let request = Category.fetchRequest(predicate)
        _categories = FetchRequest(fetchRequest: request)
//        self._isShowingConcentrationOnboarding = isShowingConcentrationOnboarding
    }
    
    var body: some View {
        ZStack {
            container
            VStack(alignment: .leading, spacing: 1) {
                title
                Divider()
                categoryViews(concentration)
            }
        }
        .scaleEffect(isDropping ? 1.01 : 1)
        .onDrop(of: ["public.utf8-plain-text"], isTargeted: $isDropping) { drop(providers: $0, at: concentration) }
        .onDrag({ NSItemProvider(object: concentration.stringID as NSString) })
//        .overlay(overlayView())
        .onReceive(shared.$isShowingOnboarding.dropFirst()) { show in
            setCategoryOnboarding(show: show)
        }
        .popover(isPresented: $isShowingCategoryOnboarding, arrowEdge: .bottom) {
            if concentrationVM.currentConcentrations.count > 0 {
                if concentrationVM.currentConcentrations[0] == concentration.urlID {
                    CategoryOnboardingView(
                        isShowingOnboarding: $isShowingCategoryOnboarding,
                        setCategoryOnboarding: setCategoryOnboarding
                    )
                }
            }
        }
    }
    
//    @ViewBuilder
//    func overlayView() -> some View {
//        if !isShowingConcentrationOnboarding && isShowingOnboarding {
//            CategoryOnboardingView(isShowingOnboarding: $isShowingOnboarding, setCategoryOnboarding: setCategoryOnboarding).onAppear { print(isShowingConcentrationOnboarding) }
//        }
//    }
    
    var container: some View {
        RoundedRectangle(cornerRadius: frameCornerRadius)
            .stroke()
            .opacity(isEditingConcentration ? 1 : emptyHoverOpacity)
            .frame(minHeight: concentrationHeight)
            .shadow(color: .black, radius: isEditingConcentration ? 10 : 0)
            .shadow(color: .black, radius: isEditingConcentration ? 10 : 0)
    }
    
    var title: some View {
        HStack {
            titleText
            Spacer()
            Text("\(coursesContained)/\(requiredCourses)")
        }
        .padding(7)
        .contentShape(Rectangle())
        .foregroundColor(concentration.getColor())
        .onTapGesture {
            shared.setEditSelection(to: .concentration(concentration: concentration))
        }
    }
    
    var titleText: some View {
        Text(concentration.name.isEmpty ? "Major" : concentration.name)
            .font(.system(size: 20))
            .opacity(concentration.name.isEmpty ? 0.4 : 1)
            .onTapGesture { shared.setEditSelection(to: .concentration(concentration: concentration)) } // Open Concentration Editor
    }
    
    func drop(providers: [NSItemProvider], at newConcentration: Concentration) -> Bool {
        let found = providers.loadFirstObject(ofType: String.self) { id in
            if let newIndex = concentrationVM.currentConcentrations.firstIndex(of: newConcentration.urlID) {
                if let droppedConcentration = getDroppedConcentration(id: id) {
                    withAnimation {
                        concentrationVM.moveInsertCurrentConcentration(droppedConcentration, at: newIndex)
                    }
                }
            }
            
        }
        return found
    }
    
    private func getDroppedConcentration(id: String) -> Concentration? {
        if let uri = URL(string: id) {
            let object = NSManagedObject.fromURI(uri: uri, context: context)
            return object as? Concentration
        }
        return nil
    }
}

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

