//
//  FinancialData.swift
//  EFTA1
//
//  Created by Joshua on 4/10/24.
//

import SwiftUI

struct FinancialData: View {
    @State private var progress: CGFloat = 0.80 // Initial progress
    
    @State private var capturedImage: UIImage?

    @EnvironmentObject var config: AppConfig

    @EnvironmentObject var siteQuestionData : SiteDetailsDataHandler

    @Environment(\.presentationMode) var presentationMode
    
    var isFormComplete: Bool {
         siteQuestionData.areSchedulesCompleted != nil &&
        siteQuestionData.arePricesConsistent != nil &&
        siteQuestionData.areWagesDiscussed != nil &&
         siteQuestionData.isESGQuestionnaireCompleted != nil &&
        siteQuestionData.plansToDifferentiate != nil &&
        siteQuestionData.arePreRequisitesNoted != nil &&
        siteQuestionData.isPhotographicEvidenceTaken != nil


        
     }


    var body: some View {

        GeometryReader { geometry in
            
            
            VStack{
                ProgressBar(geometry: geometry, progress: $progress,presentationMode: presentationMode, title:"Financial Data",description: "Kindly complete the following details") // Pass progress as a binding

                ScrollView{

                    QuestionWithButtons(question: "Have you completed schedules for sales volumes, raw materials, direct costs, overheads, employment, agriculture (as relevant)?",answer: $siteQuestionData.areSchedulesCompleted)
                    QuestionWithButtons(question: "Are prices, volumes, yields etc. consistent with the information, if any, provided in the application form?", answer: $siteQuestionData.arePricesConsistent)
                    QuestionWithButtons(question: "Did you discuss wages of planned and existing permanent and casual employees?",answer: $siteQuestionData.areWagesDiscussed)
                    QuestionWithButtons(question: "Have you completed the ESG (environmental, social and governance) questionnaire?", answer:$siteQuestionData.isESGQuestionnaireCompleted)
                    QuestionWithButtons(question: "Have you asked how the customer plans to differentiate themselves from their competitors?",answer: $siteQuestionData.plansToDifferentiate)

                    QuestionWithButtons(question: "Have you noted down any pre-requisites that need to be added to the proposal?",answer: $siteQuestionData.arePreRequisitesNoted)

                    PhotoCaptureButton(capturedImage: $siteQuestionData.isPhotographicEvidenceTaken,
                                       siteQuestionData: siteQuestionData,
                                       question: "Has photographic evidence been taken where relevant (site, stock, assets, documentation, any items of concern)?",
                                       imageStorage: $siteQuestionData.isPhotographicEvidenceTaken)
                    
                    

                
                }
                Spacer ()
            
                CustomNavigationButton(destination: ImpactReporting1(), label: "Continue", backgroundColor: isFormComplete ? config.primaryColor : Color.gray)

                }
            }
            
        
    }
}

