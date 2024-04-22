//
//  ImpactReporting.swift
//  EFTA1
//
//  Created by Joshua on 4/10/24.
//

import SwiftUI

struct ImpactReporting1: View {
    @State private var progress: CGFloat = 1 // Initial progress
    @State private var capturedImage: UIImage?
    @ObservedObject var siteQuestionData = SiteQuestionDataHandler()
    @State private var CurrentMonthlyWage:String=""
    @State private var CurrentDailyWage:String=""
    @State private var RevenueLastMonth:String=""
    @State private var RevenueNexttMonth:String=""
    @State private var showingConfirmation = false // State for showing the confirmation dialog
    @State private var navigateToDashboard = false


    @EnvironmentObject var config: AppConfig



    var body: some View {

        GeometryReader { geometry in
            
            VStack{
                ProgressBar(geometry: geometry, progress: $progress,title:"Impact Reporting ",description: "Kindly complete the following details") // Pass progress as a binding
                    .padding(.trailing,20)

                ScrollView{
                    QuestionWithSmallTextField(question: "Number of emploees",placeholder:"Enter Number",selectedOption: $CurrentMonthlyWage)
                    QuestionWithSmallTextField(question: "Number of Permanent female employees",placeholder:"Enter Number",selectedOption: $CurrentDailyWage)
                    QuestionWithSmallTextField(question: "Number of casual male employees",placeholder:"Enter Number",selectedOption: $RevenueLastMonth)
                    QuestionWithSmallTextField(question: "Revenues this month",placeholder:"Enter Number",selectedOption: $CurrentMonthlyWage)
                    QuestionWithSmallTextField(question: "Days employed per month by casuals",placeholder:"Enter Number Of days",selectedOption: $RevenueNexttMonth)
                    QuestionWithButtons(question: "Health benefits for permanent emlpoyees")


                    //QuestionWithSmallTextField(question: "Enter ID Number",placeholder:"ID Numher",selectedOption:$IDNumber)

                    

                    NavigationLink(destination: ImpactReporting(), isActive: $navigateToDashboard) {
                                        EmptyView()
                }
                    
                Spacer ()

             
                    Button("Continue") {
                        navigateToDashboard = true
                    }
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
                    .background(config.primaryColor)
                    .cornerRadius(20)
                    .padding()

                }
            }
            
        }


    }
     
}

