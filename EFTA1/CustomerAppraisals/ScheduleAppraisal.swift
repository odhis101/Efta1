//
//  ScheduleAppraisal.swift
//  EFTA1
//
//  Created by Joshua on 5/28/24.
//


import SwiftUI

struct ScheduleAppraisal: View {
    @State private var searchText = ""
    @State private var isActiveFirstText = true
    @State private var Search:String=""
    @EnvironmentObject var config: AppConfig
    @EnvironmentObject var siteQuestionData: SiteDetailsDataHandler

    @Environment(\.presentationMode) var presentationMode
    @State private var scheduleDate = Date()
    @State private var scheduleTime = Date()
    @State private var isSuccess: Bool? = nil // Success status for the modal
    @State private var message: String = "" // Message for the modal
    @State private var showingModal = false // State for showing the custom modal
    @State private var isNavigate = false
    @State private var isLoading = false // State for loading indicator

    

    
    


    var body: some View {
        VStack{
            QuickIntro(title: "Create schedule", description: "Kindly fill in the details to create the schedule",presentationMode:presentationMode)
        
            QuestionWithDate(selectedDate: $scheduleDate, question: "Schedule Date ")
                .padding(.top,10)
        
            QuestionWithTime(selectedDate: $scheduleTime, question: "Schedule Time ")
            Spacer ()
            


            Button("Continue") {
                showingModal = true
                
            }
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .frame(height: 50)
            .background(config.primaryColor)
            .cornerRadius(20)
            .padding()

            
            
        }
        .overlay(CustomModal(isPresented: $showingModal, isLoading: $isLoading, isSuccess: $isSuccess, message: $message, Navigation: $isNavigate, onSubmit: {
            submitCustomerData()
                   }))
        NavigationLink(destination: MyTabView(), isActive: $isNavigate) { // NavigationLink to the next page
            EmptyView() // Invisible navigation link
        }
        
    }
    
    private func submitCustomerData() {
        isLoading = true
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss" // Adjust the date format as per your API requirement
        
        let formattedDate = dateFormatter.string(from: scheduleDate)
        
        // Call the scheduleAppraisal function
        NetworkManager().scheduleAppraisal(customerId: siteQuestionData.customerIdentityNumber, scheduledDate: formattedDate) { result in
            DispatchQueue.main.async {
                self.isLoading = false
                
                switch result {
                case .success(let data):
                    // Handle success
                    if let responseString = String(data: data, encoding: .utf8) {
                        print("Response: \(responseString)")
                        isSuccess = true
                        message = "Appraisal scheduled successfully"
                    } else {
                        // Error in decoding response
                        isSuccess = false
                        message = "Error decoding response"
                    }
                case .failure(let error):
                    // Handle failure
                    print("Error: \(error)")
                    isSuccess = false
                    message = "Failed to schedule appraisal: \(error.localizedDescription)"
                }
            }
        }
    }

    
    
    
    }

