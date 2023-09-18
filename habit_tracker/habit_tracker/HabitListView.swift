//
//  HabitListView.swift
//  habit_tracker
//
//  Created by Wojciech Wolski on 11/09/2023.
//

import SwiftUI
import CoreData


private let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "HH:mm:ss"
    return formatter
}()



struct HabitListView: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \Habit.title, ascending: true)], animation: .default)
    private var habitsUnsectioned: FetchedResults<Habit>
    
    @SectionedFetchRequest<String?, Habit>(sectionIdentifier: \Habit.status, sortDescriptors: [SortDescriptor(\Habit.status, order: .reverse), SortDescriptor(\Habit.title)], animation: .default)
    private var habits: SectionedFetchResults<String?, Habit>
    
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    let calendar = Calendar.current
    @State var dateReference = Date()
    @State var resetCounter = 0
    
    @State var habitList: [Habit] = []
    
    
    var body: some View {
        NavigationView{
            List{
                ForEach(habits){ section in
                    Section(header: section.id!){
                        ForEach(section){ listedHabit in
                            NavigationLink(destination: HabitDetailView(selectedHabit: listedHabit)){
                                Text(listedHabit.title!)
                                    .lineLimit(1)
                                    .onReceive(timer){_ in
                                        if(newDayReset()){
                                            resetAllHabits()
                                            dateReference = Date.now
                                        }
                                    }
                                    .swipeActions(edge: .leading, content: {
                                        if(listedHabit.status == "Incomplete"){
                                            Button(action: {
                                                completeHabit(habit: listedHabit)
                                            }, label: {
                                                Image(systemName: "checkmark.circle.fill")
                                            })
                                            .tint(.mint)
                                        }
                                        else{
                                            Button(action: {
                                                resetSelectedHabit(habit: listedHabit)
                                            }, label: {
                                                Image(systemName: "x.circle.fill")
                                            })
                                            .tint(.indigo)
                                        }
                                    })
                                    .swipeActions(edge: .trailing, content: {
                                        Button(role: .destructive, action: {
                                            deleteHabit(habit: listedHabit)
                                        }, label: {
                                            Image(systemName: "trash")
                                        })
                                    })
                            }
                        }
                    }
                }
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
    
    public func deleteHabit(habit: Habit){
        viewContext.delete(habit)
        do{
            try viewContext.save()
        } catch{
            print(error)
        }
    }
    
    private func completeHabit(habit: Habit){
        habit.status = "Complete"
        do{
            try viewContext.save()
        } catch{
            print(error)
        }
    }
    
    private func resetSelectedHabit(habit: Habit){
        withAnimation{
            habit.status = "Incomplete"
            do{
                try viewContext.save()
            } catch{
                print(error)
            }
        }
    }
    
    private func resetAllHabits(){
        let fetchRequest: NSFetchRequest<Habit> = Habit.fetchRequest()
        do{
            let habits = try viewContext.fetch(fetchRequest)
            
            for habit in habits{
                habit.status = "Incomplete"
            }
            try viewContext.save()
        } catch{
            print(error)
        }
    }
    
    private func newDayReset() -> Bool{
        let dateCurrent = Date()

        let dateCurrentComponents = calendar.dateComponents([.minute], from: dateCurrent)
        let dateReferenceComponents = calendar.dateComponents([.minute], from: dateReference)

        let dateCurrentDay = dateCurrentComponents.minute
        let dateReferenceDay = dateReferenceComponents.minute


        if(dateCurrentDay != dateReferenceDay){
            return true
        }else {
            return false
        }
    }
}

struct HabitListView_Previews: PreviewProvider {
    static var previews: some View {
        HabitListView()
    }
}
