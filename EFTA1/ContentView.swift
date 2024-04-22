//
//  ContentView.swift
//  EFTA1
//
//  Created by Joshua on 3/28/24.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
      
        // create a button to navigate to the SecurityQuestions view
        NavigationLink(destination: OnBoard()) {
            Text("Log Out")
                .padding()
                .background(Color.red)
                .foregroundColor(.white)
                .cornerRadius(10)
        }
        
        .onAppear(){
            AuthManager.shared.deleteToken()
        
        }
        
           
    }
      
}



