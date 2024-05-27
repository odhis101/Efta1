//
//  CustomerSummary.swift
//  EFTA1
//
//  Created by Joshua on 4/8/24.
//


import SwiftUI
import AlertToast

struct CustomerSummary: View {
    @State private var progress: CGFloat = 1 // Initial progress
    @EnvironmentObject var onboardingData: OnboardingData
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
    @State private var message: String = "" // Message for the modal
    @State private var showingModal = false // State for showing the custom modal
    @State private var isNavigate = false


    var receiptItems: [(String, String)] {
        [
            ("Customer name", onboardingData.customerName),
            ("TIN", onboardingData.tin),
            ("Postal address", onboardingData.postalAddress),
            ("Region", onboardingData.region ?? ""),
            ("District", onboardingData.district ?? ""), // Assuming there's a selectedDistrict property
            ("Ward", onboardingData.ward)
        ]
    }
    
    var receiptItems2: [(String, String)] {
        [
            ("Ward", onboardingData.ward),
            ("Nationality", onboardingData.nationality ?? ""),
            ("Email address", onboardingData.emailAddress),
            ("Phone Number", onboardingData.phoneNumber ?? ""),
            ("Type of lease ", "Agriculture"), // Assuming there's a selectedDistrict property
            ("Ward", onboardingData.ward)
        ]
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {

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
                                    // Remove document from array
                                    if let index = onboardingData.documentURLs[idType]?.firstIndex(of: documentURL) {
                                        onboardingData.documentURLs[idType]?.remove(at: index)
                                    }
                                })
                            }
                        }
                    }
                }
                Spacer()
                NavigationLink(destination: IndividualOnboarding(), isActive: $navigateToCustomerDetails) {
                    EmptyView()
                }
                NavigationLink(destination: IndividualOnboarding2(), isActive: $navigateToCustomerDetails2) {
                    EmptyView()
                }
                Button("Continue") {
                    //showingConfirmation = true
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
            
            NavigationLink(destination: MyTabView(), isActive: $isNavigate) { // NavigationLink to the next page
                                   EmptyView() // Invisible navigation link
                               }
            
            
        }
        .overlay(CustomModal(isPresented: $showingModal, isLoading: $isLoading, isSuccess: $isSuccess, message: $message, Navigation: $isNavigate, onSubmit: {
                       submitCustomerData()
                   }))
    }
    
    private func submitCustomerData() {
        isLoading = true
        //isSuccess = nil // Reset success state
        NetworkManager().uploadData(onboardingData: onboardingData) { success, message in
            DispatchQueue.main.async {
                self.isLoading = false
                self.isSuccess = success
                self.message = message
                // Hide the modal after showing the result for a while
               
            }
        }
    }
}






struct ReceiptBox: View {
    var items: [(String, String)]
    var geometry: GeometryProxy
    var size: CGFloat
    var onEdit: () -> Void // Closure to handle the edit action
    @EnvironmentObject var config : AppConfig

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            ForEach(items, id: \.0) { item in
                HStack {
                    Text(item.0)
                    Spacer()
                    Text(item.1)
                        .bold()
                }
            }
            HStack{
                Spacer ()
                Button(action: {
                    onEdit()
                }) {
                    Text("Edit")
                        .foregroundColor(config.primaryColor)
                    
                }
            }
        }
        //.frame(width:geometry.size.width * size * 1.2)
        .padding()
        .background(Color(hex:"#F6F6F6"))
        .cornerRadius(10)
        //.shadow(radius: 5)
    }
}


struct DocumentContainerView: View {
    var title: String
    @EnvironmentObject var config: AppConfig

    
    var body: some View {
        Rectangle()
            .fill(Color.gray.opacity(0.2))
            .frame(height:30)
            .padding()
            .overlay(
                VStack(spacing: 0) {
            // Main content
            HStack {
                // Document sign on the left
                Image(systemName: "doc")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 20, height: 20)
                
                // Title in the middle
                Text(title)
                    .font(.headline)
                    .foregroundColor(.black)
                    .padding(.horizontal)
                
                Spacer()
                
                // Tick on the right
                Image(systemName: "checkmark.circle.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 20, height: 20)
                // change the color
                    .foregroundColor(config.primaryColor)
                    .padding()
                
            }
            .padding()
            
     
        }
        )
    }
}






struct CustomModal: View {
    @Binding var isPresented: Bool
    @Binding var isLoading: Bool
    @Binding var isSuccess: Bool?
    @Binding var message: String
    @Binding var Navigation: Bool
    
    let onSubmit: () -> Void
    @EnvironmentObject var config: AppConfig // Make sure the environment object is available
    
    var body: some View {
        if isPresented {
            VStack {
                Spacer()
                VStack {
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color.white)
                        .frame(width: UIScreen.main.bounds.width * 0.8,height: UIScreen.main.bounds.width * 0.5)
                        .overlay(
                            VStack(spacing: 20) {
                                if isLoading {
                                    ProgressView("Submitting...")
                                        .progressViewStyle(CircularProgressViewStyle(tint: config.primaryColor))
                                } else if let isSuccess = isSuccess {
                                    Image(systemName: isSuccess ? "checkmark.circle.fill" : "xmark.circle.fill")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 50, height: 50)
                                        .foregroundColor(isSuccess ? config.primaryColor : .red)
                                    Text(message)
                                        .foregroundColor(isSuccess ? config.primaryColor : .red)
                                    HStack {
                                        Button(action: {
                                            isPresented = false
                                        }) {
                                            Text("Cancel")
                                                .foregroundColor(.white)
                                                .padding()
                                                .background(Color.gray)
                                                .cornerRadius(10)
                                        }
                                        Button(action: {
                                            if isSuccess {
                                                Navigation = true
                                            } else {
                                                isPresented = false
                                            }
                                        }) {
                                            Text("OK")
                                                .foregroundColor(.white)
                                                .padding()
                                                .background(config.primaryColor)
                                                .cornerRadius(10)
                                        }
                                    }
                                } else {
                                    Image(systemName: "exclamationmark.triangle")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 50, height: 50)
                                        .foregroundColor(config.primaryColor)
                                    Text("Are you sure you want to submit?")
                                        //.foregroundColor(config.primaryColor)
                                    HStack {
                                        Button(action: {
                                            isPresented = false
                                        }) {
                                            Text("Cancel")
                                                .foregroundColor(.white)
                                                .padding()
                                                .background(Color.gray)
                                                .cornerRadius(10)
                                        }
                                        Button(action: {
                                            onSubmit()
                                        }) {
                                            Text("OK")
                                                .foregroundColor(.white)
                                                .padding()
                                                .background(config.primaryColor)
                                                .cornerRadius(10)
                                        }
                                    }
                                }
                            }
                            .padding()
                        )
                }
                Spacer()
            }
        }
    }
}


struct LoadingModal: View {
    var body: some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
                VStack {
                    ProgressView("Submitting...")
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        .padding()
                    Text("Please wait")
                        .foregroundColor(.white)
                }
                .padding()
                .background(Color.black.opacity(0.8))
                .cornerRadius(10)
                Spacer()
            }
            Spacer()
        }
        .background(Color.black.opacity(0.4).edgesIgnoringSafeArea(.all))
    }
}


