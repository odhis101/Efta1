//
//  SiteDetails.swift
//  EFTA1
//
//  Created by Joshua on 4/10/24.
//

import SwiftUI

struct SiteDetails: View {
    @State private var progress: CGFloat = 0.2 // Initial progress
    
    @State private var capturedImage: UIImage?

    @EnvironmentObject var config: AppConfig

    @ObservedObject var siteQuestionData = SiteDetailsDataHandler()
    @Environment(\.presentationMode) var presentationMode
    

    var body: some View {

        GeometryReader { geometry in
            
            VStack{
                ProgressBar(geometry: geometry, progress: $progress,presentationMode: presentationMode, title:"Site Details",description: "Kindly collect the following information from the customer") // Pass progress as a binding

                ScrollView{
                    
                
                
                    PhotoCaptureButton(capturedImage: $siteQuestionData.fullDescriptionOfSite,
                                       siteQuestionData: siteQuestionData,
                                       question: "Has a full description of the site been noted (number of buildings / warehouses / acreage etc)?",
                                       imageStorage: $siteQuestionData.fullDescriptionOfSite)

                    QuestionWithButtons(question: "Did you get confirmation as to whether the applicant owns the land themselves?", answer: $siteQuestionData.isLandOwnershipConfirmed)
                    
                    QuestionWithSmallTextField(question: " Customer Phone Number",placeholder:"Phone  Number",selectedOption:$siteQuestionData.customerPhoneNumber)


                    QuestionWithTextField(question: "If land is rented, did you discuss how long the applicant has rented their site for, any risks of not renewing the rental agreement, how often the applicant has to pay their rent?", answers: $siteQuestionData.landRentingDetails)

                    PhotoCaptureButton(capturedImage: $siteQuestionData.deliveryChallenges,
                                       siteQuestionData: siteQuestionData,
                                       question: "Will there be any challenges in delivery / installation of the equipment (stairs, narrow doorways, inadequate space etc)?",
                                       imageStorage: $siteQuestionData.deliveryChallenges)

                    PhotoCaptureButton(capturedImage: $siteQuestionData.securityArrangements,
                                       siteQuestionData: siteQuestionData,
                                       question: "Are the security arrangements for the equipment satisfactory (daytime & nighttime arrangements, guards, locks etc)?",
                                       imageStorage: $siteQuestionData.securityArrangements)

                    
                }
                Spacer ()
                
                CustomNavigationButton(destination: SiteDetails2(), label: "Continue", backgroundColor: config.primaryColor)
                

                }
            }
            
        
    }
}








