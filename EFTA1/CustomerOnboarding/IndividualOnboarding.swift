//
//  IndividualOnboarding.swift
//  EFTA1
//
//  Created by Joshua on 4/2/24.
//

import SwiftUI

struct IndividualOnboarding: View {
    @State private var progress: CGFloat = 0.5 // Initial progress
    @EnvironmentObject var onboardingData: OnboardingData

    let questions = ["What is your favorite color?", "What is your pet's name?", "Where were you born?"]
        let locationData: [LocationData] = createLocationData()
        @State private var districtOptions: [String] = []

    var body: some View {
            GeometryReader { geometry in
                VStack {
                    ProgressBar(geometry: geometry, progress: $progress,title:onboardingData.titleForCustomerOnboarding ,description: "Kindly collect the following information from the customer")
                        .padding(.trailing, 20)

                  
                    ScrollView{
                        QuestionWithSmallTextField(question: "Enter Name", placeholder: "Name", selectedOption: $onboardingData.name)
                        QuestionWithSmallTextField(question: "Enter ID Number", placeholder: "ID Number", selectedOption: $onboardingData.idNumber)
                        QuestionWithDropdown(question: "Gender", options: ["Male", "Female"], selectedOption: $onboardingData.gender)
                        QuestionWithDropdown(question: "Marital Status", options: ["Married", "Single"], selectedOption: $onboardingData.maritalStatus)
                        QuestionWithSmallTextField(question: "Postal Address", placeholder: "Postal Address", selectedOption: $onboardingData.postalAddress)
                        QuestionWithDropdown(question: "Region", options: locationData.map { $0.region }, selectedOption: $onboardingData.selectedRegion)
                           .onChange(of: onboardingData.selectedRegion) { newValue in
                               if let region = newValue, let data = locationData.first(where: { $0.region == region }) {
                                   onboardingData.districtOptions = data.districts
                               } else {
                                   onboardingData.districtOptions = []
                               }
                               onboardingData.selectedDistrict = nil // Reset district when region changes
                           }
                        QuestionWithDropdown(question: "District", options: onboardingData.districtOptions, selectedOption: $onboardingData.selectedDistrict)
                        QuestionWithSmallTextField(question: "Ward", placeholder: "Enter Respective Ward", selectedOption: $onboardingData.ward)
                                }
                    Spacer()
                    
                    
                    NavigationLink(destination: CapturePhoto()) {
                        Text("Continue")
                            .foregroundColor(.white)
                            .cornerRadius(8)
                            .frame(height:40)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.green) // Set background color to green when enabled, gray when disabled

                    }
                    
                    
                    
               
              
                    


        
        
        
        
                
            }
        }        

    }
}

