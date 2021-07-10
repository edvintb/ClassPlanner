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
    // Needed to access currently showing concentrations
    @ObservedObject private var concentrationVM: ConcentrationVM
    
    @FetchRequest private var concentrations: FetchedResults<Concentration>
    
    @Environment(\.managedObjectContext) var context
    
    @State private var isDropping: Bool = false
    @State private var query: String = ""
    
    init(concentrationVM: ConcentrationVM) {
        self.concentrationVM = concentrationVM
        let request = Concentration.fetchRequest(.all)
        _concentrations = FetchRequest(fetchRequest: request)
    }
    
    var matchingConcentrations: [Concentration] {
        concentrations.filter { query.isEmpty || $0.name.localizedCaseInsensitiveContains(query) }
    }
    
    var body: some View {
        PanelHeaderView(addAction: addConcentration, searchQuery: $query) {
            List {
                ForEach (matchingConcentrations) { concentration in
                    concentrationView(concentration)
                        .onDrop(of: ["public.utf8-plain-text"], isTargeted: $isDropping) { drop(providers: $0) }
                }
            }
        }
        
    }
    
    private func concentrationView(_ concentration: Concentration) -> some View {
        ConcentrationView(categoryViews: categories, concentration: concentration, concentrationVM: concentrationVM)
            .onDrag({ NSItemProvider(object: concentration.stringID as NSString) })
            .padding(editorPadding)
    }
    
    private func categories(concentration: Concentration) -> some View {
        let categories = concentration.categories.sorted(by: { $0.index < $1.index })
        return
            VStack {
                ForEach(categories) { category in
                    HStack {
                        categoryTitle(category: category)
                            .padding(.horizontal, 5)
                    }
                }
                Spacer()
            }
    }
    
    func categoryTitle(category: Category) -> some View {
        let containedInCurrent = numberOfContainedCourses(in: category)
        return
            HStack(spacing: 0) {
                Text(category.name == "" ? "Name" : category.name)
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
        return numberOfContainedCourses(in: category) >= category.numberOfRequired
    }
    
    
    private func numberOfContainedCourses(in category: Category) -> Int {
        if let schedule = shared.currentSchedule {
            return
                category.courses.reduce(into: 0) { acc, course in
                    acc += Int(schedule.courseURLs.contains(course.urlID))
                }
        }
        else {
            return 0
        }
    }
    
    
    private func addConcentration() {
        concentrationVM.addConcentration(context: context)
    }
    
    
    func drop(providers: [NSItemProvider]) -> Bool {
        print("Dropped")
        let found = providers.loadFirstObject(ofType: String.self) { id in
            if let droppedConcentration = getDroppedConcentration(id: id) {
                print("Removing")
                withAnimation {
                    concentrationVM.removeConcentration(droppedConcentration)
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

//struct PanelConcentrations_Previews: PreviewProvider {
//    @Environment(\.managedObjectContext) var context
//    let conc = Concentration(context: context)
//
//    static var previews: some View {
//        PanelConcentrations()
//    }
//}
