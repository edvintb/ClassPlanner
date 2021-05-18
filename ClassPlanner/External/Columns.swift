//
//  ColumnLayout.swift
//  ClassPlanner
//
//  Created by Edvin Berhan on 2021-05-15.
//

import SwiftUI

extension Columns where Item: Identifiable , ID == Item.ID{
    init(_ items: [Item], numberOfColumns: Int, maxNumberRows: Int = 15,
         moreView: MoreView, viewForItem: @escaping (Item) -> ItemView) {
        self.items = items
        self.id = \Item.id
        self.viewForItem = viewForItem
        self.numberOfColumns = numberOfColumns
        self.maxNumberRows = maxNumberRows
        self.moreView = moreView
    }
}

struct Columns<Item, ItemView, ID, MoreView>: View where ItemView: View, ID: Hashable, MoreView: View {
        
    var items : [Item]
    var viewForItem : (Item) -> ItemView
    var moreView: MoreView
    var id: KeyPath<Item, ID>
    var numberOfColumns: Int
    var maxNumberRows: Int
    
    init (_ items : [Item], id: KeyPath<Item, ID>, numberOfColumns: Int, maxNumberRows: Int = 15,
          moreView: MoreView, viewForItem : @escaping (Item) -> ItemView) {
        self.items = items
        self.id = id
        self.viewForItem = viewForItem
        self.numberOfColumns = numberOfColumns
        self.maxNumberRows = maxNumberRows
        self.moreView = moreView
    }
    
    @State private var startIndex: Int = 0
    
    var maxIndex: Int { numberOfColumns * maxNumberRows + startIndex }
    
    var addView: some View {
        moreView.onTapGesture {
            withAnimation {
                startIndex += numberOfColumns * maxNumberRows
            }
        }
    }
    
    var body: some View {
        HStack {
            if #available(OSX 11.0, *) {
                ForEach(0..<numberOfColumns) { columnIndex in
                    LazyVStack {
                        ForEach(0..<min(maxIndex, items.count), id: \.self){ index in
                            if index % numberOfColumns == columnIndex {
                                if index == maxIndex - 1 { addView }
                                else { viewForItem(items[index]) }
                            }
                        }
                        Spacer()
                    }
                }
            }
            else {
                ForEach(0..<numberOfColumns) { columnIndex in
                    VStack {
                        ForEach(0..<min(maxIndex, items.count), id: \.self){ index in
                            if index % numberOfColumns == columnIndex {
                                if index == maxIndex - 1 { addView }
                                else { viewForItem(items[index]) }
                            }
                        }
                        Spacer()
                    }
                }
            }
        }
    }
}

//struct ColumnLayout_Previews: PreviewProvider {
//    static var previews: some View {
//        ColumnLayout()
//    }
//}
