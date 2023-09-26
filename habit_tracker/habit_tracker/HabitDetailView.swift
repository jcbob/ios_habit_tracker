//
//  HabitDetailView.swift
//  habit_tracker
//
//  Created by Wojciech Wolski on 11/09/2023.
//

import SwiftUI

struct HabitDetailView: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.presentationMode) var presentationMode
    
    var selectedHabit: Habit
    
    var body: some View {
        VStack{
            // MARK: show the habits title
            Text(selectedHabit.title!)
                .font(.system(size: 50))
                .padding(.top, 150)
            
            Spacer()
            
            // MARK: show the habits description
            Text(selectedHabit.information!)
                .foregroundColor(.secondary)
                .background(.secondary)
                .padding(.bottom, 16)
            
            // MARK: show the number of times the habit has been completed / number of times the habit should be completed
            Text("\(selectedHabit.timesCompletedToday) / \(selectedHabit.timesPerDay)")
                .padding(.bottom, 16)
            
            // MARK: show the habits total completion count
            Text("Completed this habit a total of \(selectedHabit.completedCountTotal) times")
            
            //MARK: show on which days the habit is active
            
            
            
            Spacer()
            
            // MARK: show a button to complete/reset a habit
            if (selectedHabit.status == "Incomplete"){
                Button(action: completeHabit){
                    Text("Complete Habit")
                }
            } else{
                Button(action: resetHabit){
                    Text("Reset Habit")
                }
            }
            
            Spacer()
        }
        .toolbar{
            ToolbarItem{
                NavigationLink(destination: EditHabitView(selectedHabit: selectedHabit, habitColor: selectedHabit.color ?? "IDColor 1", habitWeekDays: selectedHabit.weekDays ?? Calendar.current.weekdaySymbols)){
                    Label("Edit habit", systemImage: "gearshape.fill")
                }
            }
        }
        .toolbar(.hidden, for: .tabBar)
    }
    
    // function to complete the selected habit
    private func completeHabit(){
        withAnimation{
            selectedHabit.completedCountTotal += 1
            selectedHabit.timesCompletedToday += 1
            if(selectedHabit.timesCompletedToday == selectedHabit.timesPerDay){
                selectedHabit.status = "Complete"
            }
            
            do {
                try viewContext.save()
                presentationMode.wrappedValue.dismiss()
            } catch {
                print(error)
            }
        }
    }
    
    // function to reset the selected habit
    func resetHabit(){
        selectedHabit.completedCountTotal -= selectedHabit.timesPerDay
        selectedHabit.timesCompletedToday = 0
        selectedHabit.status = "Incomplete"
        
        do {
            try viewContext.save()
            presentationMode.wrappedValue.dismiss()
        } catch {
            print(error)
        }
    }
    
}

/*struct HabitDetailView_Previews: PreviewProvider {
    static var previews: some View {
        HabitDetailView(selectedHabit: <#Habit#>).environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
*/
