//
//  CustomerSummary.swift
//  EFTA1
//
//  Created by Joshua on 4/8/24.
//

import SwiftUI

struct CustomerSummary: View {
    @State private var progress: CGFloat = 1 // Initial progress
    @EnvironmentObject var onboardingData: OnboardingData
    @State private var showingConfirmation = false // State for showing the confirmation dialog
    @State private var  navigateToDashboard = false
    @EnvironmentObject var config: AppConfig
    @Environment(\.presentationMode) var presentationMode
    @State private var navigateToCustomerDetails = false // State to handle navigation to CustomerName
    @State private var navigateToCustomerDetails2 = false // State to handle navigation to CustomerName



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
              ("Nationality", onboardingData.nationality ?? "" ),
              ("Email address", onboardingData.emailAddress),
              ("Phone Number", onboardingData.phoneNumber ?? ""),
              ("Type of lease ", "Agriculture "), // Assuming there's a selectedDistrict property
              ("Ward", onboardingData.ward)
          ]
      }
    
    var body: some View {
        GeometryReader { geometry in
            
            VStack{
                ProgressBar(geometry: geometry, progress: $progress,presentationMode: presentationMode, title:"Summary",description: "Kindly review the information collected")

                ScrollView{

                    ReceiptBox(items: receiptItems, geometry: geometry, size: 0.5) {
                        navigateToCustomerDetails = true
                    }
                    ReceiptBox(items: receiptItems2, geometry: geometry, size: 0.5) {
                        navigateToCustomerDetails2 = true
                    }
                    VStack{
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
                              showingConfirmation = true
                          }
                          .foregroundColor(.white)
                          .frame(maxWidth: .infinity)
                          .frame(height: 50)
                          .background(config.primaryColor)
                          .cornerRadius(20)
                          .padding()
                      }
                
                }
        .alert(isPresented: $showingConfirmation) {
            Alert(
                title: Text("Confirm Submission"),
                message: Text("You are about to submit customer details. Are you sure you want to proceed?"),
                primaryButton: .destructive(Text("Submit"), action: {
                    
                    let url = URL(string: "\(baseURL)/Mobile/individualcustomer")!
                    NetworkManager().uploadData(url: url, onboardingData: onboardingData)
                    
                }),
                secondaryButton: .cancel({
                    // Optional: Handle cancellation
                })
            )
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
                        .font(.headline)
                    Spacer()
                    Text(item.1)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                .padding(.horizontal)
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
        .padding()
        .frame(width: geometry.size.width * size)
        .background(Color(UIColor.systemBackground))
        .cornerRadius(10)
        .shadow(radius: 5)
        .padding(.vertical, 10)
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

struct CustomerSummary_Previews: PreviewProvider {
    static var previews: some View {
        CustomerSummary()
            .environmentObject(OnboardingData()) // Provide a dummy OnboardingData object
            .environmentObject(AppConfig(region: .efken)) // Provide a dummy AppConfig object
    }
}
