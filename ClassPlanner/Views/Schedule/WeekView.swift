//
//  WeekView.swift
//  ClassPlanner
//
//  Created by Edvin Berhan on 07.01.22.
//

import SwiftUI

struct WeekView: View {
    
    @EnvironmentObject var shared: SharedVM
    
    @Binding var isPresented: Bool
    
    let courseArray: Array<Course>
    var dateArray: Array<Date> {
        var startTime = shared.weekStartTime
        let stopTime = shared.weekStopTime
        var array = [startTime]
        while startTime < stopTime {
            startTime += 300
            array.append(startTime)
        }
        return array
    }
    
    var body: some View {
        VStack {
//                Text("Week Schedule")
//                    .font(.title)
//                    .frame(maxWidth: .infinity)
            weekView
            ZStack {
                HStack {
                    Group {
                        DatePicker("Start Time", selection: $shared.weekStartTime, in: Date.oneDayRange, displayedComponents: .hourAndMinute)
                        DatePicker("End Time", selection: $shared.weekStopTime, in: Date.oneDayRange, displayedComponents: .hourAndMinute)
                    }
                    .labelsHidden()
                    .environment(\.timeZone, TimeZone(secondsFromGMT: 0)!)
                    .frame(width: 140)
                    Stepper("\(shared.courseLength) min/course", value: $shared.courseLength, in: 5...300, step: 5)
                }
                Button(action: { isPresented = false }, label: { Text("Close") })
                    .frame(maxWidth: .infinity, alignment: .trailing)
            }
        }
    }
    
    var weekView: some View {
        HStack(spacing: 0) {
            dayView("Monday", courseArray: courseArray.filter { $0.monday }, showTime: true)
            Divider()
            dayView("Tuesday", courseArray: courseArray.filter { $0.tuesday }, showTime: false)
            Divider()
            dayView("Wednesday", courseArray: courseArray.filter { $0.wednesday }, showTime: false)
            Divider()
            dayView("Thursday", courseArray: courseArray.filter { $0.thursday }, showTime:  false)
            Divider()
            dayView("Friday", courseArray: courseArray.filter { $0.friday }, showTime: false)
        }.frame(height: 500)
    }
    
    func dayView(_ dayName: String, courseArray: [Course], showTime: Bool) -> some View {
        VStack(alignment: .trailing, spacing: 0) {
            Text(dayName)
                .padding(.vertical, 5)
                .frame(maxWidth: .infinity, alignment: .center)
                .offset(x: showTime ? 22 : 0, y: 0)
            ForEach(dateArray, id: \.self) { date in
                HStack(spacing: 2) {
                    if showTime && date.minute == 0 {
                        Rectangle().frame(width: 45).opacity(0).overlay(
                            Text(DateFormatter.courseTime.string(from: date))
                        )
                    }
                    ZStack(alignment: .top) {
                        if date.minute == 0 && date != shared.weekStartTime && date != shared.weekStopTime {
                            VStack {
                                Divider()
                            }
                        }
                        Rectangle()
                            .opacity(0.1)
                        HStack (spacing: 0) {
                            ForEach(courseArray.filter { $0.timeInterval.contains(date) }, id: \.self) { course in
                                    Rectangle()
                                        .foregroundColor(course.getColor())
                                        .opacity(0.4)
                                        .overlay(
                                            Text(course.time == date ? course.idOrName : "")
                                                    .offset(x: 0, y: 8)
                                        )
                            }
                        }
                    }.frame(width: 120)
                }
            }
        }
    }
}
