//
//  MainView.swift
//  habit_tracker
//
//  Created by Wojciech Wolski on 26/09/2023.
//

import SwiftUI

struct MainView: View {
    var body: some View {
        TabView{
            HabitListView()
                .tabItem{
                    Image(systemName: "house.fill")
                }
            
            HabitManagerView()
                .tabItem{
                    Image(systemName: "slider.horizontal.3")
                }
            
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
