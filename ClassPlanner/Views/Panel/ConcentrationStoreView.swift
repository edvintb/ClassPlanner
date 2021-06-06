//
//  PanelConcentrations.swift
//  ClassPlanner
//
//  Created by Edvin Berhan on 2021-06-03.
//

import SwiftUI

struct ConcentrationStoreView: View {
    
    @EnvironmentObject var shared: SharedVM
    @FetchRequest private var concentrations: FetchedResults<Concentration>
    
    @Environment(\.managedObjectContext) var context
    
    @State private var isDropping: Bool = false
    
    init() {
        let request = Concentration.fetchRequest(.all)
        _concentrations = FetchRequest(fetchRequest: request)
    }
    
    var body: some View {
//        VStack(alignment: .leading) {
//            buttons
//            ForEach (concentrations) { concentration in
//                concentrationView(concentration)
//            }
//        }
//        .onDrop(of: ["public.utf8-plain-text"], isTargeted: $isDropping) { drop(providers: $0) }
        EmptyView()
        Spacer()
    }
    
    private func concentrationView(_ concentration: Concentration) -> some View {
//        ConcentrationView(categoryViews: categories, concentration: concentration)
//            .onDrag({ NSItemProvider(object: concentration.stringID as NSString) })
//            .padding(editorPadding)
        EmptyView()
    }
    
    private func categories() -> some View {
        EmptyView()
    }
    
    var buttons: some View {
        HStack {
            Button(action: { Concentration.createEmpty(in: context) }, label: {
                Text("􀅼")
            })
            Spacer()
        }
        .padding(.horizontal, 5)
        .padding(.bottom, 2)

    }
    
    func drop(providers: [NSItemProvider]) -> Bool {
        let found = providers.loadFirstObject(ofType: String.self) { id in
            if let droppedConcentration = getDroppedConcentration(id: id) {
                withAnimation {
                    shared.removeConcentration(droppedConcentration)
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
