//
//  CustomerMonitoringDocumentList.swift
//  EFTA1
//
//  Created by Joshua on 4/11/24.
//

import SwiftUI

struct CompanyDocumentList: View {
    @State private var progress: CGFloat = 0.85
    @EnvironmentObject var config: AppConfig
    @EnvironmentObject var onboardingData: CompanyOnboardingData
    @State private var navigateBack = false
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var StolenonboardingData: OnboardingData
    
    var isFormComplete: Bool {
        onboardingData.documentURLs.values.flatMap { $0 }.count >= 3 // Check if there are at least 3 documents
    }
    

    var body: some View {
        GeometryReader { geometry in
            VStack {
                ProgressBar(geometry: geometry, progress: $progress, presentationMode: presentationMode, title: "\(StolenonboardingData.titleForCustomerOnboarding) Document List", description: "Kindly complete the following details")

                VStack{
                    ForEach(Array(onboardingData.documentURLs.values.enumerated()), id: \.element) { index, documentURLs in
                        ForEach(documentURLs, id: \.self) { documentURL in
                            ListedDocument(documentName: documentURL.lastPathComponent, onDelete: {
                                // Remove document from array
                                if let dictIndex = onboardingData.documentURLs.firstIndex(where: { $0.value == documentURLs }) {
                                    // Use the dictIndex to access and modify the dictionary
                                    var updatedURLs = documentURLs
                                    updatedURLs.remove(at: index)
                                    onboardingData.documentURLs[onboardingData.documentURLs.keys[dictIndex]] = updatedURLs
                                }
                            })
                        }
                    }
                    Button(action: {
                        navigateBack = true
                    }){
                        RoundedRectangle(cornerRadius: 10)
                            .foregroundColor(config.primaryColor.opacity(0.3))
                            .frame(width: 200)
                            .frame(height:60)
                            .overlay(
                                HStack{
                                    Text("+")
                                        .foregroundColor(config.primaryColor)
                                    
                                    Text("Upload Document")
                                        .foregroundColor(config.primaryColor)
                                    
                                    
                                    
                                    
                                    
                                }
                                
                                
                            )
                        
                    }
                    Spacer ()
                }
                .frame(height: geometry.size.height * 1.3)
                    
                
               
                CustomNavigationButton(destination: CompanySummary(), label: "Continue", backgroundColor: isFormComplete ? config.primaryColor : Color.gray)
                
            }
        }
      
        .onAppear {
            print("Document URLs: \(onboardingData.documentURLs)")
            
        }
        DocumentModalView2(
            isVisible: $navigateBack,
            documentHandler: onboardingData
        )
        
    }
}


