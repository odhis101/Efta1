//
//  CustomerApraisalsSearch.swift
//  EFTA1
//
//  Created by Joshua on 4/9/24.
//

import SwiftUI

struct CustomerApraisalsSearch: View {
    @State private var searchText = ""
    @State private var isActiveFirstText = true
    @State private var data: [UserData] = [] // Initialize empty array to hold data


    var body: some View {
        VStack{
            QuickIntro(title: "Customer Appraisals", description: "kindly select one of the customers you want to appraise")
            // make this search bar look better and more searchier
            TextField("Where do you currently stay?", text:$searchText )
            .padding(.bottom)
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .background(Color.white)
            .cornerRadius(10)
            .padding(.horizontal)
            .offset(y: 20) // Adjust the offset as needed
    
            ToggleableTextComponent(text1: "Text 1", text2: "Text 2", isActiveFirstText: isActiveFirstText) {
                // this will allow data to be dynamically gotten here
                isActiveFirstText.toggle()
                fetchData()

            }
            DataListComponent(data: data, destinationType: .customerAppraisalDetails)
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



struct QuickIntro: View {
    let title:String
    
    let description:String
    
    var body: some View {
        VStack(alignment: .leading){
            Text(title)
                .bold()
            
            Text(description)
                .font(.headline)
                .foregroundColor(Color.gray)
        }
        .padding(.trailing,10)
        .padding()
    }
}


struct ToggleableTextComponent: View {
    var text1: String
    var text2: String
    var isActiveFirstText: Bool
    var onToggle: () -> Void // Closure to handle toggle action
    
    var body: some View {
        RoundedRectangle(cornerRadius: 20)
            .fill(Color.gray)
            .frame(height: 40)
            .frame(maxWidth: .infinity)
            .padding()
            .overlay(
                HStack {
                    Button(action: {
                        // toggle active state
                        onToggle()
                    }) {
                        RoundedRectangle(cornerRadius: 20)
                            .fill(isActiveFirstText ? Color.green : Color.clear) // Use green color if active
                            .frame(height: 40)
                            .padding()


                            .overlay(
                                Text(text1)
                                    .foregroundColor(isActiveFirstText ? .white : .black) // Text color changes based on active state
                            )
                    }
                    Spacer()
                    Button(action: {
                        // toggle active state
                        onToggle()
                    }) {
                        RoundedRectangle(cornerRadius: 20)
                            .fill(!isActiveFirstText ? Color.green : Color.clear) // Use green color if active
                            .frame(height: 40)
                            .padding()

                            .overlay(
                                Text(text2)
                                    .foregroundColor(!isActiveFirstText ? .white : .black) // Text color changes based on active state
                            )
                    }
                }
            )
    }
}

struct DataListComponent: View {
    var data: [UserData]
    var destinationType: DestinationType
    
    var body: some View {
        VStack(spacing: 10) {
            ForEach(data, id: \.self) { item in
                NavigationLink(destination: destinationView(for: item)) {
                    HStack {
                        Image(systemName: "person.circle")
                            .font(.system(size: 30))
                            .foregroundColor(.blue)
                        
                        VStack(alignment: .leading) {
                            Text("Name: \(item.name)")
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
    
    @ViewBuilder
    private func destinationView(for userData: UserData) -> some View {
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

        }
    }
}

struct UserData: Identifiable, Hashable {
    let id = UUID()
    let name: String
    let phoneNumber: String
}

enum DestinationType {
    case customerDetails
    case customerAppraisalDetails
    case customerReposessionsDetails
    case equipmentDeliveryDetails
    case reposessionDetails
}
