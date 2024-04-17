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

    var receiptItems: [(String, String)] {
          [
              ("Customer name", onboardingData.name),
              ("TIN", onboardingData.TIN),
              ("Postal address", onboardingData.postalAddress),
              ("Region", onboardingData.selectedRegion ?? ""),
              ("District", onboardingData.selectedDistrict ?? ""), // Assuming there's a selectedDistrict property
              ("Ward", onboardingData.ward)
          ]
      }
    var receiptItems2: [(String, String)] {
          [
              ("Ward", onboardingData.ward),
              ("Nationality", onboardingData.nationalityState ?? "" ),
              ("Email address", onboardingData.EmailAddress),
              ("Phone Number", onboardingData.PhoneNumber ?? ""),
              ("Type of lease ", "Agriculture "), // Assuming there's a selectedDistrict property
              ("Ward", onboardingData.ward)
          ]
      }
    
    var body: some View {
        GeometryReader { geometry in
            
            VStack{
                ProgressBar(geometry: geometry, progress: $progress,title:"Summary",description: "Kindly review the information collected")
                .padding(.trailing,20)

                ScrollView{

                    ReceiptBox(items: receiptItems,geometry: geometry,size: 0.5)
                
                    ReceiptBox(items: receiptItems2,geometry: geometry,size: 0.5)
                    
                    DocumentContainerView(title: "Document Title")



                
    
                    }
                Spacer()
                NavigationLink(destination: Dashboard(), isActive: $navigateToDashboard) {
                                    EmptyView()
            }
                Button("Continue") {
                              showingConfirmation = true
                          }
                          .foregroundColor(.white)
                          .frame(maxWidth: .infinity)
                          .frame(height: 50)
                          .background(Color.green)
                          .cornerRadius(20)
                          .padding()
                      }
                
                }
        .alert(isPresented: $showingConfirmation) {
            Alert(
                title: Text("Confirm Submission"),
                message: Text("You are about to submit customer details. Are you sure you want to proceed?"),
                primaryButton: .destructive(Text("Submit"), action: {
                    navigateToDashboard = true
                }),
                secondaryButton: .cancel({
                    // Optional: Handle cancellation
                })
            )
        }

            }
        

    }
       




struct ReceiptBox: View {
    let items: [(String, String)]
    let geometry: GeometryProxy
    let size: Double

    
    var body: some View {
        VStack(spacing: 10) {
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.gray.opacity(0.2))
                .frame(maxWidth: .infinity)
                .frame(height: geometry.size.height * size)
                .padding()
                .overlay(
                    VStack(spacing: 0) {
                        ForEach(items, id: \.0) { item in
                            HStack {
                                Text(item.0)
                                    .padding(.leading,30)
                                Spacer()
                                Text(item.1)
                                    .padding(.trailing,30)
                            }
                            .padding(.vertical, 5)
                            Divider()
                        }
                    }
                )
        }
    }
}


struct DocumentContainerView: View {
    var title: String
    
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
                    .foregroundColor(.green)
                    .padding()
                
            }
            .padding()
            
     
        }
        )
    }
}
