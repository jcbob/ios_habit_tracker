//
//  HabitIconSelectionView.swift
//  habit_tracker
//
//  Created by Wojciech Wolski on 27/09/2023.
//

import SwiftUI

struct HabitIconView: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.presentationMode) var presentationMode
    
    let layout = [
        GridItem(.adaptive(minimum: 70))
    ]
    
    @Binding var iconIndex: Int64
    
    var body: some View {
        VStack{
            Text("")
                .padding(.top, 22)
            ScrollView(.horizontal){
                LazyHGrid(rows: layout){
                    ForEach(0..<icons.count, id: \.self){listedIcon in
                        
                        Button(action:{
                            iconIndex = Int64(listedIcon)
                            do {
                                try viewContext.save()
                            } catch {
                                print(error)
                            }
                            presentationMode.wrappedValue.dismiss()
                        }, label: {
                            Image(icons[listedIcon])
                                .resizable()
                                .scaledToFit()
                                .frame(width: 100, height: 50)
                        })
                    }
                }
            }
            Spacer()
        }
    }
}

//struct HabitIconView_Previews: PreviewProvider {
//    static var previews: some View {
//        HabitIconSelectionView()
//            .preferredColorScheme(.dark)
//    }
//}
