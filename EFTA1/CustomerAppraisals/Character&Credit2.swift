//
//  Character&Credit.swift
//  EFTA1
//
//  Created by Joshua on 4/10/24.
//

import SwiftUI

struct Character_Credit2: View {
    @State private var progress: CGFloat = 0.2 // Initial progress
    
    @State private var capturedImage: UIImage?

    @EnvironmentObject var config: AppConfig

    @Environment(\.presentationMode) var presentationMode

    @ObservedObject var siteQuestionData = SiteDetailsDataHandler()
    var body: some View {

        GeometryReader { geometry in
            
            VStack{
                ProgressBar(geometry: geometry, progress: $progress,presentationMode: presentationMode, title:"Character & Credit",description: "Kindly complete the following details") // Pass progress as a binding

                ScrollView{

                    QuestionWithButtons(question: "Did you ask the customer what their top three challenges have been in the past?",answer: $siteQuestionData.topThreeChallenges)
                    QuestionWithButtons(question: "Have you asked about the typical customers, and why they use the applicant's business?",answer:$siteQuestionData.typicalApplicantsAndTheirBusinesses)
                    QuestionWithButtons(question: "Did you discuss the appropriate downpayment and product with the applicant based on your assessment of their business?",answer: $siteQuestionData.donwnPaymentDiscussion)
                    QuestionWithButtons(question: "Have you discussed with the applicant how they plan to pay for the downpayment?",answer: $siteQuestionData.donwnPaymentPaymentPlan)
                    QuestionWithButtons(question: "Did you check whether the applicant has any debtors, and how long these repayments have been outstanding?",answer:$siteQuestionData.applicantsDebtors)

                    QuestionWithButtons(question: "Have you asked how the customer plans to differentiate themselves from their competitors?",answer: $siteQuestionData.areEmployeesConsulted)

                
                    

                
                }
                Spacer ()
                /*
                NavigationLink(destination: FinancialData()){

                Text("Continue")
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height:40)
                    .background(config.primaryColor) // Gray background when profileImage is nil
                    .cornerRadius(8)
                    .padding(.horizontal)
                    }
                */
                CustomNavigationButton(destination: FinancialData(), label: "Continue", backgroundColor: config.primaryColor)

                }
            }
            
        
    }
}
