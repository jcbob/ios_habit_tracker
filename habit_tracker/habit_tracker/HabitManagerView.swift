//
//  HabitManagerFile.swift
//  habit_tracker
//
//  Created by Wojciech Wolski on 26/09/2023.
//

import SwiftUI

struct HabitManagerView: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \Habit.userOrder, ascending: true)], animation: .default)
    private var habitsUnsectioned: FetchedResults<Habit>
    
    var body: some View {
        NavigationStack{
            HStack{
                List{
                    ForEach(habitsUnsectioned){listedHabit in
                        HStack(alignment: .center){
                            // habit icon
                            Image(icons[Int(listedHabit.icon)])
                                .padding(.trailing, 8)
                                .padding(.leading, -6)
                                .padding([.top, .bottom])
                            
                            VStack(alignment: .leading){
                                // habit title
                                Text(listedHabit.title!)
                                    .font(.title3)
                                    .fontWeight(.light)
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
                    .onDelete(perform: deleteItems)
                    .onMove(perform: moveHabit)
                    .frame(minHeight: 40, maxHeight: 40)
                }
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        EditButton()
                    }
                }
                .listStyle(.grouped)

                
                List{
                    ForEach(habitsUnsectioned){listedHabit in
                        
                        ZStack{
                            Image(systemName: "gearshape.fill")
                                .font(.system(size: 25))
                            
                            NavigationLink(destination: EditHabitView(selectedHabit: listedHabit, habitIcon: listedHabit.icon, habitColor: listedHabit.color!, habitWeekDays: listedHabit.weekDays ?? Calendar.current.weekdaySymbols)){
                                EmptyView()
                            }
                            .buttonStyle(PlainButtonStyle())
                            .opacity(0)
                        }
                    }
                    .frame(minWidth: 40, maxWidth: 40, minHeight: 40, maxHeight: 40)
                }
                .listStyle(.grouped)
                .frame(maxWidth: 50)
                .background(Color("TextFieldBackground").opacity(0.5), in: RoundedRectangle(cornerRadius: 6, style: .continuous))
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle("Habit Manager")
        }
    }

    private func moveHabit(at sets: IndexSet, destination: Int){
        let habitToMove = sets.first!
        
        if habitToMove < destination{
            var startIndex = habitToMove + 1
            let endIndex = destination - 1
            var startOrder = habitsUnsectioned[habitToMove].userOrder
            
            while startIndex <= endIndex{
                habitsUnsectioned[startIndex].userOrder = startOrder
                startOrder = startOrder + 1
                startIndex = startIndex + 1
            }
            habitsUnsectioned[habitToMove].userOrder = startOrder
        }
        else if destination < habitToMove{
            var startIndex = destination
            let endIndex = habitToMove - 1
            var startOrder = habitsUnsectioned[destination].userOrder + 1
            let newOrder = habitsUnsectioned[destination].userOrder
            
            while startIndex <= endIndex{
                habitsUnsectioned[startIndex].userOrder = startOrder
                startOrder = startOrder + 1
                startIndex = startIndex + 1
            }
            
            habitsUnsectioned[habitToMove].userOrder = newOrder
        }
        do{
            try viewContext.save()
        } catch{
            print(error)
        }
        
    }
    
    public func deleteHabit(habit: Habit){
        var i = habitsUnsectioned.firstIndex(where: {$0 == habit})!
        viewContext.delete(habit)
        while i <= habitsUnsectioned.count - 1{
            habitsUnsectioned[i].userOrder = habitsUnsectioned[i].userOrder - 1
            i = i + 1
        }
        
        do{
            try viewContext.save()
        } catch{
            print(error)
        }
    }
    
    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { habitsUnsectioned[$0] }.forEach(viewContext.delete)

            do {
                try viewContext.save()
            } catch {
                print(error)
            }
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
