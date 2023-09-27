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
        ScrollView{
            VStack(alignment: .leading, spacing: 32){
                
                // MARK: change habit title
                VStack(alignment: .leading){
                    Text("Title:")
                        .fontWeight(.light)
                        .padding(.leading, 8)
                    TextField(selectedHabit.title!, text:$habitTitle)
                        .font(.title)
                        .fontWeight(.light)
                        .padding(.horizontal)
                        .padding(.vertical,10)
                        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 8, style: .continuous))
                        .padding([.leading, .trailing], 8)
                        .submitLabel(.return)
                        .onSubmit {editHabitTitle()}
                        .disableAutocorrection(true)
                }
                .padding(.top, 32)
                
                
                // MARK: change habit description
                VStack(alignment: .leading){
                    Text("Description:")
                        .fontWeight(.light)
                        .padding(.leading, 8)
                    TextField(selectedHabit.information!, text: $habitDescription)
                        .padding(.horizontal)
                        .padding(.vertical,10)
                        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 8, style: .continuous))
                        .padding([.leading, .trailing], 8)
                        .disableAutocorrection(true)
                        .submitLabel(.return)
                        .onSubmit {editHabitDescription()}
                }
                
                // MARK: change habit completions per day
                VStack(alignment: .leading){
                    Text("Completions per day:")
                        .fontWeight(.light)
                        .padding(.leading, 8)
                    HStack(alignment: .center){
                        Spacer()
                        TextField("1", text: $habitTimesPerDay)
                            .padding(7.5)
                            .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 8, style: .continuous))
                            .disableAutocorrection(true)
                            .frame(maxWidth: 35)
                            .submitLabel(.return)
                            .onSubmit {editHabitTimesPerDay()}
                        
                        Text("/   Day")
                        Spacer()
                    }
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
                        Text(day.prefix(2))
                            .fontWeight(.light)
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
        .background(LinearGradient(gradient: Gradient(colors: [Color(selectedHabit.color!).opacity(0.4), .black]), startPoint: .top, endPoint: .bottom))
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
