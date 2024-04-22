//
//  CustomerDocument.swift
//  EFTA1
//
//  Created by Joshua on 4/7/24.
//

import SwiftUI
import UIKit

struct CompanyDocument: View {
    @State private var progress: CGFloat = 0.9 // Initial progress
    @State private var isModalVisible = false
    @State private var selectedFiles: [URL] = []
    @EnvironmentObject var config: AppConfig


    var body: some View {

            GeometryReader { geometry in
                VStack{
                    ProgressBar(geometry: geometry, progress: $progress,title:"Company document",description: "Kindly upload the Company documents ")
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
                        .opacity(0.5)
                        .cornerRadius(8)
                        .padding(.horizontal)
                    }
                    Spacer()
                    NavigationLink(destination: CustomerSummary()) {

                    Text("Continue")
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height:40)
                        .background(config.primaryColor) // Gray background when profileImage is nil
                        .cornerRadius(8)
                        .padding(.horizontal)
                    }
                    
                }
                /*
                .overlay(
                    DocumentModalView(isVisible: $isModalVisible, destinationTitle: "Company Onboarding", documentHandler: CustomerMonitoringDocumentHandler())
                    .animation(.easeInOut)
                 )
                 */

            }
        }
    }




