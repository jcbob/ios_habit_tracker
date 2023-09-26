//
//  AddHabitView.swift
//  habit_tracker
//
//  Created by Wojciech Wolski on 11/09/2023.
//

import SwiftUI

struct AddHabitView: View {
    
    let layout = [
        GridItem(.fixed(30))
    ]
    
    @State var habitTitle: String = ""
    @State var habitDescription: String = ""
    @State var habitTimesPerDay: String = "1"
    @State var habitColor: String = "IDColor 1"
    @State var habitWeekDays: [String] = Calendar.current.weekdaySymbols
    @FocusState var titleFocus: Bool
    
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView{
            VStack(spacing: 32){
                
                // MARK: textfield to enter habit title
                TextField("Title...", text: $habitTitle)
                    .font(.title)
                    .padding(.horizontal)
                    .padding(.vertical,10)
                    .background(Color("TextFieldBackground").opacity(0.5), in: RoundedRectangle(cornerRadius: 6, style: .continuous))
                    .focused($titleFocus)
                    .onAppear{DispatchQueue.main.asyncAfter(deadline: .now() + 0.5){titleFocus = true}}
                    .disableAutocorrection(true)
                
                // MARK: textfield to enter habit description
                TextField("Description...", text: $habitDescription)
                    .padding(.horizontal)
                    .padding(.vertical,10)
                    .background(Color("TextFieldBackground").opacity(0.5), in: RoundedRectangle(cornerRadius: 6, style: .continuous))
                    .disableAutocorrection(true)
                
                // MARK: textfield to enter the number of times the habit should be completed
                HStack(alignment: .center){
                    TextField("1", text: $habitTimesPerDay)
                        .padding(7.5)
                        .background(Color("TextFieldBackground").opacity(0.5), in: RoundedRectangle(cornerRadius: 6, style: .continuous))
                        .disableAutocorrection(true)
                        .frame(maxWidth: 35)
                    
                    Text("/   Day")
                }
                
                // MARK: habit color picker
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
                                    }
                                }
                        }
                    }
                }
                
                // MARK: week day selector
                let weekDays = Calendar.current.weekdaySymbols
                HStack(spacing: 10){
                    ForEach(weekDays, id: \.self){day in
                        let index = habitWeekDays.firstIndex{value in
                            return value == day
                        } ?? -1
                        
                        Text(day.prefix(2))
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
                                    }else{
                                        habitWeekDays.append(day)
                                    }
                                }
                            }
                    }
                }
                
                Spacer()
                
                Button(action: addHabit){
                    Text("Add to list")
                }
                .padding()
                .background{
                    RoundedRectangle(cornerRadius: 15, style: .continuous)
                        .fill(Color(habitColor))
                        .shadow(color: Color(habitColor), radius: 60)
                }
                .font(.system(size:30))
                
                Spacer()
            }
            .frame(maxHeight: .infinity, alignment: .top)
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle("Add habit")
        }
        .toolbar(.hidden, for: .tabBar)
    }
    
    func addHabit() {
        withAnimation {
            let newHabit = Habit(context: viewContext)
            newHabit.status = "Incomplete"
            newHabit.title = habitTitle
            newHabit.information = habitDescription
            newHabit.timesPerDay = Int64(habitTimesPerDay)!
            newHabit.weekDays = habitWeekDays
            
            do {
                try viewContext.save()
                presentationMode.wrappedValue.dismiss()
            } catch {
                print(error)
            }
        }
    }
}

struct AddHabitView_Previews: PreviewProvider {
    static var previews: some View {
            AddHabitView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
                .preferredColorScheme(.dark)
    }
}
