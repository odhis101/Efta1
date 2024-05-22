//
//  CustomerMonitioringDocument.swift
//  EFTA1
//
//  Created by Joshua on 4/11/24.
//

import SwiftUI

struct CustomerMonitioringDocument: View {
    @State private var progress: CGFloat = 0.9 // Initial progress
    @State private var isModalVisible = false
    @State private var selectedFiles: [URL] = []
    //@StateObject var documentHandler = DocumentHandler() // Use @ObservedObject if passed from parent view
    @EnvironmentObject var config: AppConfig
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        GeometryReader { geometry in
            VStack{
                ProgressBar(geometry: geometry, progress: $progress,presentationMode: presentationMode, title:"Company document",description: "Kindly upload the Company documents ")
                    .padding(.trailing,20)
                
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
                /*
                NavigationLink(destination: CustomerSummary()) {

                Text("Continue")
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height:40)
                    .background(config.primaryColor) // Gray background when profileImage is nil
                    .cornerRadius(8)
                    .padding(.horizontal)
                }
                */
                CustomNavigationButton(destination: CustomerMonitioringDocument(), label: "Continue", backgroundColor: config.primaryColor)
                
            }
            /*
            .overlay(
                DocumentModalView(isVisible: $isModalVisible, destinationTitle: "Customer Monitoring DocumentList", documentHandler: CustomerMonitoringDocumentHandler()) // Pass documentHandler here

                .animation(.easeInOut)
             )
             */

        }
    }

}

