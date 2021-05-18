
import SwiftUI

struct EmptyCourseView: View {
    
    let semester: Int
    
    @Environment(\.managedObjectContext) var context
    @EnvironmentObject var viewModel: ScheduleVM
    
    @State private var isTargeted: Bool = false
    @State private var isDropping: Bool = false
    @State private var isOverCourse: Bool = false
    
    var body: some View {
        VStack(alignment: .center, spacing: 0) {
            RoundedRectangle(cornerRadius: frameCornerRadius).stroke()
                .opacity((isOverCourse || isDropping) ? emptyHoverOpacity : 0)
                .frame(width: courseWidth, height: courseHeight)
                .contentShape(RoundedRectangle(cornerRadius: frameCornerRadius))
                .onTapGesture { viewModel.addEmptyCourse(to: semester, context: context) }
                .onHover { isTargeted = viewModel.hoverOverEmptyCourse(entered: $0, inCourse: true, semester: semester) }
                .onDrop(of: ["public.utf8-plain-text"], isTargeted: $isDropping) { drop(providers: $0) }
            RoundedRectangle(cornerRadius: frameCornerRadius).opacity(0.001)
                .frame(minWidth: courseWidth, maxWidth: courseWidth, minHeight: courseHeight, maxHeight: .infinity)
                .onHover { isTargeted = viewModel.hoverOverEmptyCourse(entered: $0, inCourse: false, semester: semester) }
        }
    }
    
    func drop(providers: [NSItemProvider]) -> Bool {
        print("Found")
        print(providers)
        let found = providers.loadFirstObject(ofType: String.self) { string in
            let newCourse = Course.withName(string as String, context: context)
            let pos = viewModel.courseCountInSemester(semester, context: context)
            withAnimation {
                if newCourse.semester == semester {
                    newCourse.moveInSemester(to: pos - 1)
                }
                else {
                    newCourse.moveToSemester(semester, and: pos)
                }
            }
        }
        return found
    }
}
