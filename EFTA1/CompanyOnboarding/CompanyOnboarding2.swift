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
        @State private var progress: CGFloat = 0.5 // Initial progress
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
                    ScrollView{
                        ProgressBar(geometry: geometry, progress: $progress,presentationMode: presentationMode, title:"Company onboarding",description: "KKindly collect the following information from the customer")

                    QuestionWithSmallTextField(question: "",placeholder:"Contact person name",selectedOption:$CompanyName)
                    QuestionWithDropdown(question: "Type Of ID", options: ["Driving License", "Passport","National ID "], selectedOption: $IDtype)
                    QuestionWithSmallTextField(question: "Enter IDNumber", placeholder: "ID Number", selectedOption: $idNumber)
                    QuestionWithSmallTextField(question: "Phone Number", placeholder: "Phone Number", selectedOption: $phoneNumber)
                    QuestionWithSmallTextField(question: "Email Address", placeholder: "Email Address", selectedOption: $emailAddress)
                    

                    
                    QuestionWithDropdown(question: "Nationality ", options: locationData.map { $0.region }, selectedOption: $selectedRegion)
                                        .onChange(of: selectedRegion) { newValue in
                                            if let region = newValue, let data = locationData.first(where: { $0.region == region }) {
                                                districtOptions = data.districts
                                            } else {
                                                districtOptions = []
                                            }
                                            selectedDistrict = nil // Reset district when region changes
                                        }
                                    
                    QuestionWithSmallTextField(question: "Types Of Equipment",placeholder:"types of equipment",selectedOption:$TypesOfEquimpments)
                    QuestionWithSmallTextField(question: "Equipment price",placeholder:"Equipment price",selectedOption:$Equipmentprice)

                    }
                    Spacer()
                    
                    /*
                    NavigationLink(destination: CompanyLocation()) {
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
                    
                    CustomNavigationButton(destination: CompanyLocation(), label: "Continue", backgroundColor: config.primaryColor)
                    
                    
                    
                    
               
              
                    


        
        
        
        
                }
            }
        

    }
}

