//
//  CustomerSummary.swift
//  EFTA1
//
//  Created by Joshua on 4/8/24.
//

import SwiftUI

struct CompanySummary: View {
    @State private var progress: CGFloat = 1 // Initial progress
    @EnvironmentObject var onboardingData: CompanyOnboardingData
    @State private var showingConfirmation = false // State for showing the confirmation dialog
    @State private var  navigateToDashboard = false
    @EnvironmentObject var config: AppConfig
    @Environment(\.presentationMode) var presentationMode
    @State private var navigateToCustomerDetails = false // State to handle navigation to CustomerName
    @State private var navigateToCustomerDetails2 = false // State to handle navigation to CustomerName
    @EnvironmentObject var StolenonboardingData: OnboardingData



    var receiptItems: [(String, String)] {
          [
              ("\(StolenonboardingData.titleForCustomerOnboarding) name", onboardingData.companyName),
              ("Type of ID ", onboardingData.idType ?? ""),
              ("Postal address", onboardingData.postalAddress),
              ("Region", onboardingData.region ?? ""),
              ("District", onboardingData.district ?? ""), // Assuming there's a selectedDistrict property
             
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
                    .padding(.horizontal)
                    ReceiptBox(items: receiptItems2, geometry: geometry, size: 0.5) {
                        navigateToCustomerDetails2 = true
                    }
                    .padding(.horizontal)

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
                    
                    //let url = URL(string: "\(baseURL)/Mobile/individualcustomer")!
                    //NetworkManager().uploadData(onboardingData: onboardingData)
                    
                }),
                secondaryButton: .cancel({
                    // Optional: Handle cancellation
                })
            )
        }

            }
        

    }





