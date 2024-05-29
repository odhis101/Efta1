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
    @State private var Search:String=""
    @Environment(\.presentationMode) var presentationMode
    @State private var isLoading = false // Add isLoading state variable
    @State private var data: [CustomerData] = [] // Initialize empty array to hold data

    var body: some View {
        VStack{
            QuickIntro(title: "Customer Repossesions", description: "kindly select one of the customers you want to Reposses ", presentationMode: presentationMode)
            // make this search bar look better and more searchier
            QuestionWithSmallTextField(question: "Search",placeholder: "Search",selectedOption: $Search)

            ToggleableTextComponent(text1: "Pick-Up", text2: "Storage", isActiveFirstText: $isActiveFirstText) {
                // this will allow data to be dynamically gotten here
                isActiveFirstText.toggle()
                fetchData()

            }
            if isLoading {
                    ProgressView() // Show loading indicator if isLoading is true
                    .progressViewStyle(CircularProgressViewStyle())

                     }
                else if data.isEmpty {
                    VStack{
                            Text("No customers available")
                                .font(.headline)
                                .foregroundColor(.gray)
                                .padding()
                        
                        NavigationLink(destination: Equipment()) {
                            Text("For Scheduling Purposes Navigate to Form")
                                .font(.headline)
                                .foregroundColor(.red)
                                .padding()
                        }
                    }
                    
                }
            
            else {
                         DataListComponent(data: data, destinationType: .customerAppraisalDetails)
                             .padding()
                     }
            Spacer()
            

        }
        .onAppear {
                    // Call fetchData() when the view appears for the first time
                    fetchData()
                }
    }
    // Function to fetch data based on active text
    func fetchData() {
        isLoading = true // Set isLoading to true before starting data fetch
        NetworkManager().fetchCustomerList { result in
            switch result {
            case .success(let customers):
                // Update the data array with the fetched customer data
                DispatchQueue.main.async {
                    self.data = customers
                    isLoading = false // Set isLoading to false after data fetch completes

                }
            case .failure(let error):
                // Handle the error
                print("Error fetching customer data: \(error)")
                isLoading = false // Ensure isLoading is set to false in case of error

            }
        }
    }

}


