//
//  CustomerMonitoringDocumentList.swift
//  EFTA1
//
//  Created by Joshua on 4/11/24.
//

import SwiftUI

struct CustomerDocumentList: View {
    @State private var progress: CGFloat = 0.85
    @EnvironmentObject var config: AppConfig
    @EnvironmentObject var onboardingData: OnboardingData
    @State private var navigateBack = false
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                ProgressBar(geometry: geometry, progress: $progress, presentationMode: presentationMode, title: "Customer Document List", description: "Kindly complete the following details")

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
                    
                
               
                CustomNavigationButton(destination: CustomerSummary(), label: "Continue", backgroundColor: config.primaryColor)
                
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

struct ListedDocument: View {
    var documentName: String
    @EnvironmentObject var config: AppConfig
    var onDelete: () -> Void // Closure to handle deletion
    
    var body: some View {
        VStack {
            Button(action: {}) { // Mimic the style of QuestionWithFileType
                HStack {
                    VStack(alignment: .leading){
                    Text(documentName)
                        .foregroundColor(.black)
                        .multilineTextAlignment(.leading)
                    }
                    Spacer()
                    HStack {
                        Image(systemName: "checkmark.circle")
                            .foregroundColor(.green)
                        Button(action: onDelete) {
                            Image(systemName: "trash")
                                .foregroundColor(.red)
                        }
                    }
                }
                .padding(.horizontal)
            }
            Rectangle()
                .frame(height: 2)
                .foregroundColor(config.primaryColor)
                .padding(.horizontal)
        }
        .padding(.bottom, 25)
    }
}
struct CustomerDocumentList_Previews: PreviewProvider {
    static var previews: some View {
        let config = AppConfig(region: .efken)
        let onboardingData = OnboardingData()
        
        return CustomerDocumentList()
            .environmentObject(config)
            .environmentObject(onboardingData)
    }
}
