//
//  HabitListView.swift
//  habit_tracker
//
//  Created by Wojciech Wolski on 11/09/2023.
//

import SwiftUI

struct HabitListView: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \Habit.title, ascending: true)], animation: .default)
    private var habits: FetchedResults<Habit>
    
    var body: some View {
        NavigationView{
            List{
                ForEach(habits){ listedHabit in
                    NavigationLink(destination: HabitDetailView(selectedHabit: listedHabit)){
                        Text(listedHabit.title!)
                            .lineLimit(1)
                    }
                }
                .onDelete(perform: deleteHabit)
            }
            .navigationTitle("Habit Tracker")
            .toolbar{
                ToolbarItem{
                    NavigationLink(destination: AddHabitView()){
                        Label("Add Habit", systemImage: "plus")
                    }
                }
            }
        }
    }
    
    private func deleteHabit(offsets: IndexSet) {
        withAnimation {
            offsets.map { habits[$0] }.forEach(viewContext.delete)
            try? viewContext.save()
        }
    }
}

struct HabitListView_Previews: PreviewProvider {
    static var previews: some View {
        HabitListView()
    }
}
