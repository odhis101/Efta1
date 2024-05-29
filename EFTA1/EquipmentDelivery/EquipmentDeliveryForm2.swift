//
//  EquipmentDeliveryForm2.swift
//  EFTA1
//
//  Created by Joshua on 4/15/24.
//

import SwiftUI

struct EquipmentDeliveryForm2: View {
    @State private var progress: CGFloat = 0.2 // Initial progress
    @State private var AssetNumber:String=""
    @State private var navigateToDashboard = false

    @State private var showingConfirmation = false // State for showing the confirmation dialog
    
    @Environment(\.presentationMode) var presentationMode

    let receiptItems: [(String, String)] = [
            ("Equipment name & model:", "Trailer"),
            ("Model:", "CIMC 53 Foot Truck"),
            ("Equipment Serial number:", "1234567"),
            ("6975766100292", "6975766100292"),
        ]
    @EnvironmentObject var config: AppConfig

    var body: some View {

        GeometryReader { geometry in
            
            VStack{
                ProgressBar(geometry: geometry, progress: $progress,presentationMode: presentationMode, title:"Equipments for delivery",description: "Kindly select one of the equipments to fulfill delivery") // Pass progress as a binding
                    .padding(.trailing,20)                
                ScrollView{
                    QuestionWithFileType()
                    
                    //QuestionWithDate(question: "Date insurance Starts")

             
                    //QuestionWithDate(question: "Date insurance ends")
                    
                    //QuestionWithButtons(question: "Can the investment be activated?")
                   // QuestionWithTextField(question: "If no, why not and what is the agreed plan and timeline for activation?")
                    QuestionWithSmallTextField(question: "",placeholder: "EFTA Asset number",selectedOption: $AssetNumber)

                    
                    

                    
                    NavigationLink(destination: MyTabView(), isActive: $navigateToDashboard) {
                                        EmptyView()
                    }
                    

                
                }
                Spacer()
                
                /*
                    Button("Continue") {
                        showingConfirmation = true
                    }
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
                    .background(config.primaryColor)
                    .cornerRadius(20)
                    .padding()
                 */
                
                CustomNavigationButton(destination: MyTabView(), label: "Continue", backgroundColor: config.primaryColor)

                

                
                
                }
            }
        .alert(isPresented: $showingConfirmation) {
            Alert(
                title: Text("Confirm Submission"),
                message: Text("You are about to submit customer details. Are you sure you want to proceed?"),
                primaryButton: .destructive(Text("Submit"), action: {
                    // Action for submission
                    // Navigate to Dashboard or handle the submission
                    navigateToDashboard = true // This triggers navigation when the user confirms submission

                }),
                secondaryButton: .cancel({
                    // Optional: Handle cancellation
                })
            )
        }
        
    }
}

