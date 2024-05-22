//
//  CustomerMonitoring.swift
//  EFTA1
//
//  Created by Joshua on 4/10/24.
//

import SwiftUI

struct CustomerMonitoringSearch: View {
    @State private var searchText = ""
    @State private var isActiveFirstText = true
    @State private var data: [UserData] = [] // Initialize empty array to hold data
    @State private var Search:String=""


    var body: some View {
        VStack{
            QuickIntro(title: "Customer Monitoring", description: "kindly select one of the customers you want to appraise")
            
            // make this search bar look better and more searchier
            QuestionWithSmallTextField(question: "Search",placeholder: "Search",selectedOption: $Search)
    
            ToggleableTextComponent(text1: "Text 1", text2: "Text 2", isActiveFirstText: isActiveFirstText) {
                // this will allow data to be dynamically gotten here
                isActiveFirstText.toggle()
                fetchData()

            }
            DataListComponent(data: data, destinationType: .customerDetails)
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

struct CustomerMonitoringSearch_Previews: PreviewProvider {
    static var previews: some View {
        CustomerMonitoringSearch()
            .environmentObject(AppConfig(region: .efken))
            .environmentObject(PinHandler())
    }
}
