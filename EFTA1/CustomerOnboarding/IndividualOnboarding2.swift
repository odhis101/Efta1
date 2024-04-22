//
//  IndividualOnboarding.swift
//  EFTA1
//
//  Created by Joshua on 4/2/24.
//

import SwiftUI

struct IndividualOnboarding2: View {
        let nationality : [String] = createNationalities()
        @EnvironmentObject var onboardingData: OnboardingData
        @State private var progress: CGFloat = 0.5 // Initial progress
    @EnvironmentObject var config: AppConfig


    var body: some View {
            GeometryReader { geometry in
                VStack {
                    ProgressBar(geometry: geometry, progress: $progress,title: onboardingData.titleForCustomerOnboarding ,description: "Kindly collect the following information from the customer")
                        .padding(.trailing, 20)

                  
                    ScrollView{
                        //QuestionWithSmallTextField(question: "Customer Name",placeholder:"Name")
                        QuestionWithDropdown(question: "Nationality ", options: nationality,selectedOption:$onboardingData.nationalityState)
                        QuestionWithSmallTextField(question: "Email",placeholder:"Email address",selectedOption:$onboardingData.EmailAddress)
                        QuestionWithSmallTextField(question: "Phone Number",placeholder:"Phone Number",selectedOption:$onboardingData.PhoneNumber)
                        QuestionWithSmallTextField(question: "TIN",placeholder:"TIN",selectedOption:$onboardingData.TIN)
                        QuestionWithSmallTextField(question: "Types Of Equipment",placeholder:"types of equipment",selectedOption:$onboardingData.TypesOfEquimpments)
                        QuestionWithSmallTextField(question: "Equipment price",placeholder:"Equipment price",selectedOption:$onboardingData.Equipmentprice)



                    }
                    Spacer()
                    
                    
                    NavigationLink(destination: CapturePhoto()) {

                    Text("Continue")
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height:50)
                        .background(config.primaryColor) // Gray background when profileImage is nil
                        .cornerRadius(8)
                        .padding(.horizontal)
                        .padding(.vertical)
                    }
                    
                    
                    
               
              
                    


        
        
        
        
                
            }
        }

    }
}

