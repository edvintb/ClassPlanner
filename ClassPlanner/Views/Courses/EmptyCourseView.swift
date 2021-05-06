
import SwiftUI

struct EmptyCourseView: View {
    
    let semester: Int
    
    @Environment(\.managedObjectContext) var context
    @EnvironmentObject var viewModel: CourseVM
    
    @State private var isTargeted: Bool = false
    @State private var isOverCourse: Bool = false
    
    var body: some View {
        VStack(alignment: .center, spacing: 0) {
            RoundedRectangle(cornerRadius: frameCornerRadius).stroke()
                .opacity((isTargeted || isOverCourse) ? viewModel.insideConcentration ? 0 : emptyHoverOpacity : 0)
                .frame(width: courseWidth, height: courseHeight)
                .contentShape(RoundedRectangle(cornerRadius: frameCornerRadius))
                .onTapGesture { viewModel.addEmptyCourse(to: semester, context: context) }
                .onHover { isTargeted = viewModel.hoverOverEmptyCourse(entered: $0, inCourse: true, semester: semester) }
            RoundedRectangle(cornerRadius: frameCornerRadius).opacity(0.001)
                .frame(minWidth: courseWidth, maxWidth: courseWidth, minHeight: courseHeight, maxHeight: .infinity)
                .onHover { isTargeted = viewModel.hoverOverEmptyCourse(entered: $0, inCourse: false, semester: semester) }
        }
    }
}
