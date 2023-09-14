//
//  HabitListView.swift
//  habit_tracker
//
//  Created by Wojciech Wolski on 11/09/2023.
//

import SwiftUI
import CoreData

struct HabitListView: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \Habit.title, ascending: true)], animation: .default)
    private var habitsUnsectioned: FetchedResults<Habit>
    
    @SectionedFetchRequest<String?, Habit>(sectionIdentifier: \Habit.status, sortDescriptors: [SortDescriptor(\Habit.status, order: .reverse), SortDescriptor(\Habit.title)], animation: .default)
    private var habits: SectionedFetchResults<String?, Habit>
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    @State var currentHour: Date
    @State var displayHour: String = ""
    
    var body: some View {
        VStack{
            NavigationView{
                List{
                    ForEach(habits){ section in
                        Section(header: Text(section.id!)){
                            ForEach(section){ listedHabit in
                                NavigationLink(destination: HabitDetailView(selectedHabit: listedHabit)){
                                    Text(listedHabit.title!)
                                        .lineLimit(1)
                                        .onReceive(timer){_ in
                                            currentHour = Date()
                                            if(dateFormatter.string(from: currentHour) == "00:43"){
                                                resetHabit(habit: listedHabit)
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
                                                    resetHabit(habit: listedHabit)
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
                    //.onDelete(perform: deleteHabit)
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
            
            Text("It is \(dateFormatter.string(from: currentHour))")
                .onReceive(timer){_ in
                    currentHour = Date.now
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
        habit.status = "Completed"
        do{
            try viewContext.save()
        } catch{
            print(error)
        }
    }
    
    private func resetHabit(habit: Habit){
        withAnimation{
            habit.status = "Incomplete"
            do{
                try viewContext.save()
            } catch{
                print(error)
            }
        }
    }
    
    /*private func deleteHabit(offsets: IndexSet) {
     withAnimation {
     offsets.map { habits[$0] }.forEach(viewContext.delete)
     try? viewContext.save()
     }
     }*/
}

private let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "HH:mm"
    return formatter
}()

struct HabitListView_Previews: PreviewProvider {
    static var previews: some View {
        HabitListView(currentHour: Date.now)
    }
}
