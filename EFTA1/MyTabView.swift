//
//  MyTabView.swift
//  BeActive
//
//  Created by Joshua on 1/22/24.
//

import SwiftUI


struct MyTabView: View {
    @State var selectedTab = "Home"
    @EnvironmentObject var config: AppConfig

    var body: some View {
        TabView(selection: $selectedTab) {
            Dashboard()
                .tag("Home")
                .tabItem {
                    Image("home 1")
                    Text("Home")
                        .foregroundColor(selectedTab == "Home" ? config.primaryColor : .primary)
                        
                    
                }
                .foregroundColor(selectedTab == "Home" ? config.primaryColor : .primary) // Highlighted tab color
            
            ContentView()
                .tag("Reports")
                .tabItem {
                    Image("Vector")
                    Text("Reports")
                        .foregroundColor(selectedTab == "Home" ? config.primaryColor : .primary) // Highlighted tab color

                }
                .foregroundColor(selectedTab == "Reports" ?  config.primaryColor  : .primary) // Highlighted tab color
        }
        .navigationBarHidden(true)
        //.accentColor(config.primaryColor) // Highlighted tab color
    }
}
