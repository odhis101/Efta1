//
//  ImpactReporting.swift
//  EFTA1
//
//  Created by Joshua on 4/10/24.
//

import SwiftUI
import AlertToast

struct ImpactReporting: View {
    @State private var progress: CGFloat = 1 // Initial progress
    @State private var capturedImage: UIImage?
    @EnvironmentObject var siteQuestionData : SiteDetailsDataHandler
    @State private var CurrentMonthlyWage: String = ""
    @State private var CurrentDailyWage: String = ""
    @State private var RevenueLastMonth: String = ""
    @State private var RevenueNexttMonth: String = ""
    @State private var showingConfirmation = false // State for showing the confirmation dialog
    @State private var navigateToDashboard = false
    @State private var signature: UIImage?
    @State private var image: UIImage?
    @State private var isLoading = false // State for loading indicator
    @State private var showToast = false // State to show toast message
    @State private var toastMessage = "" // Message for the toast
    @State private var isSuccess: Bool? = nil // Success status for the modal
    @State private var showingModal = false // State for showing the custom modal
    @State private var message = ""
    @State private var isNavigate = false


    @EnvironmentObject var config: AppConfig
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        GeometryReader { geometry in
            VStack {
                ProgressBar(geometry: geometry, progress: $progress, presentationMode: presentationMode, title: "Financial Data", description: "Kindly complete the following details") // Pass progress as a binding

                ScrollView {
                    QuestionWithSmallTextField(question: "Monthly wages", placeholder: "Enter amount Tzs", selectedOption: $siteQuestionData.monthlyWages)
                    QuestionWithSmallTextField(question: "Daily wages", placeholder: "Enter amount Tzs", selectedOption: $siteQuestionData.dailyWages)
                    QuestionWithSmallTextField(question: "Revenues last month", placeholder: "Enter amount Tzs", selectedOption: $siteQuestionData.revenuesLastMonth)
                    QuestionWithSmallTextField(question: "Revenues this month", placeholder: "Enter amount Tzs", selectedOption: $siteQuestionData.revenuesThisMonth)
                    QuestionWithSmallTextField(question: "Revenues next month", placeholder: "Enter amount Tzs", selectedOption: $siteQuestionData.revenuesNextMonth)
                    SignatureCaptureField(signatureImage: $siteQuestionData.customerSignature)
                        .padding()
                    PhotoCaptureField(image: $siteQuestionData.captureSignatureImage)
                        .padding()

                    NavigationLink(destination: MyTabView(), isActive: $navigateToDashboard) {
                        EmptyView()
                    }
                    Spacer()
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
            }
           
          
        }
        .overlay(CustomModal(isPresented: $showingModal, isLoading: $isLoading, isSuccess: $isSuccess, message: $message, Navigation: $isNavigate, onSubmit: {
            submitCustomerData()
                   }))
    }

    private func submitCustomerData() {
        isLoading = true
        NetworkManager.shared.appraiseCustomer(bearer: "your_bearer_token", siteDetails: siteQuestionData) { success, message in
            DispatchQueue.main.async {
                self.isLoading = false
                self.showToast = true
                self.isSuccess = success
                self.toastMessage = message
                
            
            }
        }
    }
}


