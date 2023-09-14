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
            Text(selectedHabit.title!)
                .font(.system(size: 50))
                .padding(.top, 150)
            
            Spacer()
            
            if (selectedHabit.status == "Incomplete"){
                Button(action: completeHabit){
                    Text("Complete Habit")
                }
            }
            
            Spacer()
        }
    }
    
    private func completeHabit(){
        withAnimation{
            selectedHabit.status = "Completed"
            
            do {
                try viewContext.save()
                presentationMode.wrappedValue.dismiss()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
    
}

/*struct HabitDetailView_Previews: PreviewProvider {
    static var previews: some View {
        HabitDetailView(selectedHabit: <#Habit#>).environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
*/
