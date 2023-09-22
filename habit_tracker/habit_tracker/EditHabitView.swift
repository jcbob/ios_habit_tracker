//
//  EditHabitView.swift
//  habit_tracker
//
//  Created by Wojciech Wolski on 18/09/2023.
//

import SwiftUI

struct EditHabitView: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.presentationMode) var presentationMode
    
    @FocusState var titleFocus: Bool
    
    @State var selectedHabit: Habit
    @State private var habitDescription: String = ""
    @State private var habitTitle: String = ""
    @State var timesPerDay = ""
    
    
    var body: some View {
        VStack(alignment: .leading){
            
            Text("Habit title:")
                .padding(.leading, 16)
            TextField(selectedHabit.title!, text:$habitTitle)
                .textFieldStyle(.roundedBorder)
                .padding(16)
                .submitLabel(.return)
                .onSubmit {editHabitTitle()}
                .disableAutocorrection(true)
                .padding(.bottom, 50)
            
            Text("Habit description:")
                .padding(.leading, 16)
            TextField(selectedHabit.information!, text: $habitDescription)
                .textFieldStyle(.roundedBorder)
                .padding(16)
                .submitLabel(.return)
                .onSubmit {editHabitDescription()}
                .disableAutocorrection(true)
                .padding(.bottom, 50)
            
            
            Text("Habit completions per day:")
                .padding(.leading, 16)
            HStack(alignment: .center){
                TextField("1", text: $timesPerDay)
                    .textFieldStyle(.roundedBorder)
                    .padding(.leading, 16)
                    .submitLabel(.return)
                    .onSubmit {editHabitTimesPerDay()}
                    .disableAutocorrection(true)
                    .frame(maxWidth: 55)
                
                Text("/ Day")
                    //.padding(16)
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
        selectedHabit.timesPerDay = Int64(timesPerDay)!
        do {
            try viewContext.save()
        } catch {
            print(error)
        }
    }
    /*
    func increaseTimesPerDay(){
        selectedHabit.timesPerDay += 1
        do {
            try viewContext.save()
        } catch {
            print(error)
        }
    }
    func decreaseTimesPerDay(){
        selectedHabit.timesPerDay -= 1
        do {
            try viewContext.save()
        } catch {
            print(error)
        }
    }
     */
}

/*
struct EditHabitView_Previews: PreviewProvider {
    static var previews: some View {
        EditHabitView(selectedHabit: Habit)
    }
}*/
