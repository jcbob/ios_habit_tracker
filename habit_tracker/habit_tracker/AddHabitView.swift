//
//  AddHabitView.swift
//  habit_tracker
//
//  Created by Wojciech Wolski on 11/09/2023.
//

import SwiftUI

struct AddHabitView: View {
    
    @State var habitTitle: String = ""
    @FocusState var titleFocus: Bool
    
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack{
            
            
            TextField("Add a habit...", text: $habitTitle)
                .font(.system(size: 50))
                .focused($titleFocus)
                .submitLabel(.return)
                .onSubmit {addHabit()}
                .padding()
                .padding(.top, 150)
                .onAppear{DispatchQueue.main.asyncAfter(deadline: .now() + 0.5){titleFocus = true}}
            
            Spacer()
            
            Button(action: addHabit){
                Text("Add to list")
            }
            .font(.system(size:40))
            
            Spacer()
        }
    }
    
    private func addHabit() {
        withAnimation {
            let newHabit = Habit(context: viewContext)
            newHabit.title = habitTitle
            newHabit.finishedStatus = false
            
            do {
                try viewContext.save()
                presentationMode.wrappedValue.dismiss()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
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
