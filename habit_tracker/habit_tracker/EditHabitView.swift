//
//  EditHabitView.swift
//  habit_tracker
//
//  Created by Wojciech Wolski on 18/09/2023.
//

import SwiftUI

struct EditHabitView: View {
    
    let layout = [
        GridItem(.fixed(30))
    ]
    
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.presentationMode) var presentationMode
    
    @FocusState var titleFocus: Bool
    
    @State var selectedHabit: Habit
    @State private var habitTitle: String = ""
    @State private var habitDescription: String = ""
    @State var habitTimesPerDay = ""
    @State var habitColor: String = "IDColor 1"
    @State var habitWeekDays: [String] = Calendar.current.weekdaySymbols
    
    
    var body: some View {
        VStack(alignment: .leading){
            
            // MARK: change habit title
            Text("Habit title:")
                .padding(.leading, 16)
            TextField(selectedHabit.title!, text:$habitTitle)
                .textFieldStyle(.roundedBorder)
                .padding(16)
                .submitLabel(.return)
                .onSubmit {editHabitTitle()}
                .disableAutocorrection(true)
                .padding(.bottom, 50)
            
            // MARK: change habit description
            Text("Habit description:")
                .padding(.leading, 16)
            TextField(selectedHabit.information!, text: $habitDescription)
                .textFieldStyle(.roundedBorder)
                .padding(16)
                .submitLabel(.return)
                .onSubmit {editHabitDescription()}
                .disableAutocorrection(true)
                .padding(.bottom, 50)
            
            // MARK: change habit completions per day
            Text("Habit completions per day:")
                .padding(.leading, 16)
            HStack(alignment: .center){
                TextField("1", text: $habitTimesPerDay)
                    .textFieldStyle(.roundedBorder)
                    .padding(.leading, 16)
                    .submitLabel(.return)
                    .onSubmit {editHabitTimesPerDay()}
                    .disableAutocorrection(true)
                    .frame(maxWidth: 55)
                
                Text("/ Day")
            }
            
            // MARK: change habit colour
            ScrollView(.horizontal){
                LazyHGrid(rows: layout){
                    ForEach(1..<12){index in
                        let color = "IDColor \(index)"
                        Circle()
                            .fill(Color(color))
                            .frame(width:30, height: 30)
                            .overlay(content: {
                                if(color == habitColor){
                                    Image(systemName: "checkmark")
                                        .font(.callout.bold())
                                        //.foregroundColor(Color.blue)
                                }
                            })
                            .onTapGesture {
                                withAnimation{
                                    habitColor = color
                                    editHabitColor()
                                }
                            }
                    }
                }
            }
            
            
            // MARK: change habit week day frequency
            let weekDays = Calendar.current.weekdaySymbols
            HStack(spacing: 10){
                ForEach(weekDays, id: \.self){day in
                    let index = habitWeekDays.firstIndex{value in
                        return value == day
                    } ?? -1
                    
                    Text(day.prefix(3))
                        .fontWeight(.semibold)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical)
                        .background{
                            RoundedRectangle(cornerRadius: 10, style: .continuous)
                                .fill(index != -1 ? Color(habitColor) : Color("TextFieldBackground").opacity(0.5))
                        }
                        .onTapGesture {
                            withAnimation{
                                if index != -1{
                                    habitWeekDays.remove(at: index)
                                    editHabitWeekDays()
                                }else{
                                    habitWeekDays.append(day)
                                    editHabitWeekDays()
                                }
                            }
                        }
                }
            }
            
            Spacer()
        }
    }
    func editHabitTitle(){
        selectedHabit.title = habitTitle
        do {
            try viewContext.save()
        } catch {
            print(error)
        }
    }
    
    func editHabitDescription(){
        selectedHabit.information = habitDescription
        do {
            try viewContext.save()
        } catch {
            print(error)
        }
    }
    
    func editHabitTimesPerDay(){
        selectedHabit.timesPerDay = Int64(habitTimesPerDay)!
        do {
            try viewContext.save()
        } catch {
            print(error)
        }
    }
    
    func editHabitColor(){
        selectedHabit.color = habitColor
        do {
            try viewContext.save()
        } catch {
            print(error)
        }
    }
    
    func editHabitWeekDays(){
        selectedHabit.weekDays = habitWeekDays
        do {
            try viewContext.save()
        } catch {
            print(error)
        }
    }
}

/*
struct EditHabitView_Previews: PreviewProvider {
    static var previews: some View {
        EditHabitView(selectedHabit: Habit)
    }
}*/
