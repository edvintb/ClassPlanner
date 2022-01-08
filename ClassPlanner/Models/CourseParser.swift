//
//  CourseParser.swift
//  ClassPlanner
//
//  Created by Edvin Berhan on 29.12.21.
//

import Foundation
import CoreData

struct CourseRatingData {
    
    var enrollment: Int
    var score: Double
    var workload: Double
    var year: Int
    var professorFullName: String
}

func parseCourseFile(courseFileArray: [String], ratingFile: String, context: NSManagedObjectContext, school: School) {
    
    let idRatingDict = parseRatingFile(ratingFile: ratingFile)
    
    for courseFile in courseFileArray {
        guard let coursePath = Bundle.main.path(forResource: courseFile, ofType: "csv") else {
            print("could not find file")
            return
        }
        
        var data = ""
        
        do {
            data = try String(contentsOfFile: coursePath)
        } catch {
            print(error)
            return
        }
        
        let rows = data.components(separatedBy: "\n")
        
        for row in rows.dropFirst() {
            let columns = row.components(separatedBy: ";")
            
            // Check if data format correct
            if columns.count < 8 {
                print("Too few columns in course file")
                print(row)
                continue
            }
            
            let course_id = columns[0].replacingOccurrences(of: "  ", with: " ")
            let name = columns[1]
            let professorLastName = columns[2].replacingOccurrences(of: " ", with: "")
            // let department = columns[3]
            let semester = columns[4]
            let days = columns[5]
            let time = columns[6]
            let notes = columns[7].dropLast()
            
            let course = Course.fetchCreate(course_id: course_id, context: context)
            
            // We want to update everything but keep the course, this way they stay in the schedule
            course.name = name
            course.professorName = professorLastName
            course.notes = String(notes)
            course.school = school
            
            // Setting ratings
            if let ratingArray = idRatingDict?[course.course_id] {
                var foundProfessor: Bool = false
                
                for rating in ratingArray {
                    if !foundProfessor && rating.year > course.rating_year {
                        course.enrollment = rating.enrollment
                        course.qscore = rating.score
                        course.workload = rating.workload
                        course.rating_year = rating.year
                        if rating.professorFullName.hasSuffix(course.professorName) {
                            // Update professor if right name found
                            course.professorName = rating.professorFullName
                            foundProfessor = true
                        }
                    }
            
                    else if foundProfessor && rating.professorFullName == course.professorName && rating.year > course.rating_year {
                        course.enrollment = rating.enrollment
                        course.qscore = rating.score
                        course.workload = rating.workload
                        course.rating_year = rating.year
                    }
                }
            }
            
            // Setting semester
            if semester.contains("Fall")
            {
                course.fall = true
            }
            
            if semester.contains("Spring")
            {
                course.spring = true
            }
            
            // Setting correct days
            let dayArray = Array(days)
            
            for (index, char) in dayArray.enumerated() {
                if char == "T" {
                    if index + 1 < dayArray.endIndex && dayArray[index + 1] == "h" {
                        course.thursday = true
                    }
                    else {
                        course.tuesday = true
                    }
                }
                else if char == "M" {
                    course.monday = true
                }
                else if char == "W" {
                    course.wednesday = true
                }
                else if char == "F" {
                    course.friday = true
                }
            }
            
            // Setting course time
            let timeComponents = time.components(separatedBy: " ")
            
            if let startTime = parseTime(clock: timeComponents[0]) {
                course.time_ = startTime
            }
            if let stopTime = parseTime(clock: timeComponents.last ?? "") {
                course.stopTime_ = stopTime
            }
        }
    }
}

func parseTime(clock: String) -> Date? {
    let components = clock.components(separatedBy: ":")
    
    if components.count < 2 {
        return nil
    }

    var totalSeconds: Double = 0

    let hour = Double(components[0]) ?? 0
    totalSeconds += hour * 3600
    
    let minute = Double(String(components[1][0]) + String(components[1][1])) ?? 0
    totalSeconds += minute * 60
    
    let isPM: Bool = components[1][2] == "p" && hour != 12
    if isPM {
        totalSeconds += 12 * 3600
    }
    
    return Date.init(timeIntervalSinceReferenceDate: totalSeconds)
}

func parseRatingFile(ratingFile: String) -> [String:[CourseRatingData]]? {
    guard let ratingPath = Bundle.main.path(forResource: ratingFile, ofType: "csv") else {
        print("could not find file")
        return nil
    }
    
    var ratingData = ""
    
    do {
        ratingData = try String(contentsOfFile: ratingPath)
    } catch {
        print(error)
        return nil
    }
    
    let ratingRows = ratingData.components(separatedBy: "\n")
    
    var idRatingDict : [String:[CourseRatingData]] = [:]
    
    for row in ratingRows.dropFirst() {
        let columns = row.components(separatedBy: ";")
        // print(row)
        
        // Check if separation successful
        if columns.count < 8 {
            print("Too few columns in rating file")
            continue
        }
        
        // let course_link = columns[0]
        // let course_href = columns[1]
        let enrollment = Int(columns[2]) ?? 0
        let score = Double(columns[3]) ?? 0
        let mean_work = Double(columns[4]) ?? 0
        let professor = columns[5]
        let course_id = columns[6]
        // print("Column Value: \(columns[7]). Integer value: \(Int(columns[7].dropLast()))")
        // There is a newline character at the end of each row
        let year = Int(columns[7].dropLast()) ?? 0
        // print("Year value: \(year)")
        
        let data = CourseRatingData(enrollment: enrollment, score: score, workload: mean_work, year: year, professorFullName: professor)
        
        idRatingDict[course_id, default: []].append(data)

    }
    
    return idRatingDict
}
