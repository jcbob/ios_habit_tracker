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
    @State var habitIcon: Int64 = 0
    @State var habitColor: String = "IDColor 1"
    @State var habitWeekDays: [String] = Calendar.current.weekdaySymbols
    
    @FocusState var titleFocus: Bool
    @State var showingSheet: Bool = false
    
    @FetchRequest(sortDescriptors: [])
    private var habitsUnsectioned: FetchedResults<Habit>
    
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView{
            ScrollView{
                VStack(spacing: 50){
                    
                    // MARK: textfield to enter habit title
                    TextField("Title...", text: $habitTitle)
                        .font(.title)
                        .fontWeight(.light)
                        .padding(.horizontal)
                        .padding(.vertical,10)
                        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 8, style: .continuous))
                        .padding([.leading, .trailing], 8)
                        .focused($titleFocus)
                        .onAppear{DispatchQueue.main.asyncAfter(deadline: .now() + 0.5){titleFocus = true}}
                        .disableAutocorrection(true)
                    
                    
                    // MARK: textfield to enter habit description
                    TextField("Description...", text: $habitDescription)
                        .padding(.horizontal)
                        .padding(.vertical,10)
                        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 8, style: .continuous))
                        .padding([.leading, .trailing], 8)
                        .disableAutocorrection(true)
                    
                    // MARK: textfield to enter the number of times the habit should be completed
                    HStack(alignment: .center){
                        TextField("1", text: $habitTimesPerDay)
                            .padding(7.5)
                            .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 8, style: .continuous))
                            .disableAutocorrection(true)
                            .frame(maxWidth: 35)
                        
                        Text("/   Day")
                            .fontWeight(.light)
                    }
                    
                    
                    // MARK: habit icon selection
                    VStack{
                        Text("Icon")
                            .fontWeight(.light)
                            .frame(maxWidth: .infinity, alignment: .center)
                            .padding(.top, -16)
                        
                        Button(action:{
                            showingSheet.toggle()
                        }, label:{
                            ZStack{
                                Text("")
                                    .frame(width: 60, height: 60)
                                    .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 8, style: .continuous))
                                Image(icons[Int(habitIcon)])
                            }
                        })
                        .sheet(isPresented: $showingSheet){
                            HabitIconView(iconIndex: $habitIcon)
                        }
                        .frame(maxWidth: .infinity, alignment: .center)
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
                        .padding(.bottom, 12)
                    }
                    
                    // MARK: week day selector
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
                                        }else{
                                            habitWeekDays.append(day)
                                        }
                                    }
                                }
                        }
                    }
                    
                    Button(action: addHabit){
                        Text("Add to list")
                            .fontWeight(.light)
                    }
                    .padding()
                    .background{
                        RoundedRectangle(cornerRadius: 15, style: .continuous)
                            .fill(Color(habitColor))
                            .shadow(color: Color(habitColor), radius: 60)
                    }
                    .font(.system(size:30))
                    .padding(.top, 25)
                    
                    Spacer()
                }
                .navigationBarTitleDisplayMode(.inline)
                .navigationTitle("Add habit")
            }
            .background(LinearGradient(gradient: Gradient(colors: [Color(habitColor).opacity(0.4), .black]), startPoint: .top, endPoint: .bottom))
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
            newHabit.icon = habitIcon
            newHabit.weekDays = habitWeekDays
            newHabit.color = habitColor
            newHabit.userOrder = (habitsUnsectioned.last?.userOrder ?? 0) + 1
            
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
