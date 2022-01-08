//
//  PanelConcentrations.swift
//  ClassPlanner
//
//  Created by Edvin Berhan on 2021-06-03.
//

import SwiftUI

struct ConcentrationStoreView: View {
    
    // Needed to set edit selection
    @EnvironmentObject var shared: SharedVM
    @ObservedObject private var concentrationVM: ConcentrationVM
    @FetchRequest private var concentrations: FetchedResults<Concentration>
    
    @Environment(\.managedObjectContext) var context
    
//    @State private var isDropping: Bool = false
    @State private var query: String = ""
    @Binding private var isShowingOnboarding: Bool
    
    init(concentrationVM: ConcentrationVM, isShowingOnboarding: Binding<Bool>) {
        self.concentrationVM = concentrationVM
        self._isShowingOnboarding = isShowingOnboarding
        let request = Concentration.fetchRequest(.all)
        _concentrations = FetchRequest(fetchRequest: request)
        
    }
    
    var matchingConcentrations: [Concentration] {
        concentrations.filter { query.isEmpty || $0.name.localizedCaseInsensitiveContains(query) }
    }
    
    var body: some View {
        PanelHeaderView(addAction: addConcentration, includeAddButton: false, searchQuery: $query) {
            ScrollView(showsIndicators: isCatalina) {
                ForEach (matchingConcentrations) { concentration in
                    ConcentrationView(
                        categoryViews: categories,
                        concentration: concentration, concentrationVM: concentrationVM,
                        isShowingConcentrationOnboarding: Binding.constant(true)
                    )
                    .padding(editorPadding)
//                        .onDrop(of: ["public.utf8-plain-text"], isTargeted: $isDropping) { drop(providers: $0) }
                }
            }
        }
        .popover(isPresented: $isShowingOnboarding, content: {
            ConcentrationStoreOnboarding()
        })
    }
    
    private func categories(concentration: Concentration) -> some View {
        let categories = concentration.categories.sorted(by: { $0.index < $1.index })
        return
            VStack {
                ForEach(categories) { category in
                    categoryTitle(category: category)
                        .padding(.horizontal, 5)
                }
                Spacer()
            }
    }
    
    func categoryTitle(category: Category) -> some View {
        let containedInCurrent = category.numberOfContainedCourses(schedule: shared.currentSchedule)
        return
            HStack(spacing: 0) {
                Text(category.name == "" ? "Category" : category.name)
                    .opacity(category.name == "" ? grayTextOpacity : 1)
                    .foregroundColor(category.getColor())
                Spacer()
                Text("\(containedInCurrent)")
                    .opacity(moreContainedThanRequired(in: category, contained: containedInCurrent) ? 1 : grayTextOpacity)
                    .foregroundColor(moreContainedThanRequired(in: category, contained: containedInCurrent) ? .green : .primary)
                Text("/\(category.numberOfRequired)")
                    .opacity(category.numberOfRequired == 0 ? grayTextOpacity : 1)
                
            }
            .lineLimit(2)
            .font(.system(size: categoryCourseFontSize + 1))
            .contentShape(Rectangle())
            .onTapGesture { shared.setEditSelection(to: .category(category: category)) }
        
    }
    
    private func moreContainedThanRequired(in category: Category, contained: Int) -> Bool {
        if category.numberOfRequired == 0 { return false }
        return category.numberOfContainedCourses(schedule: shared.currentSchedule) >= category.numberOfRequired
    }
    
    private func addConcentration() {
        withAnimation {
            concentrationVM.addConcentration(context: context)
        }
    }
    
//    func drop(providers: [NSItemProvider]) -> Bool {
//        let found = providers.loadFirstObject(ofType: String.self) { id in
//            if let droppedConcentration = getDroppedConcentration(id: id) {
//                withAnimation {
//                    concentrationVM.removeFromCurrentConcentrations(droppedConcentration)
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
}

//struct PanelConcentrations_Previews: PreviewProvider {
//    @Environment(\.managedObjectContext) var context
//    let conc = Concentration(context: context)
//
//    static var previews: some View {
//        PanelConcentrations()
//    }
//}
