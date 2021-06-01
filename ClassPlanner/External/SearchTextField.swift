// This extension removes the focus ring entirely.
import SwiftUI

extension NSTextField {
    open override var focusRingType: NSFocusRingType {
        get { .none }
        set { }
    }
}

struct SearchTextField: View {
    @Binding var query: String
    @State var isFocused: Bool = false
    var placeholder: String = "Search..."
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 5, style: .continuous)
            .fill(Color.clear)
            .frame(width: 200, height: 22)
//                .overlay(
//                    RoundedRectangle(cornerRadius: 5, style: .continuous)
//                        .stroke(isFocused ? Color.blue.opacity(0.7) : Color.gray.opacity(0.4), lineWidth: isFocused ? 3 : 1)
//                        .frame(width: 200, height: 21)
//            )

            HStack {
                Text("􀊫")  // .resizable().aspectRatio(contentMode: .fill)
                    .frame(width:12, height: 12)
                    .padding(.leading, 5)
                    .opacity(0.8)
                TextField(placeholder, text: $query)
//                onEditingChanged: { (editingChanged) in
//                    if editingChanged {
//                        self.isFocused = true
//                    } else {
//                        self.isFocused = false
//                    }
//                })
                    .textFieldStyle(PlainTextFieldStyle())
                if query != "" {
                    Button(action: {
                            self.query = ""
                    }) {
                        Text("􀁠")
//                            .resizable()
//                            .aspectRatio(contentMode: .fit)
                            .frame(width:14, height: 14)
                            .padding(.trailing, 3)
                            .opacity(0.5)
                    }
                    .buttonStyle(PlainButtonStyle())
//                    .opacity(self.query == "" ? 0 : 0.5)
                    .opacity(0.5)
                }
            }

        }
    }
}