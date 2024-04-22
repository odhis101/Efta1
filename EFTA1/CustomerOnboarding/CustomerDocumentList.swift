//
//  CustomerMonitoringDocumentList.swift
//  EFTA1
//
//  Created by Joshua on 4/11/24.
//

import SwiftUI

struct CustomerDocumentList: View {
    @State private var progress: CGFloat = 0.6
    @EnvironmentObject var config: AppConfig
    @EnvironmentObject var onboardingData: OnboardingData
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                ProgressBar(geometry: geometry, progress: $progress, title: "Customer Document List", description: "Kindly complete the following details")
                    .padding(.trailing,20)

                ScrollView{
                    ForEach(onboardingData.documentURLs, id: \.self) { documentURL in
                        ListedDocument(documentName: documentURL.lastPathComponent, onDelete: {
                            // Remove document from array
                            if let index = onboardingData.documentURLs.firstIndex(of: documentURL) {
                                onboardingData.documentURLs.remove(at: index)
                            }
                        })
                    }
                    
                }
                Spacer ()
                NavigationLink(destination: CustomerSummary()){
                    Text("Continue")
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height:40)
                        .background(config.primaryColor)
                        .cornerRadius(8)
                        .padding(.horizontal)
                }
            }
        }
        .onAppear {
            print("Document URLs: \(onboardingData.documentURLs)")
        }
    }
}

struct ListedDocument: View {
    var documentName: String
    @EnvironmentObject var config: AppConfig
    var onDelete: () -> Void // Closure to handle deletion
    
    var body: some View {
        VStack {
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.gray.opacity(0.2))
                .frame(maxWidth: .infinity)
                .frame(height: 60)
                .padding()
                .overlay(
                    HStack {
                        Image("docsIcon")
                            .resizable()
                            .frame(width: 30, height: 30)
                            .foregroundColor(config.primaryColor)
                        
                        VStack(alignment: .leading) {
                            Text(documentName)
                                .font(.headline)
                            
                        }
                        Spacer()
                        Image(systemName: "checkmark")
                           .resizable()
                           .frame(width: 20, height: 20)
                           .foregroundColor(config.primaryColor)
                        
                        Button(action: onDelete) { // Call onDelete closure when button is tapped
                            Image(systemName: "trash")
                                .resizable()
                                .frame(width: 20, height: 20)
                                .foregroundColor(.red)
                        }
                    }
                    .padding()
                    .overlay(
                        VStack{
                        Spacer()
                        Rectangle()
                            .frame(height: 3)
                            .foregroundColor(.green) // Adjust color as needed
                            .padding(.horizontal)
                    
                        }
                    )

                    
                )
        }
    }
}
