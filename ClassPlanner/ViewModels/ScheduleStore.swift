//
//  ScheduleStore.swift
//  ClassPlanner
//
//  Created by Edvin Berhan on 2021-05-18.
//

import Foundation
import Combine
import CoreData
import SwiftUI


class ScheduleStore: ObservableObject {
    
    
    private let shared: SharedVM
    
    private (set) var directory: URL
    let name: String
    let context: NSManagedObjectContext
    
    
    // Perhaps remove this whole thing and just go with the single source of truth
    // in the schedule itself? It still gets stored in the filename itself
    @Published private (set) var scheduleNames = [ScheduleVM:String]()
    
    @Published var doubleNameAlert: Bool = false
    
    private var cancellables: Set<AnyCancellable> = []
    
    var schedules: [ScheduleVM] {
        scheduleNames.keys.sorted { scheduleNames[$0]! < scheduleNames[$1]! }
    }
    
    func setCurrentSchedule(to schedule: ScheduleVM) {
        shared.setCurrentSchedule(to: schedule)
    }
    
    init(directory: URL, context: NSManagedObjectContext, shared: SharedVM) {
        self.shared = shared
        self.context = context
        self.name = directory.lastPathComponent
        self.directory = directory
        do {
            let schedules = try FileManager.default.contentsOfDirectory(atPath: directory.path)
            for schedule in schedules {
                let url = directory.appendingPathComponent(schedule)
                let scheduleVM = ScheduleVM(url: url, context: context)
                scheduleNames[scheduleVM] = schedule
                
                // Try updating the stored name when we change in schedule
                scheduleVM.$name
                    .debounce(for: 0.5, scheduler: DispatchQueue.main)
                    .removeDuplicates()
                    .sink { [unowned self] name in
                        self.setName(name, for: scheduleVM)
                    }
                    .store(in: &cancellables)
            }
        }
        catch {
            print("Error reading documents from directory: \(directory), \(error.localizedDescription)")
        }
    }
    
    // MARK: - Intents
    
    func removeFromSchedule(course: Course) {
        if let schedule = shared.currentSchedule {
            schedule.deleteCourse(course)
        }
    }
    
    func replaceCourse(old: Course, new: Course) {
        if old == new { return }
        if let schedule = shared.currentSchedule {
            schedule.replaceCourse(old: old, with: new)
        }
    }
    
    
    // MARK: - Naming Schedules
    func name(for schedule: ScheduleVM) -> String {
        if scheduleNames[schedule] == nil {
            scheduleNames[schedule] = "Untitled"
        }
        return scheduleNames[schedule]!
    }
    
    func setName(_ name: String, for schedule: ScheduleVM) {
        // Setting to an existing name causes popup to appear unless this line
        if scheduleNames[schedule] == name { return }
        let url = directory.appendingPathComponent(name)
        if scheduleNames.values.contains(name) { doubleNameAlert.toggle() }
        else {
            // Deleting at the old url
            removeSchedule(schedule)
            // Each time we set the url we are saving
            schedule.url = url
            // Update in my store
            scheduleNames[schedule] = name
        }
        schedule.name = scheduleNames[schedule] ?? "Untitled"
    }
    
    // MARK: - Handling Schedules
    
    func addSchedule(named name: String = "Untitled") {
        let uniqueName = name.uniqued(withRespectTo: scheduleNames.values)
        let schedule: ScheduleVM
        let url = directory.appendingPathComponent(uniqueName)
        schedule = ScheduleVM(url: url, context: context)
        scheduleNames[schedule] = uniqueName
    }

    func removeSchedule(_ schedule: ScheduleVM) {
        if let name = scheduleNames[schedule] {
            let url = directory.appendingPathComponent(name)
            try? FileManager.default.removeItem(at: url)
        }
        scheduleNames[schedule] = nil
    }
    

}


//        shared.$currentEditSelection
//            .map { (option) -> Course? in
//                switch option {
//                case .course(let course):
//                    print(course.objectID)
//                    return course
//                default:
//                    return nil
//                }
//            }
//            .assign(to: \.currentEditCourse, on: self)
//            .store(in: &cancellables)
//
//        panel.suggestionModel.$suggestionConfirmed
//            .sink { [unowned self] confirmed in
//                if confirmed,
//                    let newCourse = panel.suggestionModel.selectedSuggestion?.value,
//                    let oldCourse = currentEditCourse {
//                    // print(oldCourse)
//                    // Maybe we won't have access to the old course
//                    // Replacing old course
//                    self.replaceCourse(old: oldCourse, new: newCourse)
//                    shared.setEditSelection(to: .course(course: newCourse))
//                }
//                else {
//                    print("Not confirmed suggestion")
//                }
//            }
//            .store(in: &cancellables)
//
//        panel.suggestionModel.suggestionsCancelled
//            .sink { [unowned self] _ in
//                let predicate = NSPredicate(format: "name_ =[c] %@", argumentArray: [panel.suggestionModel.textBinding?.wrappedValue ?? ""])
//                let request = Course.fetchRequest(predicate)
//                let courses = (try? context.fetch(request)) ?? []
//                if let new = courses.first, let old = currentEditCourse {
//                    self.replaceCourse(old: old, new: new)
//                    shared.setEditSelection(to: .course(course: new))
//                }
//            }
//            .store(in: &cancellables)


//        currentSchedule?.$name
//            .sink { [unowned self] name in
//                print(name)
//                if let schedule = currentSchedule {
//                    self.setName(name, for: schedule)
//                }
//            }
//            .store(in: &cancellables)
        
        
//        $searchText
//            .debounce(for: 0.3, scheduler: RunLoop.main)
//            .removeDuplicates()
//            .map { text -> [SuggestionGroup<String>] in {
//                guard !text.isEmpty else {
//                    return []
//                }
//                let dbSuggestions = self.
//
//            }}

//{
//    let name: String
//
//    func name(for document: EmojiArtDocument) -> String {
//        if documentNames[document] == nil {
//            documentNames[document] = "Untitled"
//        }
//        return documentNames[document]!
//    }
//
//    func setName(_ name: String, for document: EmojiArtDocument) {
//        documentNames[document] = name
//    }
//
//    var documents: [EmojiArtDocument] {
//        documentNames.keys.sorted { documentNames[$0]! < documentNames[$1]! }
//    }
//
//    func addDocument(named name: String = "Untitled") {
//        documentNames[EmojiArtDocument()] = name
//    }
//
//    func removeDocument(_ document: EmojiArtDocument) {
//        documentNames[document] = nil
//    }
//
//    @Published private var documentNames = [EmojiArtDocument:String]()
//
//    private var autosave: AnyCancellable?
//
//    init(named name: String = "Emoji Art") {
//        self.name = name
//        let defaultsKey = "EmojiArtDocumentStore.\(name)"
//        documentNames = Dictionary(fromPropertyList: UserDefaults.standard.object(forKey: defaultsKey))
//        autosave = $documentNames.sink { names in
//            UserDefaults.standard.set(names.asPropertyList, forKey: defaultsKey)
//        }
//    }
//}
//
//extension Dictionary where Key == EmojiArtDocument, Value == String {
//    var asPropertyList: [String:String] {
//        var uuidToName = [String:String]()
//        for (key, value) in self {
//            uuidToName[key.id.uuidString] = value
//        }
//        return uuidToName
//    }
//
//    init(fromPropertyList plist: Any?) {
//        self.init()
//        let uuidToName = plist as? [String:String] ?? [:]
//        for uuid in uuidToName.keys {
//            self[EmojiArtDocument(id: UUID(uuidString: uuid))] = uuidToName[uuid]
//        }
//    }
//}
