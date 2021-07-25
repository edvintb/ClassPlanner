//
//  ColumnLayout.swift
//  ClassPlanner
//
//  Created by Edvin Berhan on 2021-05-15.
//

import SwiftUI

extension Columns where Item: Identifiable , ID == Item.ID{
    init(_ items: [Item], startNumberOfRows: Int = 15,
         moreView: MoreView, viewForItem: @escaping (Item) -> ItemView) {
        self.items = items
        self.id = \Item.id
        self.viewForItem = viewForItem
        self.startNumberOfRows = startNumberOfRows
        self.moreView = moreView
    }
}

struct Columns<Item, ItemView, ID, MoreView>: View where ItemView: View, ID: Hashable, MoreView: View {
        
    var items : [Item]
    var viewForItem : (Item) -> ItemView
    var moreView: MoreView
    var id: KeyPath<Item, ID>
    var startNumberOfRows: Int
    let numberOfColumns = 2
    
    init (_ items : [Item], id: KeyPath<Item, ID>, startNumberOfRows: Int = 15,
          moreView: MoreView, viewForItem : @escaping (Item) -> ItemView) {
        self.items = items
        self.id = id
        self.viewForItem = viewForItem
        self.startNumberOfRows = startNumberOfRows
        self.moreView = moreView
    }
    
    @State private var numberOfAddedRows: Int = 0
    
    var addView: some View {
        moreView.onTapGesture {
            withAnimation {
                numberOfAddedRows += startNumberOfRows
            }
        }
    }
    
    var maxIndex: Int { min(((items.count + 1)/2), startNumberOfRows + numberOfAddedRows) }
    
    var body: some View {
        VStack {
            ForEach(0..<maxIndex, id: \.self) { index in
                HStack(alignment: .top) {
                    viewForItem(items[numberOfColumns*index])
                    if (index == (maxIndex - 1)) {
                        if (maxIndex < (items.count + 1)/2) {
                            addView
                        }
                        else if items.count % numberOfColumns == 1 {
                            viewForItem(items[numberOfColumns*index]).opacity(0)
                        }
                        else {
                            viewForItem(items[numberOfColumns*index + 1]).frame(alignment: .topLeading)
                        }
                    }
                    else {
                        viewForItem(items[numberOfColumns*index + 1]).frame(alignment: .topLeading)
                    }
                }
            }
        }
        .onAppear { print(maxIndex) }
    }
    
//    var body: some View {
//        HStack {
//            if #available(OSX 11.0, *) {
//                ForEach(0..<numberOfColumns) { columnIndex in
//                    VStack {
//                        ForEach(0..<min(maxIndex, items.count), id: \.self){ index in
//                            if index % numberOfColumns == columnIndex {
//                                if index == maxIndex - 1 { addView }
//                                else { viewForItem(items[index]) }
//                            }
//                        }
//                        Spacer()
//                    }
//                }
//            }
//            else {
//                ForEach(0..<numberOfColumns) { columnIndex in
//                    VStack {
//                        ForEach(0..<min(maxIndex, items.count), id: \.self){ index in
//                            if index % numberOfColumns == columnIndex {
//                                if index == maxIndex - 1 { addView }
//                                else { viewForItem(items[index]) }
//                            }
//                        }
//                        Spacer().frame(height: 50)
//                    }
//                }
//            }
//        }
//    }
}

//struct ColumnLayout_Previews: PreviewProvider {
//    static var previews: some View {
//        ColumnLayout()
//    }
//}
