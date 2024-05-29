//
//  CustomerApraisalsSearch.swift
//  EFTA1
//
//  Created by Joshua on 4/9/24.
//

import SwiftUI


struct CustomerApraisalsSearch: View {
    @State private var search = ""
    @State private var isActiveFirstText = true
    @State private var data: [CustomerData] = [] // Initialize empty array to hold data
    @Environment(\.presentationMode) var presentationMode
    
    @State private var isLoading = false // Add isLoading state variable

    var body: some View {
        VStack {
            QuickIntro(title: "Customer Appraisals", description: "Kindly select one of the customers you want to appraise", presentationMode: presentationMode)
            QuestionWithSmallTextField(question: "", placeholder: "Search", selectedOption: $search)
            
            ToggleableTextComponent(text1: "Upcoming schedules", text2: "All Customers", isActiveFirstText: $isActiveFirstText) {
                // This will allow data to be dynamically gotten here
                isActiveFirstText.toggle()
                fetchData()
            }
            
            if isLoading {
                ProgressView() // Show loading indicator if isLoading is true
                    .progressViewStyle(CircularProgressViewStyle())
            } else if data.isEmpty {
                VStack {
                    Text("No customers available")
                        .font(.headline)
                        .foregroundColor(.gray)
                        .padding()
                    
                    NavigationLink(destination: SiteDetails()) {
                        Text("For Testing Purposes Navigate to Form")
                            .font(.headline)
                            .foregroundColor(.red)
                            .padding()
                    }
                }
            } else {
                // Filtered data list according to the active text
                let filteredData = isActiveFirstText ? data.filter { $0.isScheduledForAppraisal == true } : data
                
                DataListComponent(data: filteredData, destinationType: .customerAppraisalDetails)
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


struct QuickIntro: View {
    let title:String
    
    let description:String
    @Binding var presentationMode: PresentationMode // Binding for navigation

    
    var body: some View {
        HStack {
        VStack(alignment: .leading){
            Button(action: {
                print("pressed")
                self.presentationMode.dismiss()
                //self.showAlert = true // Set showAlert to true to show the alert

            }) {
                Image("Leading-icon-button")
                    .font(.system(size: 20))
                    .foregroundColor(Color(hex: "#49454F"))
            }
            Text(title)
                .font(.system(size: 24))
                .bold()
            Text(description)
                .font(.system(size: 12))
                .font(.headline)
                .foregroundColor(Color.gray)
        }
        Spacer ()
       
    }
        .navigationBarBackButtonHidden(true)
        .navigationBarHidden(true)
        .padding(.horizontal )
    
    }
}



struct DataListComponent: View {
    var data: [CustomerData]
    var destinationType: DestinationType
    
    var body: some View {
        ScrollView{
        VStack(spacing: 10) {
            
            if data.isEmpty {
                Text("No customers available")
                    .font(.headline)
                    .foregroundColor(.gray)
            }
            ForEach(data, id: \.self) { item in
                NavigationLink(destination: destinationView(for: item)) {
                    HStack {
                        Image(systemName: "person.circle")
                            .font(.system(size: 30))
                            .foregroundColor(.blue)
                        
                        VStack(alignment: .leading) {
                            Text("Name: \(item.customerName)")
                                .foregroundColor(.gray)

                            
                            Text("Phone: \(item.phoneNumber)")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                        
                        Spacer()
                        
                        Image(systemName: "arrow.right")
                            .foregroundColor(.gray)
                    }
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(10)
                }
            }
        }
        }
    }
    
    @ViewBuilder
    private func destinationView(for userData: CustomerData) -> some View {
        switch destinationType {
        case .customerDetails:
            CustomerDetails(userData: userData)
        case .customerAppraisalDetails:
            CustomerApraisalDetails(userData: userData)
        case .customerReposessionsDetails:
            CustomerApraisalDetails(userData: userData)
        case .equipmentDeliveryDetails:
                EquipmentDeliveryDetails(userData: userData)
        case .reposessionDetails:
                ReposessionDetails(userData: userData)
        case .customerStatements:
                CustomerStatements(userData: userData)
            

        }
    }
}

struct UserData: Identifiable, Hashable {
    let id = UUID()
    let name: String
    let phoneNumber: String
}
struct CustomerData: Codable, Identifiable, Hashable {
    let id: Int
    let staffUserId: String
    let employeeId: String? // Make employeeId optional if it's not always present
    let customerName: String
    let customerIdentityNumber: String? // Fix typo in property name
    let businessType: String
    let leaseType: String
    let scheduledDate: String? // Fix typo in property name
    let isScheduledForAppraisal: Bool? // Rename to match JSON key
    let geoLat: String
    let geoLong: String
    let phoneNumber: String // Fix typo in property name
    let dateCreated: String
    let appraisalDate: String? // Match JSON key name
    let actualAppraisalDate: String? // Match JSON key name
    let equipmentPrice: Double?
    let equipmentDescription: String?
    let currency: String?

    // Conformance to Hashable
    static func == (lhs: CustomerData, rhs: CustomerData) -> Bool {
        return lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

enum DestinationType {
    case customerDetails
    case customerAppraisalDetails
    case customerReposessionsDetails
    case equipmentDeliveryDetails
    case reposessionDetails
    case customerStatements

}
