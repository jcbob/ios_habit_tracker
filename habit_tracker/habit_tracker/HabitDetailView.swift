//
//  HabitDetailView.swift
//  habit_tracker
//
//  Created by Wojciech Wolski on 11/09/2023.
//

import SwiftUI

struct HabitDetailView: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    
    var selectedHabit: Habit
    
    var body: some View {
        Text(selectedHabit.title!)
            .font(.system(size: 50))
            .padding(.top, 150)
        
    }
}

/*struct HabitDetailView_Previews: PreviewProvider {
    static var previews: some View {
        HabitDetailView(selectedHabit: <#Habit#>).environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}

