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
    @State private var progress: CGFloat = 0.42 // Initial progress
    @EnvironmentObject var config: AppConfig
    @Environment(\.presentationMode) var presentationMode
    
    // Computed property to check if all required fields are filled
       var isFormComplete: Bool {
           !(onboardingData.nationality ?? "").isEmpty &&
           !(onboardingData.emailAddress ?? "").isEmpty &&
           !onboardingData.phoneNumber.isEmpty &&
           !(onboardingData.tin ?? "").isEmpty &&
           !(onboardingData.typeOfEquipment ?? "").isEmpty &&
           !(onboardingData.priceOfEquipment ?? "").isEmpty
       }
    

    var body: some View {
            GeometryReader { geometry in
                VStack {
                    
                    ProgressBar(geometry: geometry, progress: $progress,presentationMode: presentationMode, title: onboardingData.titleForCustomerOnboarding ,description: "Kindly collect the following information from the customer")

                  
                    ScrollView{
                        //QuestionWithSmallTextField(question: "Customer Name",placeholder:"Name")
                        QuestionWithDropdown(question: "Nationality ", options: nationality,selectedOption:$onboardingData.nationality)
                        QuestionWithSmallTextField(question: "Email",placeholder:"Email address",selectedOption:$onboardingData.emailAddress)
                        QuestionWithSmallTextField(question: "Phone Number",placeholder:"Phone  Number",selectedOption:$onboardingData.phoneNumber)
                        QuestionWithSmallTextField(question: "TIN",placeholder:"TIN",selectedOption:$onboardingData.tin)
                        QuestionWithSmallTextField(question: "Types Of Equipment",placeholder:"types of equipment",selectedOption:$onboardingData.typeOfEquipment)
                        QuestionWithSmallTextField(question: "Equipment price",placeholder:"Equipment price",selectedOption:$onboardingData.priceOfEquipment)



                    }
                    Spacer()
                    
                    CustomNavigationButton(destination: CapturePhoto(), label: "Continue",backgroundColor: isFormComplete ? config.primaryColor : Color.gray)
                    
                    
                    
               
              
                    


        
        
        
        
                
            }
        }

    }
}

