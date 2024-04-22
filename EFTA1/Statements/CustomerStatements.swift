//
//  CustomerStatements.swift
//  EFTA1
//
//  Created by Joshua on 4/17/24.
//

import SwiftUI

struct CustomerStatements: View {
    var userData: UserData
    @EnvironmentObject var config: AppConfig


    var body: some View {
        QuickIntro(title: "Alex Mwangi", description: "Kindly see the customer details and proceed to generate a statement")
        Rectangle()
                    .fill(Color.gray.opacity(0.2))  // Light gray background
                    .frame(maxWidth: .infinity)
                    .padding()
                    .overlay(
                        ScrollView{
                        VStack(alignment: .leading){
                            Text("Customer Lease agreements")
                                .foregroundColor(config.primaryColor)
                                .padding(.top,10)
                            Text("Kindly select one of the lease agreements to generate customer statements")
                                .foregroundColor(.gray)

                                RectangleView(id: "001", amount: "100", userID: "12345", dueDate: "2024-04-15")
                                RectangleView(id: "002", amount: "200", userID: "67890", dueDate: "2024-04-20")
                                RectangleView(id: "001", amount: "100", userID: "12345", dueDate: "2024-04-15")
                                RectangleView(id: "002", amount: "200", userID: "67890", dueDate: "2024-04-20")
                                RectangleView(id: "001", amount: "100", userID: "12345", dueDate: "2024-04-15")
                                RectangleView(id: "002", amount: "200", userID: "67890", dueDate: "2024-04-20")
                            
                        
                            Spacer ()
                        }
                        .padding()
                        }
                    )
                    .cornerRadius(10)
        
        
        
        
    }
}
struct RectangleView : View {
    var id: String
    var amount: String
    var userID: String
    var dueDate: String
    
    var body: some View {
        VStack {
            RoundedRectangle(cornerRadius: 8)
                .fill(.gray.opacity(0.2))
                .frame(height:70)
                .overlay(
                    VStack {
                        HStack {
                            Text(id)
                            Spacer()
                            Text(amount)
                            Image(systemName: "chevron.right")
                        }
                        
                        
                        HStack {
                            Text(userID)
                            Spacer()
                            Text(dueDate)
                        }
                            }
                        .padding(.horizontal)
                
                )
         
    }
}
}
