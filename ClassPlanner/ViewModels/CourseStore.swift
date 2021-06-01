//
//  CourseStore.swift
//  ClassPlanner
//
//  Created by Edvin Berhan on 2021-05-18.
//

// https://betterprogramming.pub/search-bar-and-combine-in-swift-ui-46f37cec5a9f for more info about how this thing works

import CoreData
import SwiftUI
import Combine

class CourseStore: ObservableObject {
    
    // This thing needs a way to alter a given schedule
    // The current schedule is in the ScheduleStore
    // We actually only need to drag them out of here and drop them into the schedule
    
    private var panel: PanelVM
    
    private var subscriptions: Set<AnyCancellable> = []
    
    @Published private (set) var dbCourses: [Course] = [] // Initialize to all courses to filter
    @Published private (set) var networkCourses: [Course] = []
    @Published var courseQuery: String = ""
    
    func setEditCourse(course: Course) {
        panel.setEditSelection(to: .course(course: course))
    }
    
    init(context: NSManagedObjectContext, panel: PanelVM) {
        self.panel = panel
        $courseQuery
            .removeDuplicates()
            .map({ (string) -> String? in
                if string.count > 0 { return string }
                self.dbCourses = []
                return nil
            }) // prevents sending numerous requests and sends nil if the count of the characters is less than 1.
            .compactMap{ $0 } // removes the nil values so the search string does not get passed down to the publisher chain
            .sink { [unowned self] query in
                print("DB value")
                dbSearch(query: query, context: context)
            }
            .store(in: &subscriptions)
        $courseQuery
            .debounce(for: .milliseconds(800), scheduler: RunLoop.main) // debounces the string publisher, such that it delays the process of sending request to remote server.
            .removeDuplicates()
            .map({ (string) -> String? in
                if string.count > 0 { return string }
                self.networkCourses = []
                return nil
            }) // prevents sending numerous requests and sends nil if the count of the characters is less than 1.
            .compactMap{ $0 } // removes the nil values so the search string does not get passed down to the publisher chain
            .sink { (_) in
                //
            } receiveValue: { [unowned self] text in
                print("Value Recieved")
                networkSearch(searchText: text)
            }.store(in: &subscriptions)
    }
    
    private func dbSearch(query: String, context: NSManagedObjectContext) {
        print("old")
        
        let predicate = NSPredicate(format: "name_ contains[cd] %@", argumentArray: [query])
        print(predicate)
        let request = Course.fetchRequest(predicate)
        let courses = (try? context.fetch(request)) ?? []
        self.dbCourses = courses
        print(dbCourses.count)
    }
    
    private func networkSearch(searchText: String) {
        
        print("New")
        
        guard let url = URL(string: "https://go.apis.huit.harvard.edu/api/adex/helloworld") else {
            print("Invalid URL")
            return
        }
        
        var request = URLRequest(url: url)
        request.addValue("pOU6g9ZNY9rZc68BaeGpI9irUfQqCA1b", forHTTPHeaderField: "X-Api-Key")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        print(request)
        print(request.allHTTPHeaderFields ?? "No header fields")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
//                if let decodedResponse = try? JSONDecoder().decode(Response.self, from: data) {
//                    // we have good data – go back to the main thread
                    DispatchQueue.main.async {
                        // update our UI
//                        self.results = decodedResponse.results
                        print(data)
                        print(response ?? "No Response")
                        print("Hello")
                    }

                    // everything is good, so we can exit
                    return
                }
            print("Fetch failed: \(error?.localizedDescription ?? "Unknown error")")
            }.resume()
    }

}
