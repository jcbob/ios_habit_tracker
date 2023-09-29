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
    
    @ViewBuilder
    var body: some View {
        VStack(spacing: 32){
            
            Spacer()
            
            // MARK: show the habits title
            Text(selectedHabit.title!)
                .font(.title)
                .fontWeight(.light)
                .padding(.horizontal)
                .padding(.vertical,10)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 0, style: .continuous))
            
            // MARK: show the habits description
            if(!selectedHabit.information!.isEmpty){
                Text(selectedHabit.information!)
                    .foregroundColor(.secondary)
                    .padding(.horizontal)
                    .padding(.vertical,10)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 0, style: .continuous))
            }
            
            // MARK: show the habits total completion count
            Text("Completed this habit a total of \(selectedHabit.completedCountTotal) times")
                .fontWeight(.light)
                .padding(.horizontal)
                .padding(.vertical,10)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color("TextFieldBackground").opacity(0.5), in: RoundedRectangle(cornerRadius: 0, style: .continuous))
            
            
            //MARK: show habit icon
            ZStack{
                Text("")
                    .frame(width: 60, height: 60)
                    .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 8, style: .continuous))
                
                Image(icons[Int(selectedHabit.icon)])
                    .frame(maxWidth: .infinity, alignment: .center)
            }
            .padding(.bottom, -62)
            
            //MARK: show on which days the habit is active
            let weekDays = Calendar.current.weekdaySymbols
            VStack(alignment: .leading){
                Text("Active days:")
                    .fontWeight(.light)
                    .padding(.leading, 8)
                HStack(spacing: 10){
                    ForEach(weekDays, id: \.self){day in
                        Text(day.prefix(2))
                            .fontWeight(.light)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical)
                            .background{
                                RoundedRectangle(cornerRadius: 10, style: .continuous)
                                    .fill(selectedHabit.weekDays!.contains(day) ? Color(selectedHabit.color ?? "IDColor 1") : Color("TextFieldBackground"))
                            }
                    }
                }
            }
            .padding(.top, 50)
            
            
            Spacer()
            
            // MARK: show the number of times the habit has been completed / number of times the habit should be completed
            Text("\(selectedHabit.timesCompletedToday) / \(selectedHabit.timesPerDay)")
                .padding(7.5)
                .font(.largeTitle)
                .background(Color(.black).opacity(0.5), in: RoundedRectangle(cornerRadius: 6, style: .continuous))
                .disableAutocorrection(true)
            
            // MARK: show a button to complete/reset a habit
            if (selectedHabit.status == "Incomplete"){
                Button(action: completeHabit){
                    Image(systemName: "checkmark.circle.fill")
                    Text("Complete Habit")
                }
                .padding()
                .background{
                    RoundedRectangle(cornerRadius: 15, style: .continuous)
                        .fill(Color(selectedHabit.color!))
                }
                .font(.system(size:25))
            } else{
                Button(action: resetHabit){
                    Image(systemName: "gobackward")
                    Text("Reset Habit")
                }
                .padding()
                .background{
                    RoundedRectangle(cornerRadius: 15, style: .continuous)
                        .fill(Color(selectedHabit.color!))
                }
                .font(.system(size:25))
            }
            
            Spacer()
        }
        .background(LinearGradient(gradient: Gradient(colors: [Color(selectedHabit.color!).opacity(0.4), .black]), startPoint: .top, endPoint: .bottom))
        .toolbar{
            ToolbarItem{
                NavigationLink(destination: EditHabitView(selectedHabit: selectedHabit, habitIcon: selectedHabit.icon, habitColor: selectedHabit.color!, habitWeekDays: selectedHabit.weekDays ?? Calendar.current.weekdaySymbols)){
                    Label("Edit habit", systemImage: "gearshape.fill")
                        .accentColor(Color(selectedHabit.color!))
                }
            }
        }
        .toolbar(.hidden, for: .tabBar)
    }
    
    // MARK: function to complete the selected habit
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
