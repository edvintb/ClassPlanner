//
//  PanelSchedules.swift
//  ClassPlanner
//
//  Created by Edvin Berhan on 2021-05-18.
//

import SwiftUI

struct PanelSchedules: View {
    
    @ObservedObject var store: ScheduleStore
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.managedObjectContext) var context
    
    @State private var query: String = ""
    
    @State var isDropping: Bool = false
    
    
    
    var body: some View {
        VStack {
            List {
                ForEach (store.schedules) { schedule in
                    Text(store.name(for: schedule))
                }
            }
        }
    }
}

//struct PanelSchedules_Previews: PreviewProvider {
//    static var previews: some View {
//        PanelSchedules()
//    }
//}
