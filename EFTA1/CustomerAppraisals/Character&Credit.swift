//
//  Character&Credit.swift
//  EFTA1
//
//  Created by Joshua on 4/10/24.
//

import SwiftUI

struct Character_Credit: View {
    @State private var progress: CGFloat = 0.56 // Initial progress
    
    @State private var capturedImage: UIImage?
    @EnvironmentObject var config: AppConfig

    
    @EnvironmentObject var siteQuestionData : SiteDetailsDataHandler
    @Environment(\.presentationMode) var presentationMode
    
    var isFormComplete: Bool {
         siteQuestionData.arePhoneNumbersAndReferencesCollected != nil &&
        siteQuestionData.isCreditDisputeDiscussed != nil &&
        siteQuestionData.isCreditInfoSearchConducted != nil &&
         siteQuestionData.areExistingLoansReviewed != nil &&
        siteQuestionData.areNeighborsConsulted != nil

        
     }


    var body: some View {

        GeometryReader { geometry in
            
            VStack{
                ProgressBar(geometry: geometry, progress: $progress,presentationMode: presentationMode, title:"Character & Credit",description: "Kindly complete the following details") // Pass progress as a binding

                ScrollView{

                    QuestionWithButtons(question: "Did you get phone numbers and names for personal references and raw material suppliers?",answer: $siteQuestionData.arePhoneNumbersAndReferencesCollected)
                    QuestionWithButtons(question: "Did you ask about any outstanding credit disputes and did you mention we will be checking CreditInfo?",answer: $siteQuestionData.isCreditDisputeDiscussed)
                    QuestionWithButtons(question: "Has a CreditInfo search bee undertaken and do you have any questions arising from this for the applicant?",answer: $siteQuestionData.isCreditInfoSearchConducted)
                    QuestionWithButtons(question: "Have you confirmed who are the key competitors, where they are located, whether there is any risk of over-supply / too much competition in the local area?",answer: $siteQuestionData.areExistingLoansReviewed)
                    QuestionWithButtons(question: "Did you speak with neighbors (can help with verification of key data, further character references, highlighting any issues)?",answer: $siteQuestionData.areNeighborsConsulted)

              

                
                    

                
                }
                Spacer ()
           
                
                CustomNavigationButton(destination: Character_Credit2(), label: "Continue", backgroundColor: isFormComplete ? config.primaryColor : Color.gray)

                }
            }
            
        
    }
}
