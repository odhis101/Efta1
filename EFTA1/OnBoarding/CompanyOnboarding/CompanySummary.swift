//
//  CustomerSummary.swift
//  EFTA1
//
//  Created by Joshua on 4/8/24.
//

import SwiftUI

import AlertToast

struct CompanySummary: View {
    @State private var progress: CGFloat = 1 // Initial progress
    @EnvironmentObject var onboardingData: CompanyOnboardingData
    @EnvironmentObject var companyData: CompanyOnboardingData
    @EnvironmentObject var onboardingIndiviual: OnboardingData // sorry this is a messy solution


    @State private var showingConfirmation = false // State for showing the confirmation dialog
    @State private var navigateToDashboard = false
    @EnvironmentObject var config: AppConfig
    @Environment(\.presentationMode) var presentationMode
    @State private var navigateToCustomerDetails = false // State to handle navigation to CustomerName
    @State private var navigateToCustomerDetails2 = false // State to handle navigation to CustomerName
    @State private var isLoading = false // State for loading indicator
    @State private var showToast = false // State to show toast message
    @State private var toastMessage = "" // Message for the toast
    @State private var isSuccess: Bool? = nil // Success status for the modal
    @State private var showingModal = false // State for showing the custom modal
    @State private var message = ""
    @State private var isNavigate = false




    var receiptItems: [(String, String)] {
        [
            ("Company name", onboardingData.companyName),
            ("TIN", onboardingData.TIN),
            ("Postal address", onboardingData.postalAddress),
            ("Region", onboardingData.region ?? ""),
            ("District", onboardingData.district ?? ""),
            ("Ward", onboardingData.ward)
        ]
    }
    
    var receiptItems2: [(String, String)] {
        [
            ("Contact person", onboardingData.contactPersonName),
            ("ID Type", onboardingData.idType ?? ""),
            ("ID Number", onboardingData.idNumber),
            ("Phone Number", onboardingData.phoneNumber),
            ("Email address", onboardingData.emailAddress),
            ("Nationality", onboardingData.nationality ?? ""),
            ("Type of Equipment", onboardingData.typeOfEquipment),
            ("Price of Equipment", onboardingData.priceOfEquipment)
        ]
    }
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                ProgressBar(geometry: geometry, progress: $progress, presentationMode: presentationMode, title: "Summary", description: "Kindly review the information collected")
                
                ScrollView {
                    ReceiptBox(items: receiptItems, geometry: geometry, size: 0.5) {
                        navigateToCustomerDetails = true
                    }
                    .padding(.horizontal)
                    ReceiptBox(items: receiptItems2, geometry: geometry, size: 0.5) {
                        navigateToCustomerDetails2 = true
                    }
                    .padding(.horizontal)
                    
                    
                    VStack {
                        ForEach(onboardingData.documentURLs.keys.sorted(), id: \.self) { idType in
                            ForEach(onboardingData.documentURLs[idType]!, id: \.self) { documentURL in
                                ListedDocument(documentName: documentURL.lastPathComponent, onDelete: {
                                    if let index = onboardingData.documentURLs[idType]?.firstIndex(of: documentURL) {
                                        onboardingData.documentURLs[idType]?.remove(at: index)
                                    }
                                })
                            }
                        }
                    }
                    .padding(.vertical)
                }
                Spacer()
                NavigationLink(destination: IndividualOnboarding(), isActive: $navigateToCustomerDetails) {
                    EmptyView()
                }
                NavigationLink(destination: IndividualOnboarding2(), isActive: $navigateToCustomerDetails2) {
                    EmptyView()
                }
                Button("Continue") {
                    showingConfirmation = true
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
                    submitCompanyData()
                       }))
        }
    }
    
    private func submitCompanyData() {
        isLoading = true
        NetworkManager.shared.uploadCompanyOnboardingData(onboardingData: onboardingIndiviual, companyData: companyData) { success, message in
            DispatchQueue.main.async {
                self.isLoading = false
                self.isSuccess = success
                self.message = message
                
            }
        }
    }
}





