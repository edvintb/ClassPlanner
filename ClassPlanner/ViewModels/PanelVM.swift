//
//  ConcentrationVM.swift
//  ClassPlanner
//
//  Created by Edvin Berhan on 2021-05-02.
//

import Foundation
import CoreData

class PanelVM: ObservableObject {
    
    @Published var currentPanelSelection: PanelOption = .courses
    
    
    
}


    
//    func updateConcentrationIndices(context: NSManagedObjectContext) {
//        let request = Concentration.fetchRequest(.all)
//        let otherConcentration = (try? context.fetch(request)) ?? []
//        for index in 0..<otherConcentration.count {
//            otherConcentration[index].index = index
//        }
//        try? context.save()
//    }
