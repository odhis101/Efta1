//
//  SiteDetails2.swift
//  EFTA1
//
//  Created by Joshua on 4/10/24.
//

import SwiftUI

struct SiteDetails2: View {
    @State private var progress: CGFloat = 0.2 // Initial progress
    
    @State private var capturedImage: UIImage?

    @EnvironmentObject var config: AppConfig
    @EnvironmentObject var customerApraisalData : CustomerApraisalData

    @Environment(\.presentationMode) var presentationMode

    @ObservedObject var siteQuestionData = SiteQuestionDataHandler()
    var body: some View {
 

        GeometryReader { geometry in
            
            VStack{
                ProgressBar(geometry: geometry, progress: $progress,presentationMode: presentationMode, title:"Site Details",description: "Kindly collect the following information from the customer") // Pass progress as a binding

                ScrollView{
                PhotoCaptureButton(capturedImage: $capturedImage,
                                   SiteQuestionData: siteQuestionData,
                                   question: "Are the required electricity facilities available? Are three phase power / other facilities required?",
                                   imageStorage: $siteQuestionData.profileImage)
                    
                PhotoCaptureButton(capturedImage: $capturedImage,
                                       SiteQuestionData: siteQuestionData,
                                       question: "Are water and any other required facilities available??",
                                       imageStorage: $siteQuestionData.profileImage)
                    
                PhotoCaptureButton(capturedImage: $capturedImage,
                                       SiteQuestionData: siteQuestionData,
                                       question: "Have you noted any site changes that will be required?",
                                       imageStorage: $siteQuestionData.profileImage)
                
                
                QuestionWithTextField(question: "Does the applicant have enough experience with this kind of machinery before? If not, will they hire experienced people? Did you ask for copies of CVs or driving licenses of their employees, or copies of any relevant employee certificates?")
                
                    QuestionWithButtons(question: customerApraisalData.name)

                
                }
                Spacer ()
                /*
                NavigationLink(destination: Document_Assets()){

                Text("Continue")
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height:40)
                    .background(config.primaryColor) // Gray background when profileImage is nil
                    .cornerRadius(8)
                    .padding(.horizontal)

                
            }
                 */
                CustomNavigationButton(destination: Document_Assets(), label: "Continue", backgroundColor: config.primaryColor)
            }
        }
            
        }

    }


