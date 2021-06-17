//
//  CategoryContainer.swift
//  ClassPlanner
//
//  Created by Edvin Berhan on 2021-06-06.
//

import SwiftUI


struct CategoryContainer: View {

    @ObservedObject var concentration: Concentration
    @ObservedObject var schedule: ScheduleVM

    private var categories: [Category] {
        concentration.categories.sorted(by: {$0.index < $1.index })
    }
    
    var body: some View {
        let stableCategories = categories
        return
            HStack {
                ForEach(stableCategories) { category in
                    CategoryView(category: category, schedule: schedule)
                }
                EmptyCategoryView(concentration: concentration)
            }
            .padding(.horizontal, 5)
    }

}
