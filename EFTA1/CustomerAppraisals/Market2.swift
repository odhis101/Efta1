//
//  Market2.swift
//  EFTA1
//
//  Created by Joshua on 4/10/24.
//

import SwiftUI

struct Market2: View {
    @State private var progress: CGFloat = 0.2 // Initial progress
    
    @State private var capturedImage: UIImage?

    @EnvironmentObject var config: AppConfig

    @ObservedObject var siteQuestionData = SiteDetailsDataHandler()
    
    @Environment(\.presentationMode) var presentationMode

    var body: some View {

        GeometryReader { geometry in
            
            VStack{
                ProgressBar(geometry: geometry, progress: $progress,presentationMode: presentationMode, title:"Market",description: "Kindly complete the following details") // Pass progress as a binding

                ScrollView{

                    QuestionWithButtons(question: "Did you get an understanding of long it usually takes the applicant to sell their products or services after production?",answer: $siteQuestionData.isApplicantUnderstandingProductSalesTime)
                    QuestionWithButtons(question: "Have you checked to what extent the applicant is reliant on government related customers?",answer:$siteQuestionData.isApplicantReliantOnGovernmentCustomers)
                    QuestionWithButtons(question: "Have you checked whether the applicant sells all of their products at once, as soon as they produce them? Or whether they sell themthroughout the year?",answer: $siteQuestionData.isApplicantSellingProductsAtOnce)
                    QuestionWithButtons(question: "Have you discussed any seasonality that might impact the business? Have these also been factored into the volumes in the financial schedules?",answer: $siteQuestionData.isApplicantSellingThroughoutYear)
                    
                    QuestionWithButtons(question: "Have you asked how the customer plans to differentiate themselves from their competitors?",answer:$siteQuestionData.isSeasonalityImpactingBusiness)


                
                    

                
                }
                Spacer ()
                /*
                NavigationLink(destination: Market3()){
                Text("Continue")
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height:40)
                    .background(config.primaryColor) // Gray background when profileImage is nil
                    .cornerRadius(8)
                    .padding(.horizontal)
                    
                
                }
                */
                
                CustomNavigationButton(destination: Market3(), label: "Continue", backgroundColor: config.primaryColor)
                }
            }
            
        
    }
}

