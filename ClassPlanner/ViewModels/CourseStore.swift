//
//  CourseStore.swift
//  ClassPlanner
//
//  Created by Edvin Berhan on 2021-05-18.
//

import CoreData
import SwiftUI
import Combine

class CourseStore: ObservableObject {
    
    let colors: Array<Color> = [.clear, .black, .white, .red, .blue, .yellow, .green, .orange, .purple]
    
    func getColor(_ index: Int, dark: Bool) -> Color {
        if index == 0 { return (dark ? .white : .black) }
        return colors[index]
    }
    
    private var subscriptions: Set<AnyCancellable> = []
    
    @Published private (set) var foundCourses: [Course] = [] // Initialize to all courses to filter
    @Published var courseQuery: String = ""
    
    init(context: NSManagedObjectContext) {
        $courseQuery
            .removeDuplicates()
            .map({ (string) -> String? in
                if string.count > 0 { return string }
                self.foundCourses = []
                return nil
            }) // prevents sending numerous requests and sends nil if the count of the characters is less than 1.
            .compactMap{ $0 } // removes the nil values so the search string does not get passed down to the publisher chain
            .sink { [unowned self] query in searchCourses(query: query, context: context) }
            .store(in: &subscriptions)
    }
    
    private func searchCourses(query: String, context: NSManagedObjectContext) {
        let predicate = NSPredicate(format: "name_ contains[cd] %@", argumentArray: [query])
        print(predicate)
        let request = Course.fetchRequest(predicate)
        let courses = (try? context.fetch(request)) ?? []
        self.foundCourses = courses
        print(foundCourses.count)
    }
    
    var numberFormatter: NumberFormatter {
        let numberFormatter = NumberFormatter()
        numberFormatter.maximumIntegerDigits = maxIntegers
        numberFormatter.maximumFractionDigits = maxDecimals
        numberFormatter.maximumSignificantDigits = maxSignificant
        numberFormatter.roundingMode = .down
        numberFormatter.zeroSymbol = ""
        numberFormatter.localizesFormat = true
        return numberFormatter
    }
}
