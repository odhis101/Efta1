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

    
    @ObservedObject var siteQuestionData = SiteQuestionDataHandler()
    
    var body: some View {
        GeometryReader { geometry in
            
            VStack{
                ProgressBar(geometry: geometry, progress: $progress,title:"Documentation & Assets",description: "Kindly complete the following details") // Pass progress as a binding
                    .padding(.trailing,20)
                    .padding(.bottom,30)

                ScrollView{
                PhotoCaptureButton(capturedImage: $capturedImage,
                                   SiteQuestionData: siteQuestionData,
                                   question: "Are there any certificates / registrations missing from the application which you need to see? Are all of the certificates up to date?",
                                   imageStorage: $siteQuestionData.profileImage)
                    
                PhotoCaptureButton(capturedImage: $capturedImage,
                                       SiteQuestionData: siteQuestionData,
                                       question: "Can you see the assets noted in the application? Are they in good standing?",
                                       imageStorage: $siteQuestionData.profileImage)
                    
                PhotoCaptureButton(capturedImage: $capturedImage,
                                       SiteQuestionData: siteQuestionData,
                                       question: "Are stock levels in line with those noted in the application form?",
                                       imageStorage: $siteQuestionData.profileImage)
                PhotoCaptureButton(capturedImage: $capturedImage,
                                           SiteQuestionData: siteQuestionData,
                                           question: "Have you taken copies of the order books (and payments books where relevant)?",
                                           imageStorage: $siteQuestionData.profileImage)

                
                }
                Spacer ()
                NavigationLink(destination: Market()){

                Text("Continue")
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height:40)
                    .background(Color(hex: "#2AA241")) // Gray background when profileImage is nil
                    .cornerRadius(8)
                    .padding(.horizontal)
                    }

                }
            }
            
        
    }
}
