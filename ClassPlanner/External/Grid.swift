//
//  Grid.swift
//  Memorize
//
//  Created by Edvin Berhan on 2021-01-16.
//  Copyright © 2021 Tewolde Technology. All rights reserved.
//

import SwiftUI

extension Grid where Item: Identifiable , ID == Item.ID{
    init(_ items: [Item], viewForItem: @escaping (Item) -> ItemView){
        self.items = items
        self.id = \Item.id
        self.viewForItem = viewForItem
    }
}


struct Grid<Item, ItemView, ID> : View where ItemView : View, ID: Hashable {
    
    var items : [Item]
    var viewForItem : (Item) -> ItemView
    var id: KeyPath<Item, ID>
    
    
    init (_ items : [Item], id: KeyPath<Item, ID>, viewForItem : @escaping (Item) -> ItemView) {
        self.items = items
        self.id = id
        self.viewForItem = viewForItem
    }
    
    
    var body: some View {
        GeometryReader {geometry in
            self.body(for: GridLayout(itemCount: items.count, in: geometry.size))
        }
    }
    
    func body (for layout: GridLayout) -> some View {
        ForEach(items, id: id) {item in
            self.body(for: layout, item: item)
        }
    }
    
    func body (for layout: GridLayout, item: Item) -> some View {
        let index = items.firstIndex(where: { item[keyPath: id] == $0[keyPath: id] })
        return
            Group {
                if index != nil {
                    viewForItem(item)
                    .frame(width: layout.itemSize.width, height: layout.itemSize.height)
                    .position(layout.location(ofItemAt: index!))
                }
            }

        
        
    }
}



