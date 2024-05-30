//
//  CustomerDocument.swift
//  EFTA1
//
//  Created by Joshua on 4/7/24.
//

import SwiftUI
import UIKit

struct CompanyDocument: View {
    @State private var progress: CGFloat = 0.8 // Initial progress
    @State private var isModalVisible = false
    @State private var selectedFiles: [URL] = []
    @EnvironmentObject var config: AppConfig
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var onboardingData: CompanyOnboardingData  // Use the shared onboarding data
    @EnvironmentObject var StolenonboardingData: OnboardingData


    var body: some View {

            GeometryReader { geometry in
                VStack{
                    ProgressBar(geometry: geometry, progress: $progress,presentationMode: presentationMode, title:"\(StolenonboardingData.titleForCustomerOnboarding) documents",description: "Kindly upload the Company documents ")
                    
                    Spacer()
                    
                    Image("Frame")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 280, height: 280)
                        .padding()
                    
                    Button(action: {
                        isModalVisible.toggle()
                        
                    }){
                    Text("Upload Document")
                        .foregroundColor(.white)
                        .frame(width: 280)
                        .frame(height:60)
                        .background(config.primaryColor) // Gray background when profileImage is nil
                        .cornerRadius(8)
                        .padding(.horizontal)
                    }
                    Spacer()
                 
                    
                    CustomNavigationButton(destination: CompanySummary(), label: "Continue", backgroundColor: config.primaryColor)
                    
                    
                }
                DocumentModalView(
                    isVisible: $isModalVisible,
                    destinationView: { CompanyDocumentList()},
                    documentHandler: onboardingData
                )

            }
        }
    }




