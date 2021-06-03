
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
            if let uri = URL(string: id) {
                if let newCourse = Course.fromURI(uri: uri, context: context) {
                    if let pos = schedule.getPosition(course: newCourse) {
                        let count = schedule.courses(for: semester).count
                        print(count)
                        let adjustment = pos.semester == semester ? -1 : 0
                        print(adjustment)
                        let newPos = CoursePosition(semester: semester, index: count + adjustment)
                        withAnimation {
                            schedule.moveCourse(newCourse, to: newPos)
                        }
                    }
                }
            }
        }
        return found
    }
}
