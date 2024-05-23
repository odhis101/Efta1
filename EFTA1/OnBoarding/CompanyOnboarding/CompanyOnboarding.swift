//
//  IndividualOnboarding.swift
//  EFTA1
//
//  Created by Joshua on 4/2/24.
//

import SwiftUI

struct CompanyOnboarding: View {
    let questions = ["What is your favorite color?", "What is your pet's name?", "Where were you born?"]
        @State private var selectedQuestionIndex = 0
        @State private var isExpanded: Bool = false
        @State private var progress: CGFloat = 0.2 // Initial progress
        @State private var CompanyName:String=""
        @State private var TIN:String=""
        @State private var VRN:String=""
        @State private var PostalAddress:String=""
        @EnvironmentObject var onboardingData: CompanyOnboardingData
    

    @State private var selectedRegion: String? = nil
    @State private var selectedDistrict: String? = nil
    @State private var ward:String=""
    let locationData: [LocationData] = createLocationData()
    @State private var districtOptions: [String] = []

    @EnvironmentObject var config: AppConfig
    @Environment(\.presentationMode) var presentationMode


    
    var body: some View {
            GeometryReader { geometry in
                VStack {
                    
                    ProgressBar(geometry: geometry, progress: $progress,presentationMode: presentationMode, title:"Company onboarding",description: "KKindly collect the following information from the customer")
                
                    QuestionWithSmallTextField(question: "",placeholder:"Company name",selectedOption:$onboardingData.CompanyName)
                    QuestionWithSmallTextField(question: "",placeholder:"TIN",selectedOption:$onboardingData.TIN)
                    QuestionWithSmallTextField(question: "",placeholder:"VRN (optional)",selectedOption:$onboardingData.VRN)
                    QuestionWithSmallTextField(question: "",placeholder:"Postal Address",selectedOption:$onboardingData.postalAddress)
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

                    
                    Spacer()
                    
             
                    
                    CustomNavigationButton(destination: CompanyOnboarding2(), label: "Continue", backgroundColor: config.primaryColor)
                    
                    
                    
               
              
                    


        
        
        
        
                }
            }
        

    }
}

