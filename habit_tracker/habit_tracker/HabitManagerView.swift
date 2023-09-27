//
//  HabitManagerFile.swift
//  habit_tracker
//
//  Created by Wojciech Wolski on 26/09/2023.
//

import SwiftUI

struct HabitManagerView: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \Habit.title, ascending: true)], animation: .default)
    private var habitsUnsectioned: FetchedResults<Habit>
    
    var body: some View {
        NavigationStack{
            HStack{
                List{
                    ForEach(habitsUnsectioned){listedHabit in
                        HStack(alignment: .center){
                            // habit icon
                            Text("ICON")
                            
                            VStack(alignment: .leading){
                                // habit title
                                Text(listedHabit.title!)
                                    .font(.headline)
                                    .lineLimit(2)
                                
                                // habit description
                                if(!listedHabit.information!.isEmpty){
                                    Text(listedHabit.information!)
                                        .multilineTextAlignment(.leading)
                                        .font(.footnote)
                                        .foregroundColor(.secondary)
                                        .lineLimit(1)
                                }
                            }
                        }
                        .listRowBackground(Color(listedHabit.color!))
                        .swipeActions(edge: .trailing, content: {
                            Button(role: .destructive, action: {deleteHabit(habit: listedHabit)
                            }, label: {
                                Image(systemName: "trash")
                            })
                        })
                    }
                    .frame(minHeight: 30, maxHeight: 30)
                }
                .listStyle(.grouped)
                
                List{
                    ForEach(habitsUnsectioned){listedHabit in
                        
                        ZStack{
                            Image(systemName: "gearshape.fill")
                                .font(.system(size: 25))
                            
                            NavigationLink(destination: EditHabitView(selectedHabit: listedHabit, habitColor: listedHabit.color ?? "IDColor 1", habitWeekDays: listedHabit.weekDays ?? Calendar.current.weekdaySymbols)){
                                EmptyView()
                            }
                            .buttonStyle(PlainButtonStyle())
                            .opacity(0)
                        }
                    }
                    .frame(minWidth: 20, maxWidth: 20, minHeight: 30, maxHeight: 30)
                }
                .listStyle(.grouped)
                .frame(maxWidth: 50)
                .background(Color("TextFieldBackground").opacity(0.5), in: RoundedRectangle(cornerRadius: 6, style: .continuous))
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle("Habit Manager")
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
}

struct HabitManagerView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack{
            HabitManagerView()
                .preferredColorScheme(.dark)
        }
    }
}
