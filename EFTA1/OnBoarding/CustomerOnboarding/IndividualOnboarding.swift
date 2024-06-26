//
//  IndividualOnboarding.swift
//  EFTA1
//
//  Created by Joshua on 4/2/24.
//

import SwiftUI

struct IndividualOnboarding: View {
    @State private var progress: CGFloat = 0.28 // Initial progress
    @EnvironmentObject var onboardingData: OnboardingData
    @EnvironmentObject var config: AppConfig
    @Environment(\.presentationMode) var presentationMode

    let questions = ["What is your favorite color?", "What is your pet's name?", "Where were you born?"]
        let locationData: [LocationData] = createLocationData()
        @State private var districtOptions: [String] = []
    
    // Computed property to check if all required fields are filled
       var isFormComplete: Bool {
           !onboardingData.customerName.isEmpty &&
           !(onboardingData.idType ?? "").isEmpty &&
           !onboardingData.idNumber.isEmpty &&
           !(onboardingData.gender ?? "").isEmpty &&
           !(onboardingData.maritalStatus ?? "").isEmpty &&
           !onboardingData.postalAddress.isEmpty &&
           !(onboardingData.region ?? "").isEmpty &&
           !(onboardingData.district ?? "").isEmpty &&
           !onboardingData.ward.isEmpty
       }

    var body: some View {
            GeometryReader { geometry in
                VStack {
                    ProgressBar(geometry: geometry, progress: $progress,presentationMode: presentationMode, title:onboardingData.titleForCustomerOnboarding ,description: "Kindly collect the following information from the customer")

                  
                    ScrollView{
                        
                        QuestionWithSmallTextField(question: "Customer Name", placeholder: "Customer Name", selectedOption: $onboardingData.customerName)
                        QuestionWithDropdown(question: "Type Of ID", options: ["NATIONAL_ID", "PASSPORT"], selectedOption: $onboardingData.idType)
                        QuestionWithSmallTextField(question: "Enter \(onboardingData.idType ?? "National_ID")  Number", placeholder: "ID Number", selectedOption: $onboardingData.idNumber)
                        QuestionWithDropdown(question: "Gender", options: ["MALE", "FEMALE"], selectedOption: $onboardingData.gender)
                        QuestionWithDropdown(question: "Marital Status", options: ["SINGLE", "MARRIED","DIVORCED","WIDOWED"], selectedOption: $onboardingData.maritalStatus)
                        QuestionWithSmallTextField(question: "Postal Address", placeholder: "Postal Address", selectedOption: $onboardingData.postalAddress)
                        QuestionWithDropdown(question: "Region", options: locationData.map { $0.region }, selectedOption: $onboardingData.region)
                            .onChange(of: onboardingData.region) { newValue in
                                if let region = newValue, let data = locationData.first(where: { $0.region == region }) {
                                    onboardingData.districtOptions = data.districts
                                } else {
                                    onboardingData.districtOptions = []
                                }
                                onboardingData.district = nil // Reset district when region changes
                            }
                        QuestionWithDropdown(question: "District", options: onboardingData.districtOptions, selectedOption: $onboardingData.district)
                        QuestionWithSmallTextField(question: "Ward", placeholder: "Enter Respective Ward", selectedOption: $onboardingData.ward)

                        
                            }
 
 
                    Spacer()
                                        
                    CustomNavigationButton(destination: IndividualOnboarding2(), label: "Continue",backgroundColor: isFormComplete ? config.primaryColor : Color.gray)

                    
                    
                    
               
              
                    


        
        
        
        
                
            }
        }        

    }
}

