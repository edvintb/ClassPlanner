//
//  ColumnLayout.swift
//  ClassPlanner
//
//  Created by Edvin Berhan on 2021-05-15.
//

import SwiftUI

extension Columns where Item: Identifiable , ID == Item.ID{
    init(_ items: [Item], numberOfColumns: Int, maxNumberRows: Int = 15, viewForItem: @escaping (Item) -> ItemView){
        self.items = items
        self.id = \Item.id
        self.viewForItem = viewForItem
        self.numberOfColumns = numberOfColumns
        self.maxNumberRows = maxNumberRows
    }
}

struct Columns<Item, ItemView, ID>: View where ItemView: View, ID: Hashable {
        
    var items : [Item]
    var viewForItem : (Item) -> ItemView
    var id: KeyPath<Item, ID>
    var numberOfColumns: Int
    var maxNumberRows: Int
    
    init (_ items : [Item], id: KeyPath<Item, ID>, numberOfColumns: Int, maxNumberRows: Int = 15, viewForItem : @escaping (Item) -> ItemView) {
        self.items = items
        self.id = id
        self.viewForItem = viewForItem
        self.numberOfColumns = numberOfColumns
        self.maxNumberRows = maxNumberRows
    }
    
    @State private var startIndex: Int = 0
    
    var maxIndex: Int { numberOfColumns * maxNumberRows + startIndex }
    
    var showMore: some View {
        VStack {
            Spacer()
            Text("Show more")
            Spacer()
        }
        .background(Color.red)
    }

    var body: some View {
        HStack {
            if #available(OSX 11.0, *) {
                ForEach(0..<numberOfColumns) { columnIndex in
                    LazyVStack {
                        ForEach(startIndex..<min(maxIndex, items.count), id: \.self){ index in
                            if index % numberOfColumns == columnIndex {
                                if index == maxIndex - 1 { Text("More..") }
                                else { viewForItem(items[index]) }
                            }
                        }
                    }
                }
            }
            else {
                ForEach(0..<numberOfColumns) { columnIndex in
                    VStack {
                        ForEach(startIndex..<min(maxIndex, items.count), id: \.self){ index in
                            if index % numberOfColumns == columnIndex {
                                if index == maxIndex - 1 { showMore }
                                else { viewForItem(items[index]) }
                            }
                        }
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
