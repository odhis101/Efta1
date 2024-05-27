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
    @State private var isModalVisible = false
    @State private var isPresentingModal = false

    @Environment(\.presentationMode) var presentationMode


    var body: some View {
        GeometryReader { geometry in
        VStack{
        QuickIntro(title: "Alex Mwangi", description: "Kindly see the customer details and proceed to generate a statement",presentationMode: presentationMode)

    
                        VStack(alignment: .leading){
                            Text("Customer Lease agreements")
                                .foregroundColor(config.primaryColor)
                            Text("Kindly select one of the lease agreements to generate customer statements")
                                .foregroundColor(.gray)
                            ScrollView{
                                RectangleView(id: "001", amount: "100", userID: "12345", dueDate: "2024-04-15", isModalVisible: $isModalVisible)
                                RectangleView(id: "001", amount: "100", userID: "12345", dueDate: "2024-04-15", isModalVisible: $isModalVisible)
                                RectangleView(id: "001", amount: "100", userID: "12345", dueDate: "2024-04-15", isModalVisible: $isModalVisible)
                                RectangleView(id: "001", amount: "100", userID: "12345", dueDate: "2024-04-15", isModalVisible: $isModalVisible)

                            
                        
                            Spacer ()
                        }
                        }
                        .padding()

                

        
        }
        
        .overlay(
             ModalViewStatement(isVisible: $isModalVisible)
                 .animation(.easeInOut)
                 .offset(y: isModalVisible ? 0 : geometry.size.height) // Set initial offset

         )
        }

        
    }

}
struct RectangleView: View {
    var id: String
    var amount: String
    var userID: String
    var dueDate: String
    @Binding var isModalVisible: Bool // Binding to toggle the modal
    @EnvironmentObject var config: AppConfig


    var body: some View {
        VStack {
            RoundedRectangle(cornerRadius: 8)
                .fill(Color.gray.opacity(0.2))
                .frame(height: 70)
                .overlay(
                    VStack {
                        HStack {
                            Text(id)
                                .foregroundColor(.gray)
                            Spacer()
                            Text("TZS \(amount)")
                                .foregroundColor(config.primaryColor)
                            Image(systemName: "chevron.right")
                        }
                        
                        HStack {
                            Text(userID)
                            Spacer()
                            Text(dueDate)
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                    }
                    .padding(.horizontal)
                )
        }
        .onTapGesture {
            isModalVisible.toggle() // Toggle modal visibility when tapped
        }
    }
}


