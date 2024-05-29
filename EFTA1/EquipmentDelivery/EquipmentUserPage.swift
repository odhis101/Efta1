//
//  EquipmentUserPage.swift
//  EFTA1
//
//  Created by Joshua on 4/15/24.
//

import SwiftUI

struct EquipmentUserPage: View {
    @State private var searchText = ""
    @State private var isActiveFirstText = true
    @State private var Search:String=""

    @State private var isLoading = false // Add isLoading state variable
    @State private var data: [CustomerData] = [] // Initialize empty array to hold data
    
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        VStack{
            QuickIntro(title: "Equipment Delivery", description: "Kindly select one of the customers to make equipment delivery", presentationMode: presentationMode)
            
            QuestionWithSmallTextField(question: "Search",placeholder: "Search",selectedOption: $Search)

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
