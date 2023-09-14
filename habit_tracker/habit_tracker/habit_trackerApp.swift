//
//  habit_trackerApp.swift
//  habit_tracker
//
//  Created by Wojciech Wolski on 11/09/2023.
//

import SwiftUI

@main
struct habit_trackerApp: App {
    let persistenceController = PersistenceController.shared
    
    var body: some Scene {
        WindowGroup {
            HabitListView(currentHour: Date.now)
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
