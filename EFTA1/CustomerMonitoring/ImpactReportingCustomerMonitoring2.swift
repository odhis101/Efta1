//
//  ImpactReportingCustomerMonitoring2.swift
//  EFTA1
//
//  Created by Natasha Odhiambo on 17/05/2024.
//

import SwiftUI

struct ImpactReportingCustomerMonitoring2: View {
    @State private var progress: CGFloat = 1 // Initial progress
    @State private var capturedImage: UIImage?
    @ObservedObject var siteQuestionData = SiteDetailsDataHandler()
    @State private var CurrentMonthlyWage:String=""
    @State private var CurrentDailyWage:String=""
    @State private var RevenueLastMonth:String=""
    @State private var RevenueNexttMonth:String=""
    @State private var showingConfirmation = false // State for showing the confirmation dialog
    @State private var navigateToDashboard = false
    @State private var signature: UIImage?
    @State private var image: UIImage?


    @EnvironmentObject var config: AppConfig

    @Environment(\.presentationMode) var presentationMode
    var body: some View {

        GeometryReader { geometry in
            
            VStack{
                ProgressBar(geometry: geometry, progress: $progress,presentationMode: presentationMode, title:"Financial Data",description: "Kindly complete the following details") // Pass progress as a binding

                ScrollView{
                    QuestionWithSmallTextField(question: "Monthly wages",placeholder:"Enter amount Tzs",selectedOption: $CurrentMonthlyWage)
                    QuestionWithSmallTextField(question: "Daily wages",placeholder:"Enter amount Tzs",selectedOption: $CurrentDailyWage)
                    QuestionWithSmallTextField(question: "Revenues last month",placeholder:"Enter amount Tzs",selectedOption: $RevenueLastMonth)
                    QuestionWithSmallTextField(question: "Revenues this month",placeholder:"Enter amount Tzs",selectedOption: $CurrentMonthlyWage)
                    QuestionWithSmallTextField(question: "Revenues next month",placeholder:"Enter amount Tzs",selectedOption: $RevenueNexttMonth)
                    SignatureCaptureField(signatureImage: $signature)
                         .padding()
                    
                    PhotoCaptureField(image: $image)
                        .padding()
                    
                    
                    NavigationLink(destination: MyTabView(), isActive: $navigateToDashboard) {
                                        EmptyView()
                }
                Spacer ()

             
                    CustomNavigationButton(destination: CustomerMonitioringDocument(), label: "Continue", backgroundColor: config.primaryColor)

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
}
/*
#Preview {
    ImpactReportingCustomerMonitoring2()
        .environmentObject(AppConfig(region: .efken))
        .environmentObject(PinHandler())
}
*/
