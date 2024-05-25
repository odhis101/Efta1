//
//  Market.swift
//  EFTA1
//
//  Created by Joshua on 4/10/24.
//

import SwiftUI

struct Market: View {
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

                    QuestionWithButtons(question: "If the sector is not familiar to EFTA, did you discuss the processes involved in production in detail?",answer: $siteQuestionData.isSectorNotFamiliarToEFTA)
                    
                    QuestionWithButtons(question: "Have you asked about the typical customers, and why they use the applicant's business?",answer: $siteQuestionData.areTypicalCustomersDiscussed)
                    
                    QuestionWithButtons(question: "Have you checked who are the applicant's top three customers (will these cover a high enough % of projected sales, or will we need more than 3)?",answer: $siteQuestionData.areTopThreeCustomersIdentified)
                    
                    QuestionWithButtons(question: "Have you confirmed who are the key competitors, where they are located, whether there is any risk of over-supply / too much competition in the local area?",answer: $siteQuestionData.areKeyCompetitorsConfirmed)
                    
                    QuestionWithButtons(question: "Have you asked how the customer plans to differentiate themselves from their competitors?", answer: $siteQuestionData.isDifferentiationStrategyDiscussed)
                    
                    QuestionWithButtons(question: "Have you confirmed the credit terms the applicant receives from suppliers and gives to customers?",answer: $siteQuestionData.areCreditTermsConfirmed)


                
                    

                
                }
                Spacer ()
                /*
                NavigationLink(destination: Market2()){

                Text("Continue")
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height:40)
                    .background(config.primaryColor) // Gray background when profileImage is nil
                    .cornerRadius(8)
                    .padding(.horizontal)
                    }
                 */
                CustomNavigationButton(destination: Market2(), label: "Continue", backgroundColor: config.primaryColor)
                

                }
            }
            
        
    }
}

