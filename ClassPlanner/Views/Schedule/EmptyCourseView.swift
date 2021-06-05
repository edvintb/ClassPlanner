
import SwiftUI

struct EmptyCourseView: View {
    
    // Needed to create new courses in schedule
    @EnvironmentObject var shared: SharedVM
    
    let semester: Int
    
    @Environment(\.managedObjectContext) var context
    
    // Won't show when dragging if we don't have both
    @State private var isDropping: Bool = false
    @State private var isOverCourse: Bool = false
    
    var body: some View {
        RoundedRectangle(cornerRadius: frameCornerRadius).stroke()
            .opacity((isOverCourse || isDropping) ? emptyHoverOpacity : 0)
            .contentShape(RoundedRectangle(cornerRadius: frameCornerRadius))
            .frame(height: courseHeight)
            .onTapGesture { tapped() }
            .onHover { isOverCourse = $0 }
            .onDrop(of: ["public.utf8-plain-text"], isTargeted: $isDropping) { drop(providers: $0) }
    }
    
    func tapped() {
        if let schedule = shared.currentSchedule {
            schedule.addEmptyCourse(to: semester, context: context)
        }
    }
    
    func drop(providers: [NSItemProvider]) -> Bool {
        let found = providers.loadFirstObject(ofType: String.self) { id in
            if let schedule = shared.currentSchedule {
                if let droppedCourse = getDroppedCourse(id: id) {
                    let newPos = getNewPos(for: droppedCourse, in: schedule)
                    withAnimation {
                        schedule.moveCourse(droppedCourse, to: newPos)
                    }
                }
            }
        }
        return found
    }
    
    private func getDroppedCourse(id: String) -> Course? {
        if let uri = URL(string: id) {
            return Course.fromCourseURI(uri: uri, context: context)
        }
        return nil
    }
    
    private func getNewPos(for droppedCourse: Course, in schedule: ScheduleVM) -> CoursePosition {
        // Counting all the courses different from the dropped one
        let courses = schedule.courses(for: semester)
        let count = courses.reduce(into: 0) { acc, course in
            if course != droppedCourse { acc += 1 }
        }
        return CoursePosition(semester: semester, index: count)
    }
}
