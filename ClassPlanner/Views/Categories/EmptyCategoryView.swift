//
//  EmptyCategoryView.swift
//  ClassPlanner
//
//  Created by Edvin Berhan on 2021-05-02.
//

import SwiftUI

struct EmptyCategoryView: View {
    
    @ObservedObject var concentration: Concentration
    
    @State private var isTargeted: Bool = false
    @State private var isDropping: Bool = false
    
    @Environment(\.managedObjectContext) var context
    
    var body: some View {
        ZStack(alignment: .leading) {
            RoundedRectangle(cornerRadius: frameCornerRadius).stroke()
                .contentShape(RoundedRectangle(cornerRadius: frameCornerRadius))
                .opacity((isTargeted || isDropping) ? emptyHoverOpacity : 0)
                .onHover { isTargeted = $0 }
                .onTapGesture { concentration.addCategory() }
                .frame(width: categoryWidth)
                .onDrop(of: ["public.utf8-plain-text"], isTargeted: $isDropping) { drop(providers: $0) }
            RoundedRectangle(cornerRadius: frameCornerRadius).opacity(0.001)
                .frame(maxHeight: categoryHeight, alignment: .center)
        }

    }
    
    func drop(providers: [NSItemProvider]) -> Bool {
        let found = providers.loadFirstObject(ofType: String.self) { location in
            if let uri = URL(string: location) {
                    if let droppedObject = NSManagedObject.fromURI(uri: uri, context: context) {
                        if let category = droppedObject as? Category {
                            category.move(to: getCount(), concentration: concentration)
                    }
                }
            }
        }
        return found
    }
    
    private func getCount() -> Int {
        let predicate = NSPredicate(format: "concentration == %@", concentration)
        let request = Category.fetchRequest(predicate)
        let count = (try? context.count(for: request)) ?? 0
        return count
    }
    
}
//    var addGesture: some Gesture {
//        TapGesture().onEnded {
//            print("Tapped")
//        }
//    }

//
//struct EmptyCategoryView_Previews: PreviewProvider {
//    static var previews: some View {
//        EmptyCategoryView()
//    }
//}

//
