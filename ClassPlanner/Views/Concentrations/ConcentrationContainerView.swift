//
//  ConcentrationContainerView.swift
//  ClassPlanner
//
//  Created by Edvin Berhan on 2021-05-03.
//

import SwiftUI

struct ConcentrationContainerView: View {
    
    @EnvironmentObject var shared: SharedVM
    
    @ObservedObject var schedule: ScheduleVM
    
    @Environment(\.managedObjectContext) var context
    
//    private var concentrations: [Concentration] {
//        shared.currentConcentrations.reduce(into: []) { acc, uri in
//            if let concentration = NSManagedObject.fromURI(uri: uri, context: context) as? Concentration {
//                acc.append(concentration)
//            }
//        }.sorted(by: { $0.index < $1.index })
//    }
    
    private var concentrations: [Concentration] {
        shared.currentConcentrations.compactMap { uri in
            NSManagedObject.fromURI(uri: uri, context: context) as? Concentration
        }
    }
    
    @State var isDropping: Bool = false
    
    var body: some View {
        ScrollView([.vertical, .horizontal]) {
                concentrationViews
                .padding(.horizontal, 5)
        }
    }
    
    var concentrationViews: some View {
        VStack (alignment: .leading, spacing: 4) {
            Spacer(minLength: 4)
            ForEach (concentrations) { concentration in
                ConcentrationView(categoryViews: categoryViews, concentration: concentration)
                    .onDrop(of: ["public.utf8-plain-text"], isTargeted: $isDropping) { drop(providers: $0, at: concentration) }
            }
            EmptyConcentrationView()
        }
        .padding(.horizontal, 5)
    }
    
    func categoryViews(concentration: Concentration) -> some View {
        CategoryContainer(concentration: concentration, schedule: schedule)
    }
    
    func drop(providers: [NSItemProvider], at newConcentration: Concentration) -> Bool {
        let found = providers.loadFirstObject(ofType: String.self) { id in
            if let newIndex = shared.currentConcentrations.firstIndex(of: newConcentration.urlID) {
                if let droppedConcentration = getDroppedConcentration(id: id) {
                    withAnimation {
                        shared.moveInsertConcentration(droppedConcentration, at: newIndex)
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

//    @State private var isAdding: Bool = false

//    private var pos: (() -> CGPoint)?
    
//                if viewModel.insideConcentration, let course = viewModel.dragCourse, let pos = pos {
//                    ZStack {
//                        RoundedRectangle(cornerRadius: frameCornerRadius).stroke()
//                            .foregroundColor(viewModel.getColor(course.color, dark: colorScheme == .dark))
//                        Text(course.name)
//                    }
//                    .frame(width: courseWidth/2, height: courseHeight/2, alignment: .center)
//                    .position(geo.convert(pos(), from: .global))
////                    .offset(x: NSEvent.mouseLocation.x, y: -NSEvent.mouseLocation.y)
////                    .offset(getOffset(from: geo.convert(pos(), from: .global), in: geo.frame(in: .global)))
//                    .opacity(0.4)
//                }

//            .onMove(perform: { indices, newOffset in
//                indices.map { index in concentrations[index] }
//                    .forEach{ concentration in concentration.index = newOffset }
//                print("\(indices)")
//                print("\(newOffset)")
//            })
    
//    func getOffset(from point: CGPoint, in frame: CGRect) -> CGSize {
//        let height = point.y - frame.height/2
//        let width = point.x - frame.width/2
//        return CGSize(width: width, height: height)
//    }
//
//

    
    
    
//
//    var addGesture: some Gesture {
//        TapGesture()
//            .onEnded {
//                isAdding = !isAdding
//                print(isAdding)
//        }
//    }
    


//struct ConcentrationContainerView_Previews: PreviewProvider {
//    static var previews: some View {
//        ConcentrationContainerView()
//    }
//}
