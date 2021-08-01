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
    @ObservedObject var concentrationVM: ConcentrationVM
    
    @Environment(\.managedObjectContext) var context
    @State var isDropping: Bool = false
    
    private var concentrations: [Concentration] {
        concentrationVM.currentConcentrations.compactMap { uri in
            NSManagedObject.fromURI(uri: uri, context: context) as? Concentration
        }
    }
    
    // For onboarding
    @State private var isShowingOnboarding: Bool = !UserDefaults.standard.bool(forKey: concentrationOnboardingKey)
    private func setConcentrationOnboarding(show: Bool) {
        withAnimation {
            self.isShowingOnboarding = show
            UserDefaults.standard.setValue(!show, forKey: concentrationOnboardingKey)
        }
    }
    
    @State private var isShowingCategoryOnboarding: Bool = !UserDefaults.standard.bool(forKey: concentrationEditorOnboardingKey)
    private func setCategoryOnboarding(show: Bool) {
        withAnimation {
            self.isShowingCategoryOnboarding = show
            UserDefaults.standard.setValue(!show, forKey: concentrationEditorOnboardingKey)
        }
    }
    
    private var isCatalina: Bool {
        if #available(macOS 11.0, *) { return false }
        else { return true }
    }
    
    var body: some View {
        let stableConcentrations = concentrations
        GeometryReader { geo in
            ScrollView([.vertical, .horizontal], showsIndicators: isCatalina) {
                VStack (alignment: .leading, spacing: 4) {
                    Spacer(minLength: 4)
                    ForEach (stableConcentrations) { concentration in
                        ConcentrationView(categoryViews: categoryViews, concentration: concentration, concentrationVM: concentrationVM, isShowingConcentrationOnboarding: $isShowingOnboarding)
                    }
                    EmptyConcentrationView(concentrationVM: concentrationVM)
                        .frame(minWidth: geo.size.width - 40)
                }
                .padding(.horizontal, 10)
            }
            .onReceive(shared.$isShowingOnboarding.dropFirst()) { show in
                setConcentrationOnboarding(show: show)
                setCategoryOnboarding(show: show)
            }
            .popover(isPresented: $isShowingOnboarding) {
                ConcentrationOnboardingView(
                    isShowingOnboarding: $isShowingOnboarding,
                    setConcentrationOnboarding: setConcentrationOnboarding
                )
            }
        }
    }
    
    func categoryViews(concentration: Concentration) -> some View {
        CategoryContainer(concentration: concentration, schedule: schedule)
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
