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
    
    private (set) var directory: URL
    
    @Environment(\.managedObjectContext) var context
    
    // Needed to update the current schedule
    let shared: SharedVM
    
    let nameOfStore: String = "Documents"
    
    // Perhaps remove this whole thing and just go with the single source of truth
    // in the schedule itself? It still gets stored in the filename itself
    @Published private (set) var scheduleNames = [ScheduleVM:String]()
    
    // Toggled when an existing name is entered
    @Published var doubleNameAlert: Bool = false
    
    private var cancellables: Set<AnyCancellable> = []
    
    var schedules: [ScheduleVM] {
        scheduleNames.keys.sorted { scheduleNames[$0]! < scheduleNames[$1]! }
    }
    
    
    // Who calls this function?? Remove?
    func setCurrentSchedule(to schedule: ScheduleVM) {
        shared.setCurrentSchedule(to: schedule)
        // Needed to update categories
        // We need a shared VM
        objectWillChange.send()
    }
    
    init(directory: URL, shared: SharedVM) {
        self.directory = directory
        print(directory)
        self.shared = shared
        do {
            let schedules = try FileManager.default.contentsOfDirectory(atPath: directory.path)
            for schedule in schedules {
                let scheduleVM = ScheduleVM(url: directory.appendingPathComponent(schedule), shared: shared)
                scheduleNames[scheduleVM] = schedule
            }
        }
        catch {
            print("Error reading documents from directory: \(directory), \(error.localizedDescription)")
        }
    }
    
    // MARK: - Intents
    
    func removeFromSchedule(course: Course) {
        print("Deleting from Editor")
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
        schedule.scheduleName = scheduleNames[schedule] ?? "Untitled"
    }
    
    // MARK: - Handling Schedules
    
    func addSchedule(named name: String = "Untitled") {
        let uniqueName = name.uniqued(withRespectTo: scheduleNames.values)
        let schedule: ScheduleVM
        let url = directory.appendingPathComponent(uniqueName)
        schedule = ScheduleVM(url: url, shared: shared)
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
