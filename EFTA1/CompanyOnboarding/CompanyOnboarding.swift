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
        @State private var progress: CGFloat = 0.5 // Initial progress
        @State private var CompanyName:String=""
        @State private var TIN:String=""
        @State private var VRN:String=""
        @State private var PostalAddress:String=""

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

                    QuestionWithSmallTextField(question: "",placeholder:"Company name",selectedOption:$CompanyName)
                    QuestionWithSmallTextField(question: "",placeholder:"TIN",selectedOption:$TIN)
                    QuestionWithSmallTextField(question: "",placeholder:"VRN (optional)",selectedOption:$VRN)
                    QuestionWithSmallTextField(question: "",placeholder:"Postal Address",selectedOption:$PostalAddress)

                    
                    QuestionWithDropdown(question: "Region", options: locationData.map { $0.region }, selectedOption: $selectedRegion)
                                        .onChange(of: selectedRegion) { newValue in
                                            if let region = newValue, let data = locationData.first(where: { $0.region == region }) {
                                                districtOptions = data.districts
                                            } else {
                                                districtOptions = []
                                            }
                                            selectedDistrict = nil // Reset district when region changes
                                        }
                                    
                    QuestionWithDropdown(question: "District", options: districtOptions, selectedOption: $selectedDistrict)
                    
                    QuestionWithSmallTextField(question: "Ward", placeholder:"Enter Respective Ward ",selectedOption:$ward)

                    
                    Spacer()
                    
                    /*
                    NavigationLink(destination: CompanyOnboarding2()) {
                        Text("Continue")
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height:50)
                            .background(config.primaryColor) // Gray background when profileImage is nil
                            .cornerRadius(8)
                            .padding(.horizontal)
                            .padding(.vertical)

                    }
                     */
                    
                    CustomNavigationButton(destination: CompanyOnboarding2(), label: "Continue", backgroundColor: config.primaryColor)
                    
                    
                    
               
              
                    


        
        
        
        
                }
            }
        

    }
}

