//
//  SiteDetails.swift
//  EFTA1
//
//  Created by Joshua on 4/10/24.
//

import SwiftUI

struct SiteDetails: View {
    @State private var progress: CGFloat = 0.2 // Initial progress
    
    @State private var capturedImage: UIImage?

    @EnvironmentObject var config: AppConfig

    @ObservedObject var siteQuestionData = SiteQuestionDataHandler()
    

    var body: some View {

        GeometryReader { geometry in
            
            VStack{
                ProgressBar(geometry: geometry, progress: $progress,title:"Site Details",description: "Kindly collect the following information from the customer") // Pass progress as a binding
                    .padding(.trailing,20)

                ScrollView{
                PhotoCaptureButton(capturedImage: $capturedImage,
                                   SiteQuestionData: siteQuestionData,
                                   question: "Has a full description of the site been noted (number of buildings / warehouses / acreage etc)?",
                                   imageStorage: $siteQuestionData.profileImage)
                
                QuestionWithButtons(question: "Do you agree with the terms?")
                
                QuestionWithTextField(question: "If land is rented, did you discuss how long the applicant has rented their site for, any risks of not renewing the rental agreement, how often the applicant has to pay their rent?")
                
                
                PhotoCaptureButton(capturedImage: $capturedImage,
                                   SiteQuestionData: siteQuestionData,
                                   question: "Has a full description of the site been noted (number of buildings / warehouses / acreage etc)?",
                                   imageStorage: $siteQuestionData.profileImage)
                PhotoCaptureButton(capturedImage: $capturedImage,
                                   SiteQuestionData: siteQuestionData,
                                   question: "Has a full description of the site been noted (number of buildings / warehouses / acreage etc)?",
                                   imageStorage: $siteQuestionData.profileImage)
                }
                Spacer ()
                NavigationLink(destination: SiteDetails2()){

                Text("Continue")
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height:40)
                    .background(config.primaryColor) // Gray background when profileImage is nil
                    .cornerRadius(8)
                    .padding(.horizontal)
                }

                }
            }
            
        
    }
}








