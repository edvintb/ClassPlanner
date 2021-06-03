//
//  SearchModel.swift
//  ClassPlanner
//
//  Created by Edvin Berhan on 2021-05-21.
//
//  Original code by Stephan Michels

import Foundation
import CoreData
import Combine
import SwiftUI

final class SearchModel: ObservableObject {
//    var englishWords: [String]
//    var englishTranslations: [String:String]
//    var germanWords: [String]
//    var germanTranslations: [String:String]
//
//    @Environment(\.managedObjectContext) var context
    
    private let context: NSManagedObjectContext
    private let currentCourseID: NSManagedObjectID
    
    var courses: [Course] {
        let request = Course.fetchRequest(NSPredicate(format: "SELF != %@", argumentArray: [currentCourseID] ))
//        let request = Course.fetchRequest(.all)
        let courses = (try? context.fetch(request)) ?? []
        return courses
    }
    
    @Published var currentText: String
    @Published var suggestionGroups: [SuggestionGroup<Course>] = []
    
    private var cancellables: Set<AnyCancellable> = []
    
    init(course: Course, context: NSManagedObjectContext) {
        self.context = context
        self.currentText = course.name
        self.currentCourseID = course.objectID
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
        
        self.$currentText
            .debounce(for: 0.1, scheduler: RunLoop.main)
            .removeDuplicates()
            .map { text -> [SuggestionGroup<Course>] in
                guard !text.isEmpty else {
                    return []
                }
                // prefix gives number of results
                let courseSuggestions = self.courses.lazy.filter({ $0.name.localizedCaseInsensitiveContains(text) }).prefix(10).map { course -> Suggestion<Course> in
                    Suggestion(text: course.name, value: course)
                }
//                let germanSuggestions = self.germanWords.lazy.filter({ $0.hasPrefix(text) }).prefix(10).map { word -> Suggestion<String> in
//                    Suggestion(text: word, value: word)
//                }
                var suggestionGroups: [SuggestionGroup<Course>] = []
                
                if !courseSuggestions.isEmpty {
                    suggestionGroups.append(SuggestionGroup<Course>(title: "Courses", suggestions: Array(courseSuggestions)))
                }
//                if !germanSuggestions.isEmpty {
//                    suggestionGroups.append(SuggestionGroup<String>(title: "German", suggestions: Array(germanSuggestions)))
//                }
                return suggestionGroups
            }
            .assign(to: \SearchModel.suggestionGroups, on: self)
            .store(in: &cancellables)
        
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
    }
}
