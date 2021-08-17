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
    private let directory: URL
    private let context: NSManagedObjectContext
    
    // Duplicate needed for editing & later verification
    @Published private (set) var scheduleNames = [ScheduleVM:String]()
    
    // Publishes user tries to set to an existing name
    @Published var existingNameAlert: IdentifiableString?
    
    var schedules: [ScheduleVM] {
        scheduleNames.keys.sorted { scheduleNames[$0]! < scheduleNames[$1]! }
    }
    
    func name(for schedule: ScheduleVM) -> String {
        scheduleNames[schedule, default: "Schedule"]
    }
    
    // The type has to be this to save in user defaults
    private (set) var completedSemesterDict: [Int:[URL]]
    
    func setSemesterAsCompleted(semester: Int, courseArray: [Course]?) {
        self.completedSemesterDict[semester] = courseArray?.map({ course in course.urlID }) ?? nil
        var dictToSave = [String:[String]]()
        completedSemesterDict.forEach( { dictPair in
            let (intKey, urlArray) = dictPair
            dictToSave[String(intKey)] = urlArray.map { url in url.absoluteString }
        })
        UserDefaults.standard.set(dictToSave, forKey: completedSemesterKey)
        withAnimation(quickAnimation) {
            objectWillChange.send()
        }
    }
    
    private var cancellables: Set<AnyCancellable> = []
    
    init(directory: URL, context: NSManagedObjectContext, shared: SharedVM) {
        self.shared = shared
        self.context = context
        self.directory = directory
        completedSemesterDict = [:]
        let savedDict = UserDefaults.standard.dictionary(forKey: completedSemesterKey) ?? [:]
        savedDict.forEach { savedDictPair in
            let (stringKey, any) = savedDictPair
            if let intKey = Int(stringKey), let stringArray = any as? [String] {
                completedSemesterDict[intKey] = stringArray.compactMap({ stringURL in URL(string: stringURL)})
            }
        }
        
        do {
            let schedules = try FileManager.default.contentsOfDirectory(atPath: directory.path)
            for schedule in schedules {
                let url = directory.appendingPathComponent(schedule)
                let scheduleVM = ScheduleVM(completedSemesterDict: completedSemesterDict, url: url, context: context)
                scheduleNames[scheduleVM] = schedule
            }
        }
        catch {
            print("Error reading documents from directory: \(directory), \(error.localizedDescription)")
        }
    }
    
    
    // MARK: - Naming Schedules
    
    func setName(_ newName: String, for schedule: ScheduleVM) {
        if approveName(newName, for: schedule) {
            // Deleting at the old url
            deleteSchedule(schedule)
            // Each time we set the url we are saving
            schedule.url = directory.appendingPathComponent(newName)
            // Update name in store
            scheduleNames[schedule] = newName
        }
    }
    
    private func approveName(_ newName: String, for schedule: ScheduleVM) -> Bool {
        // If the schedule we are naming does not exist we return
        // This means the schedule has been deleted and should not be named
        if scheduleNames[schedule] == nil { return false }
        // Setting to the same name has no effect
        if scheduleNames[schedule] == newName { return false }
        // Setting to empty name resets the name
        if newName == "" { schedule.name = name(for: schedule); return false }
        // Setting to existing name toggles alert and resets
        if scheduleNames.values.contains(newName) || newName == "" {
            existingNameAlert = IdentifiableString(value: newName)
            schedule.name = name(for: schedule)
            return false
        }
        return true
    }
    
    // MARK: - Adding & Removing Schedules
    
    func addSchedule() {
        let name = "Schedule"
        let uniqueName = name.uniqued(withRespectTo: scheduleNames.values)
        let schedule: ScheduleVM
        let url = directory.appendingPathComponent(uniqueName)
        schedule = ScheduleVM(completedSemesterDict: completedSemesterDict, url: url, context: context)
        scheduleNames[schedule] = uniqueName
    }

    func deleteSchedule(_ schedule: ScheduleVM) {
        if let name = scheduleNames[schedule] {
            if name == "" { print("Found empty name. THIS CAUSES /Documents/ to DISAPPEAR"); return }
            let url = directory.appendingPathComponent(name)
            do {
                try FileManager.default.removeItem(at: url)
            }
            catch {
                print("Error deleting schedule at url: \(url), \(error.localizedDescription)")
            }
        }
        scheduleNames.removeValue(forKey: schedule)
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
