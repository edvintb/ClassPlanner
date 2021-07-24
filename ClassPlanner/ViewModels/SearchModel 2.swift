//
//  SearchModel.swift
//  ClassPlanner
//
//  Created by Stephan Michels on 13.12.20.
//  See LICENSE for this sample’s licensing information.

import Foundation
import CoreData
import Combine
import SwiftUI

final class SearchModel: ObservableObject {
    
    private let context: NSManagedObjectContext
    private let currentCourseID: NSManagedObjectID?
    
    var courses: [Course] {
        let predicate = (currentCourseID == nil ? .all : NSPredicate(format: "SELF != %@", argumentArray: [currentCourseID!] ))
        let request = Course.fetchRequest(predicate)
        let courses = (try? context.fetch(request)) ?? []
        return courses
    }
    
    @Published var currentText: String
    @Published var suggestionGroups: [SuggestionGroup<Course>] = []
    
    private var cancellables: Set<AnyCancellable> = []
    
    init(startingText: String, context: NSManagedObjectContext, avoid id: NSManagedObjectID? = nil) {
        self.context = context
        self.currentText = startingText
        self.currentCourseID = id
        
        
        self.$currentText
            .debounce(for: 0.1, scheduler: RunLoop.main)
            .removeDuplicates()
            .map { text -> [SuggestionGroup<Course>] in
                guard !text.isEmpty else {
                    return []
                }
                // prefix gives number of results
                let courseSuggestions = self.courses.lazy.filter({ $0.name.lowercased().hasPrefix(text.lowercased()) }).prefix(10).map { course -> Suggestion<Course> in
                    Suggestion(text: course.name, value: course)
                }
                var suggestionGroups: [SuggestionGroup<Course>] = []
                
                if !courseSuggestions.isEmpty {
                    suggestionGroups.append(SuggestionGroup<Course>(title: "Courses", suggestions: Array(courseSuggestions)))
                }
                return suggestionGroups
            }
            .assign(to: \SearchModel.suggestionGroups, on: self)
            .store(in: &cancellables)
        

    }
}



//        print("Search model init")
    
        // Perhaps load the harvard-json into a file and decode it like this
        // We could even fetch from the API in this initializer
        // Then we won't need the context
        
//        let bundle = Bundle.main
//        do {
//            let url = bundle.url(forResource: "english_german", withExtension: "json")!
//            let data = try! Data(contentsOf: url)
//            self.englishTranslations = try! JSONDecoder().decode([String:String].self, from: data)
//            self.englishWords = Array(self.englishTranslations.keys)
//        }
//        do {
//            let url = bundle.url(forResource: "german_english", withExtension: "json")!
//            let data = try! Data(contentsOf: url)
//            self.germanTranslations = try! JSONDecoder().decode([String:String].self, from: data)
//            self.germanWords = Array(self.germanTranslations.keys)
//        }

//        self.$currentText
//            .debounce(for: 0.3, scheduler: RunLoop.main)
//            .removeDuplicates()
//            .map { text -> String? in
//                if let englishTranslation = self.englishTranslations[text] {
//                    return englishTranslation
//                }
//                if let germanTranslation = self.germanTranslations[text] {
//                    return germanTranslation
//                }
//                return nil
//            }
//            .assign(to: \DictionaryModel.currentTranslation, on: self)
//            .store(in: &cancellables)
