//
//  SwiftUIView.swift
//  EFTA1
//
//  Created by Joshua on 4/12/24.
//

import SwiftUI

struct CustomerReposessions: View {
    @State private var searchText = ""
    @State private var isActiveFirstText = true
    @State private var data: [UserData] = [] // Initialize empty array to hold data
    @State private var Search:String=""

    var body: some View {
        VStack{
            QuickIntro(title: "Customer Repossesions", description: "kindly select one of the customers you want to Reposses ")
            // make this search bar look better and more searchier
            QuestionWithSmallTextField(question: "Search",placeholder: "Search",selectedOption: $Search)

            ToggleableTextComponent(text1: "Pick-Up", text2: "Storage", isActiveFirstText: isActiveFirstText) {
                // this will allow data to be dynamically gotten here
                isActiveFirstText.toggle()
                fetchData()

            }
            DataListComponent(data: data, destinationType: .reposessionDetails)
                            .padding()
            Spacer()
            

        }
        .onAppear {
                    // Call fetchData() when the view appears for the first time
                    fetchData()
                }
    }
    // Function to fetch data based on active text
     func fetchData() {
         // Simulate fetching data based on the active text
         if isActiveFirstText {
             data = [
                 UserData(name: "John Doe", phoneNumber: "1234567890"),
                 UserData(name: "Jane Smith", phoneNumber: "0987654321")
             ]
         } else {
             data = [
                 UserData(name: "Alice Johnson", phoneNumber: "5555555555"),
                 UserData(name: "Bob Brown", phoneNumber: "7777777777")
             ]
         }
     }
    
}


