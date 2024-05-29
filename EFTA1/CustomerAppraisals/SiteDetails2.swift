//
//  SiteDetails2.swift
//  EFTA1
//
//  Created by Joshua on 4/10/24.
//

import SwiftUI

struct SiteDetails2: View {
    @State private var progress: CGFloat = 0.08 // Initial progress
    
    @State private var capturedImage: UIImage?

    @EnvironmentObject var config: AppConfig

    @Environment(\.presentationMode) var presentationMode

    @EnvironmentObject var siteQuestionData : SiteDetailsDataHandler
    var isFormComplete: Bool {
         siteQuestionData.electricalFacilities != nil &&
        siteQuestionData.waterAndOtherFacilities != nil &&
        siteQuestionData.siteChangesRequired != nil &&
         siteQuestionData.experienceInMachinery != nil &&
         siteQuestionData.areCustomersOnSite != nil
     }
    
    var body: some View {
 

        GeometryReader { geometry in
            
            VStack{
                ProgressBar(geometry: geometry, progress: $progress,presentationMode: presentationMode, title:"Site Details",description: "Kindly collect the following information from the customer") // Pass progress as a binding

                ScrollView{
                PhotoCaptureButton(capturedImage: $siteQuestionData.electricalFacilities,
                                   siteQuestionData: siteQuestionData,
                                   question: "Are the required electricity facilities available? Are three phase power / other facilities required?",
                                   imageStorage: $siteQuestionData.electricalFacilities)
                    
                    
                    
                    
                PhotoCaptureButton(capturedImage: $siteQuestionData.waterAndOtherFacilities,
                                   siteQuestionData: siteQuestionData,
                                       question: "Are water and any other required facilities available??",
                                       imageStorage: $siteQuestionData.waterAndOtherFacilities)
                    
                PhotoCaptureButton(capturedImage: $siteQuestionData.siteChangesRequired,
                                   siteQuestionData: siteQuestionData,
                                       question: "Have you noted any site changes that will be required?",
                                       imageStorage: $siteQuestionData.siteChangesRequired)
                
                
                    QuestionWithTextField(question: "Does the applicant have enough experience with this kind of machinery before? If not, will they hire experienced people? Did you ask for copies of CVs or driving licenses of their employees, or copies of any relevant employee certificates?", answers:$siteQuestionData.experienceInMachinery)
                
                    QuestionWithButtons(question: "Did you see any customers on site?", answer:$siteQuestionData.areCustomersOnSite)

                
                }
                Spacer ()
                CustomNavigationButton(destination: Document_Assets(), label: "Continue", backgroundColor: isFormComplete ? config.primaryColor : Color.gray)
            }
        }
            
        }

    }


