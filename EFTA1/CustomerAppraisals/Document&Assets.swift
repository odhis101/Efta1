//
//  Documen&Assets.swift
//  EFTA1
//
//  Created by Joshua on 4/10/24.
//

import SwiftUI

struct Document_Assets: View {
    @State private var progress: CGFloat = 0.2 // Initial progress
    
    @State private var capturedImage: UIImage?

    @EnvironmentObject var config: AppConfig

    @ObservedObject var siteQuestionData = SiteDetailsDataHandler()
    
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        GeometryReader { geometry in
            
            VStack{
                ProgressBar(geometry: geometry, progress: $progress,presentationMode: presentationMode, title:"Documentation & Assets",description: "Kindly complete the following details") // Pass progress as a binding

                ScrollView{
                PhotoCaptureButton(capturedImage: $siteQuestionData.missingCertificates,
                                   siteQuestionData: siteQuestionData,
                                   question: "Are there any certificates / registrations missing from the application which you need to see? Are all of the certificates up to date?",
                                   imageStorage: $siteQuestionData.missingCertificates)
                    
                    PhotoCaptureButton(capturedImage: $siteQuestionData.assetsInGoodStanding,
                                       siteQuestionData: siteQuestionData,
                                       question: "Can you see the assets noted in the application? Are they in good standing?",
                                       imageStorage: $siteQuestionData.assetsInGoodStanding)
                    
                    PhotoCaptureButton(capturedImage: $siteQuestionData.stockLevelsAligned,
                                       siteQuestionData: siteQuestionData,
                                       question: "Are stock levels in line with those noted in the application form?",
                                       imageStorage: $siteQuestionData.stockLevelsAligned)
                    PhotoCaptureButton(capturedImage: $siteQuestionData.orderBooksAndPayments,
                                       siteQuestionData: siteQuestionData,
                                           question: "Have you taken copies of the order books (and payments books where relevant)?",
                                           imageStorage: $siteQuestionData.orderBooksAndPayments)

                
                }
                Spacer ()
                /*
                NavigationLink(destination: Market()){

                Text("Continue")
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height:40)
                    .background(config.primaryColor) // Gray background when profileImage is nil
                    .cornerRadius(8)
                    .padding(.horizontal)
                    }
                */
                CustomNavigationButton(destination: Market(), label: "Continue", backgroundColor: config.primaryColor)

                }
            }
            
        
    }
}
