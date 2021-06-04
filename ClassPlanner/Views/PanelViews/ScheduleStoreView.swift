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
    @Environment(\.managedObjectContext) var context
    
    // Needed if we want to search for schedules
    @State private var query: String = ""
    
    @State private var isEditing: Bool = false
    
    var body: some View {
        VStack(spacing: 2) {
            buttons
            List {
                ForEach (store.schedules) { schedule in
                    scheduleView(for: schedule)
                        .onTapGesture {
                            shared.setCurrentSchedule(to: schedule)
                            shared.setEditSelection(to: .schedule(schedule: schedule))
                        }
                }
            }
        }
    }
    
    var buttons: some View {
        HStack {
            Button(action: { store.addSchedule() }, label: {
                Text("􀅼")
            })
            Spacer()
//            Button(action: { isEditing.toggle(); print(isEditing) }, label: {
//              Text("Edit")
//
//            })
        }
        .padding([.top, .horizontal], 5)
        .padding(.bottom, 2)

    }
    
    func scheduleView(for schedule: ScheduleVM) -> some View {
        ZStack(alignment: .leading) {
            RoundedRectangle(cornerRadius: frameCornerRadius).stroke()
                .contentShape(RoundedRectangle(cornerRadius: frameCornerRadius))
                .opacity(emptyHoverOpacity)
            Text(store.name(for: schedule))
                .foregroundColor(schedule.color)
                .padding([.leading], 5)
        }
        .padding(5)
        .frame(height: panelScheduleHeight)
        .frame(minWidth: editorWidth, maxWidth: .infinity)
       

    }
}


//
//struct PanelSchedules_Previews: PreviewProvider {
//
//    static var previews: some View {
//        PanelSchedules()
//    }
//}
