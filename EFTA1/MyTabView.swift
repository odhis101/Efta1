//
//  MyTabView.swift
//  BeActive
//
//  Created by Joshua on 1/22/24.
//

import SwiftUI

struct MyTabView: View {
    @State var selectedTab = "Home"
    var body: some View {
        TabView(selection: $selectedTab){
            Dashboard()
                .tag("Home")
                .tabItem {
                    Image(systemName: "house")
                }
            Reports()
                .tag("Reports")
                .tabItem {
                    Image(systemName: "person")
                }
        }
    }
}

