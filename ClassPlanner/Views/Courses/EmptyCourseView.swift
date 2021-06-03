
import SwiftUI

struct EmptyCourseView: View {
    
    let semester: Int
    
    @Environment(\.managedObjectContext) var context
    
    // Needed to create new courses in schedule
    @EnvironmentObject var schedule: ScheduleVM
    
//    @State private var isTargeted: Bool = false
    @State private var isDropping: Bool = false
    @State private var isOverCourse: Bool = false
    
    var body: some View {
        VStack(alignment: .center, spacing: 0) {
            RoundedRectangle(cornerRadius: frameCornerRadius).stroke()
                .opacity((isOverCourse || isDropping) ? emptyHoverOpacity : 0)
                .frame(width: courseWidth, height: courseHeight)
                .contentShape(RoundedRectangle(cornerRadius: frameCornerRadius))
                // Should be done to Schedule
                .onTapGesture { schedule.addEmptyCourse(to: semester, context: context) }
                .onHover { isOverCourse = $0 }
                .onDrop(of: ["public.utf8-plain-text"], isTargeted: $isDropping) { drop(providers: $0) }
            RoundedRectangle(cornerRadius: frameCornerRadius).opacity(0.001)
                .frame(minWidth: courseWidth, maxWidth: courseWidth, minHeight: courseHeight, maxHeight: .infinity)
//                .onHover { isTargeted = viewModel.hoverOverEmptyCourse(entered: $0, inCourse: false, semester: semester) }
        }
    }
    
    func drop(providers: [NSItemProvider]) -> Bool {
        let found = providers.loadFirstObject(ofType: String.self) { id in
            if let droppedCourse = getDroppedCourse(id: id) {
                let newPos = getNewPos(for: droppedCourse)
                withAnimation {
                    schedule.moveCourse(droppedCourse, to: newPos)
                }
            }
        }
        return found
    }
    
    private func getDroppedCourse(id: String) -> Course? {
        if let uri = URL(string: id) {
            return Course.fromURI(uri: uri, context: context)
        }
        return nil
    }
    
    private func getNewPos(for droppedCourse: Course) -> CoursePosition {
        // Counting all the courses different from the dropped one
        let count = schedule.courses(for: semester).reduce(into: 0) { acc, course in
            if course != droppedCourse { acc += 1 }
        }
        return CoursePosition(semester: semester, index: count)
    }
}
