//
//  HabitListView.swift
//  habit_tracker
//
//  Created by Wojciech Wolski on 11/09/2023.
//

import SwiftUI
import CoreData

private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .medium
    return formatter
}()

struct HabitListView: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \Habit.title, ascending: true)], animation: .default)
    private var habitsUnsectioned: FetchedResults<Habit>
    
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \DateReference.date, ascending: true)], animation: .default)
    private var dateReferences: FetchedResults<DateReference>
    
    @SectionedFetchRequest<String?, Habit>(sectionIdentifier: \Habit.status, sortDescriptors: [SortDescriptor(\Habit.status, order: .reverse), SortDescriptor(\Habit.title)], animation: .default)
    private var habits: SectionedFetchResults<String?, Habit>
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    let calendar = Calendar.current
    
    var body: some View {
        NavigationStack{
            List{
                ForEach(habits){ section in
                    Section(header: Text(section.id!)){
                        ForEach(section){ listedHabit in
                            ZStack{
                                HStack{
                                    // habit icon
                                    Text("ICON")
                                    
                                    VStack(alignment: .leading){
                                        // habit title
                                        Text(listedHabit.title!)
                                            .lineLimit(1)
                                            .onReceive(timer){_ in
                                                createDateReference()
                                                if(newDayReset()){
                                                    resetAllHabits()
                                                    dateReferences[0].date = Date.now
                                                    do{
                                                        try viewContext.save()
                                                    } catch{
                                                        print(error)
                                                    }
                                                }
                                            }
                                            .swipeActions(edge: .leading, content: {
                                                if(listedHabit.status == "Incomplete"){
                                                    Button(action: {completeHabit(habit: listedHabit)
                                                    }, label: {
                                                        Image(systemName: "checkmark.circle.fill")
                                                    })
                                                    .tint(.mint)
                                                }
                                                else{
                                                    Button(action: {resetSelectedHabit(habit: listedHabit)
                                                    }, label: {
                                                        Image(systemName: "x.circle.fill")
                                                    })
                                                    .tint(.indigo)
                                                }
                                            })
                                            .swipeActions(edge: .trailing, content: {
                                                Button(role: .destructive, action: {deleteHabit(habit: listedHabit)
                                                }, label: {
                                                    Image(systemName: "trash")
                                                })
                                            })
                                        
                                        // habit description
                                        Text(listedHabit.information!)
                                            .multilineTextAlignment(.leading)
                                            .font(.footnote)
                                            .foregroundColor(.secondary)
                                            .lineLimit(1)
                                    }
                                    
                                    Spacer()
                                    
                                    // habit timesPerDay count
                                    Text("\(listedHabit.timesCompletedToday) / \(listedHabit.timesPerDay)")
                                }
                                
                                NavigationLink(destination: HabitDetailView(selectedHabit: listedHabit)){
                                    EmptyView()
                                    
                                }
                                .buttonStyle(PlainButtonStyle())
                                .opacity(0)
                            }
                        }
                        .frame(minHeight: 50, maxHeight: 50)
                    }
                }
            }
            .listStyle(.insetGrouped)
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
        withAnimation{
            habit.completedCountTotal += 1
            habit.timesCompletedToday += 1
            if(habit.timesCompletedToday >= habit.timesPerDay){
                habit.status = "Complete"
                habit.timesCompletedToday = habit.timesPerDay
            }
            do{
                try viewContext.save()
            } catch{
                print(error)
            }
        }
    }
    
    private func resetSelectedHabit(habit: Habit){
        withAnimation{
            habit.completedCountTotal -= habit.timesPerDay
            habit.timesCompletedToday = 0
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
                habit.completedCountTotal -= habit.timesPerDay
                habit.timesCompletedToday = 0
                habit.status = "Incomplete"
            }
            try viewContext.save()
        } catch{
            print(error)
        }
    }
    
    func newDayReset() -> Bool{
        let dateCurrent = Date()
        
        let dateCurrentComponents = calendar.dateComponents([.day], from: dateCurrent)
        let dateReferenceComponents = calendar.dateComponents([.day], from: dateReferences[0].date!)
        
        let dateCurrentDay = dateCurrentComponents.day
        let dateReferenceDay = dateReferenceComponents.day
        
        
        if(dateCurrentDay != dateReferenceDay){
            return true
        }else {
            return false
        }
    }
    
    func createDateReference(){
        if(dateReferences.isEmpty){
            let newDateReference = DateReference(context: viewContext)
            newDateReference.date = Date.now
            
            do{
                try viewContext.save()
            } catch{
                print(error)
            }
        }
    }
}

struct HabitListView_Previews: PreviewProvider {
    static var previews: some View {
        HabitListView()
    }
}
