//
//  EmptyConcentrationView.swift
//  ClassPlanner
//
//  Created by Edvin Berhan on 2021-05-02.
//

import SwiftUI

struct EmptyConcentrationView: View {
    
//    @EnvironmentObject var shared: SharedVM
    @ObservedObject var concentrationVM: ConcentrationVM
    
    @Environment(\.managedObjectContext) var context
    @State private var isTargeted: Bool = false
    @State private var isDropping: Bool = false
    
    var body: some View {
        RoundedRectangle(cornerRadius: frameCornerRadius).stroke()
            .frame(minHeight: concentrationHeight)
            .contentShape(RoundedRectangle(cornerRadius: frameCornerRadius))
            .opacity((isTargeted || isDropping) ? emptyHoverOpacity : 0)
            .onHover { isTargeted = $0 }
            .onTapGesture { concentrationVM.addConcentration(context: context) }
            .onDrop(of: ["public.utf8-plain-text"], isTargeted: $isDropping) { drop(providers: $0) }
    }
    
    func drop(providers: [NSItemProvider]) -> Bool {
        let found = providers.loadFirstObject(ofType: String.self) { id in
            if let droppedConcentration = getDroppedConcentration(id: id) {
                withAnimation {
                    concentrationVM.moveInsertConcentration(droppedConcentration, at: concentrationVM.currentConcentrations.count)
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
