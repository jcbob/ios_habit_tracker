//
//  AddHabitView.swift
//  habit_tracker
//
//  Created by Wojciech Wolski on 11/09/2023.
//

import SwiftUI

struct AddHabitView: View {
    
    @State var habitTitle: String = ""
    @State var habitDescription: String = ""
    @State var habitTimesPerDay: String = "1"
    @FocusState var titleFocus: Bool
    
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack{
            // textfield to enter habits title
            TextField("Add a habit...", text: $habitTitle)
                .textFieldStyle(.roundedBorder)
                .font(.system(size: 50))
                .focused($titleFocus)
                .padding()
                .padding(.top, 150)
                .onAppear{DispatchQueue.main.asyncAfter(deadline: .now() + 0.5){titleFocus = true}}
                .disableAutocorrection(true)
            
            // textfield to enter habits description
            TextField("Add habit description...", text: $habitDescription)
                .textFieldStyle(.roundedBorder)
                .padding()
                .disableAutocorrection(true)
            
            // textfield to enter the number of times the habit should be completed
            HStack(alignment: .center){
                TextField("1", text: $habitTimesPerDay)
                    .textFieldStyle(.roundedBorder)
                    .padding()
                    .disableAutocorrection(true)
                    .frame(maxWidth: 55)
                
                Text("/ Day")
            }
            
            
            Spacer()
            
            Button(action: addHabit){
                Text("Add to list")
            }
            .font(.system(size:40))
            
            Spacer()
        }
    }
    
    func addHabit() {
        withAnimation {
            let newHabit = Habit(context: viewContext)
            newHabit.title = habitTitle
            newHabit.information = habitDescription
            newHabit.timesPerDay = Int64(habitTimesPerDay)!
            newHabit.status = "Incomplete"
            
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
        NavigationView{
            AddHabitView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
        }
    }
}
