//
//  Market3.swift
//  EFTA1
//
//  Created by Joshua on 4/10/24.
//

import SwiftUI

struct Market3: View {
    @State private var progress: CGFloat = 0.48 // Initial progress
    
    @State private var capturedImage: UIImage?

    @EnvironmentObject var config: AppConfig

    
    @EnvironmentObject var siteQuestionData : SiteDetailsDataHandler

    @Environment(\.presentationMode) var presentationMode
    var isFormComplete: Bool {
         siteQuestionData.areForecastedVolumesMakingSense != nil &&
        siteQuestionData.otherIncomeSourcesProof != nil &&
        siteQuestionData.potentialProductDiversification != nil &&
         siteQuestionData.additionalServicesConsideration != nil 
        
     }
    var body: some View {

        GeometryReader { geometry in
            
            VStack{
                ProgressBar(geometry: geometry, progress: $progress,presentationMode: presentationMode, title:"Market",description: "Kindly complete the following details") // Pass progress as a binding

                ScrollView{

                    QuestionWithButtons(question: "Do the applicant's forecasted volumes make sense based on the capacity of the equipment?",answer: $siteQuestionData.areForecastedVolumesMakingSense)
            
                    PhotoCaptureButton(capturedImage: $siteQuestionData.otherIncomeSourcesProof,
                                       siteQuestionData: siteQuestionData,
                                       question: "Did you see proof of the applicant's other sources of income? Are those businesses operating well? Is it worth visiting those businesses?",
                                       imageStorage: $siteQuestionData.otherIncomeSourcesProof)
                    
                    
                    QuestionWithButtons(question: "Have you discussed the possibility that the applicant may decide to produce different products over the next three years?",answer: $siteQuestionData.potentialProductDiversification)
                    QuestionWithButtons(question: "Are there any other services (e.g. ploughing services) that the applicant is thinking about providing?",answer: $siteQuestionData.additionalServicesConsideration)


                
                    

                
                }
                Spacer ()
            
                
                CustomNavigationButton(destination: Character_Credit(), label: "Continue", backgroundColor: isFormComplete ? config.primaryColor : Color.gray)

                }
            }
            
        
    }
}


