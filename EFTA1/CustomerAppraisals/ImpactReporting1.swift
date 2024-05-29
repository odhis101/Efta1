//
//  ImpactReporting.swift
//  EFTA1
//
//  Created by Joshua on 4/10/24.
//

import SwiftUI

struct ImpactReporting1: View {
    @State private var progress: CGFloat = 0.9 // Initial progress
    @State private var capturedImage: UIImage?
    @EnvironmentObject var siteQuestionData : SiteDetailsDataHandler
    @State private var CurrentMonthlyWage:String=""
    @State private var CurrentDailyWage:String=""
    @State private var RevenueLastMonth:String=""
    @State private var RevenueNexttMonth:String=""
    @State private var showingConfirmation = false // State for showing the confirmation dialog
    @State private var navigateToDashboard = false

    @Environment(\.presentationMode) var presentationMode

    @EnvironmentObject var config: AppConfig
    var isFormComplete: Bool {
         siteQuestionData.numberOfPermanentMaleEmployees != nil &&
        siteQuestionData.numberOfPermanentFemaleEmployees != nil &&
        siteQuestionData.numberOfCasualMaleEmployees != nil &&
         siteQuestionData.numberOfCasualFemaleEmployees != nil &&
        siteQuestionData.daysEmployedPerMonthByCasuals != nil &&
        siteQuestionData.daysEmployedPerMonthByCasuals != nil
        
     }



    var body: some View {

        GeometryReader { geometry in
            
            VStack{
                ProgressBar(geometry: geometry, progress: $progress,presentationMode: presentationMode, title:"Impact Reporting ",description: "Kindly complete the following details") // Pass progress as a binding

                ScrollView{
                    QuestionWithSmallTextField(question: "Number of emploees",placeholder:"Enter Number",selectedOption: $siteQuestionData.numberOfPermanentMaleEmployees)
                    QuestionWithSmallTextField(question: "Number of Permanent female employees",placeholder:"Enter Number",selectedOption: $siteQuestionData.numberOfPermanentFemaleEmployees)
                    QuestionWithSmallTextField(question: "Number of casual male employees",placeholder:"Enter Number",selectedOption: $siteQuestionData.numberOfCasualMaleEmployees)
                    QuestionWithSmallTextField(question: "Number of casual female employees ",placeholder:"Enter Number",selectedOption: $siteQuestionData.numberOfCasualFemaleEmployees)
                    
                    QuestionWithSmallTextField(question: "Revenues this month",placeholder:"Enter Number",selectedOption: $siteQuestionData.daysEmployedPerMonthByCasuals)
                    QuestionWithSmallTextField(question: "Days employed per month by casuals",placeholder:"Enter Number Of days",selectedOption: $siteQuestionData.daysEmployedPerMonthByCasuals)
                    QuestionWithButtons(question: "Health benefits for permanent emlpoyees",answer:$siteQuestionData.HealthInsurance)



                    

                
                    
                Spacer ()

                     
                    CustomNavigationButton(destination: ImpactReporting(), label: "Continue",backgroundColor: isFormComplete ? config.primaryColor : Color.gray)

                }
            }
            
        }


    }
     
}

