//
//  ScheduleStore.swift
//  ClassPlanner
//
//  Created by Edvin Berhan on 2021-05-18.
//

import SwiftUI
import CoreData


class ScheduleStore: ObservableObject {
    
    @Published var scheduleNames = [ScheduleVM:String]()
    
    var schedules: [ScheduleVM] {
        scheduleNames.keys.sorted { scheduleNames[$0]! < scheduleNames[$1]! }
    }
    
    var directory: URL
    let name: String
    let context: NSManagedObjectContext
    
    // MARK: - Naming Schedules
    func name(for schedule: ScheduleVM) -> String {
        if scheduleNames[schedule] == nil {
            scheduleNames[schedule] = "Untitled"
        }
        return scheduleNames[schedule]!
    }
    
    func setName(_ name: String, for schedule: ScheduleVM) {
        let url = directory.appendingPathComponent(name)
        if !scheduleNames.values.contains(name) {
            removeSchedule(schedule)
            schedule.url = url
            scheduleNames[schedule] = name
        }
    }
    
    // MARK: - Handling Schedules
    
    func addSchedule(named name: String = "Untitled") {
        let uniqueName = name.uniqued(withRespectTo: scheduleNames.values)
        let schedule: ScheduleVM
        let url = directory.appendingPathComponent(uniqueName)
        schedule = ScheduleVM(context: context, url: url)
        scheduleNames[schedule] = uniqueName
    }

    func removeSchedule(_ schedule: ScheduleVM) {
        if let name = scheduleNames[schedule] {
            let url = directory.appendingPathComponent(name)
            try? FileManager.default.removeItem(at: url)
        }
        scheduleNames[schedule] = nil
    }
    
    init(directory: URL, context: NSManagedObjectContext) {
        self.context = context
        self.name = directory.lastPathComponent
        self.directory = directory
        do {
            let schedules = try FileManager.default.contentsOfDirectory(atPath: directory.path)
            for schedule in schedules {
                let scheduleVM = ScheduleVM(context: context, url: directory.appendingPathComponent(schedule))
                scheduleNames[scheduleVM] = schedule
            }
        }
        catch {
            print("Error reading documents from directory: \(directory), \(error.localizedDescription)")
        }
    }
}


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
