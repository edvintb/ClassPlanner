import Foundation
import SwiftUI

class TapState {

    static var taps: [String: Date] = [:]

    static func isDoubleTap(on course: Course) -> Bool {
        let key = course.stringID
        let date = taps[key]
        taps[key] = Date()
        if let date = date, date.timeIntervalSince1970 >= Date().timeIntervalSince1970 - 0.25 {
            return true
        } else {
            return false
        }
    }
}

extension View {

    public func onTapGesture(course: Course, firstTap: @escaping () -> Void, secondTap: @escaping () -> Void) -> some View {
        onTapGesture(count: 1) {
            if TapState.isDoubleTap(on: course) {
                secondTap()
            } else {
                firstTap()
            }
        }
    }
}



//
//struct TapRecognizerViewModifier: ViewModifier {
//
//    @State private var singleTapIsTaped: Bool = Bool()
//
//    var tapSensitivity: Double
//    var singleTapAction: () -> Void
//    var doubleTapAction: () -> Void
//
//    init(tapSensitivity: Double, singleTapAction: @escaping () -> Void, doubleTapAction: @escaping () -> Void) {
//        self.tapSensitivity = tapSensitivity
//        self.singleTapAction = singleTapAction
//        self.doubleTapAction = doubleTapAction
//    }
//
//    func body(content: Content) -> some View {
//
//        return content
//            .gesture(simultaneouslyGesture)
//
//    }
//
//    private var singleTapGesture: some Gesture { TapGesture(count: 1).onEnded{
//
//        singleTapIsTaped = true
//
//        DispatchQueue.main.asyncAfter(deadline: .now() + tapSensitivity) { if singleTapIsTaped { singleTapAction() } }
//
//    } }
//
//    private var doubleTapGesture: some Gesture { TapGesture(count: 2).onEnded{ singleTapIsTaped = false; doubleTapAction() } }
//
//    private var simultaneouslyGesture: some Gesture { singleTapGesture.simultaneously(with: doubleTapGesture) }
//
//}
//
//
//extension View {
//
//    func tapRecognizer(tapSensitivity: Double, singleTapAction: @escaping () -> Void, doubleTapAction: @escaping () -> Void) -> some View {
//
//        return self.modifier(TapRecognizerViewModifier(tapSensitivity: tapSensitivity, singleTapAction: singleTapAction, doubleTapAction: doubleTapAction))
//
//    }
//
//}
