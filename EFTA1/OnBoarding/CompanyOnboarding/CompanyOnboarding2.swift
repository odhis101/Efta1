//
//  IndividualOnboarding.swift
//  EFTA1
//
//  Created by Joshua on 4/2/24.
//

import SwiftUI

struct CompanyOnboarding2: View {
    let questions = ["What is your favorite color?", "What is your pet's name?", "Where were you born?"]
    @State private var selectedQuestionIndex = 0
    @State private var isExpanded: Bool = false
    @State private var progress: CGFloat = 0.4 // Initial progress
    @State private var CompanyName:String=""
    @State private var TIN:String=""
    @State private var VRN:String=""
    @State private var PostalAddress:String=""
    @State var IDtype: String? = nil
    @State private var idNumber:String=""
    @State private var phoneNumber:String = ""
    @State private var emailAddress:String = ""
    @State var stateOfEquipment:String? = nil
    @State private var TypesOfEquimpments:String=""
    @State private var Equipmentprice:String=""
    @EnvironmentObject var onboardingData: CompanyOnboardingData
    @EnvironmentObject var StolenonboardingData: OnboardingData
    @State private var selectedRegion: String? = nil
    @State private var selectedDistrict: String? = nil
    @State private var ward:String=""
    let locationData: [LocationData] = createLocationData()
    @State private var districtOptions: [String] = []
    @EnvironmentObject var config: AppConfig
    @Environment(\.presentationMode) var presentationMode
    let nationality : [String] = createNationalities()
    
    
    var isFormComplete: Bool {
        !onboardingData.contactPersonName.isEmpty &&
        !(onboardingData.idType ?? "").isEmpty &&
        !onboardingData.idNumber.isEmpty &&
        !(onboardingData.phoneNumber ?? "").isEmpty &&
        !(onboardingData.emailAddress ?? "").isEmpty &&
        !(onboardingData.nationality ?? "").isEmpty &&
        !(onboardingData.typeOfEquipment ?? "").isEmpty &&
        !(onboardingData.priceOfEquipment ?? "").isEmpty 

    }

    

    
    var body: some View {
            GeometryReader { geometry in
                VStack {
                    ScrollView{
                        ProgressBar(geometry: geometry, progress: $progress,presentationMode: presentationMode, title:StolenonboardingData.titleForCustomerOnboarding ,description: "Kindly collect the following information from the customer")

                        QuestionWithSmallTextField(question: "Contact person name", placeholder: "Contact person name", selectedOption: $onboardingData.contactPersonName)
                        QuestionWithDropdown(question: "Type Of ID", options: ["NATIONAL_ID", "PASSPORT"], selectedOption: $onboardingData.idType)
                        
                        QuestionWithSmallTextField(question: "Enter \(onboardingData.idType ?? "National_ID") Number", placeholder: "\(onboardingData.idType ?? "National_ID") Number", selectedOption: $onboardingData.idNumber)
                        QuestionWithSmallTextField(question: "Phone Number", placeholder: "Phone Number", selectedOption: $onboardingData.phoneNumber)
                        QuestionWithSmallTextField(question: "Email", placeholder: "Email address", selectedOption: $onboardingData.emailAddress)
                        QuestionWithDropdown(question: "Nationality ", options: nationality,selectedOption:$onboardingData.nationality)
                        QuestionWithSmallTextField(question: "Types Of Equipment", placeholder: "Types of equipment", selectedOption: $onboardingData.typeOfEquipment)
                        QuestionWithSmallTextField(question: "Equipment price", placeholder: "Equipment price", selectedOption: $onboardingData.priceOfEquipment)
                        
                    }
                    Spacer()
                    
                    
                    CustomNavigationButton(destination: CompanyLocation(), label: "Continue", backgroundColor: isFormComplete ? config.primaryColor : Color.gray)
                    
                    
                    
                    
               
              
                    


        
        
        
        
                }
            }
        

    }
}

