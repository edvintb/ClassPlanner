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
    
    var body: some View {
        VStack(spacing: 2) {
            buttons
            List {
                ForEach (store.schedules) { schedule in
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
        .padding(5)
        .frame(height: panelScheduleHeight)
        .frame(minWidth: editorWidth)
        .onTapGesture {
            shared.setCurrentSchedule(to: schedule)
            shared.setEditSelection(to: .schedule(schedule: schedule))
        }
       

    }
    
    
    var buttons: some View {
        HStack {
            Button(action: { store.addSchedule() }, label: {
                Text("􀅼")
            })
            Spacer()
        }
        .padding([.top, .horizontal], 5)
        .padding(.bottom, 2)

    }
}


//
//struct PanelSchedules_Previews: PreviewProvider {
//
//    static var previews: some View {
//        PanelSchedules()
//    }
//}
