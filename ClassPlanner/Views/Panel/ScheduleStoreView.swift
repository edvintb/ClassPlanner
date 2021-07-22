//
//  PanelSchedules.swift
//  ClassPlanner
//
//  Created by Edvin Berhan on 2021-05-18.
//

import SwiftUI

struct ScheduleStoreView: View {
    
    @EnvironmentObject var shared: SharedVM
    @ObservedObject var store: ScheduleStore
    
    // Needed if we want to search for schedules
    @State private var query: String = ""
    
    var matchingSchedules: [ScheduleVM] {
        let filteredSchedules = store.scheduleNames.filter { schedule, name in
            query.isEmpty || name.localizedCaseInsensitiveContains(query) }
        
        return Array(filteredSchedules.keys.sorted(by: {$0.name < $1.name }))
    }
    
    var body: some View {
        PanelHeaderView(addAction: store.addSchedule, searchQuery: $query) {
            List {
                ForEach (matchingSchedules) { schedule in
                    scheduleView(for: schedule)
                }
            }
        }
    }

    
    func scheduleView(for schedule: ScheduleVM) -> some View {
        ZStack(alignment: .leading) {
            RoundedRectangle(cornerRadius: frameCornerRadius).stroke()
                .contentShape(RoundedRectangle(cornerRadius: frameCornerRadius))
                .opacity(emptyOpacity)
            Text(store.name(for: schedule))
                .foregroundColor(schedule.color)
                .padding([.leading], 5)
        }
        .frame(height: panelScheduleHeight)
        .onTapGesture {
            shared.setCurrentSchedule(to: schedule)
            shared.setEditSelection(to: .schedule(schedule: schedule))
        }
    }
}


//
//struct PanelSchedules_Previews: PreviewProvider {
//
//    static var previews: some View {
//        PanelSchedules()
//    }
//}
