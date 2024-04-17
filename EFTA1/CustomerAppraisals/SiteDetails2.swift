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

    
    @ObservedObject var siteQuestionData = SiteQuestionDataHandler()
    var body: some View {
 

        GeometryReader { geometry in
            
            VStack{
                ProgressBar(geometry: geometry, progress: $progress,title:"Individual onboarding",description: "Kindly collect the following information from the customer") // Pass progress as a binding
                    .padding(.trailing,20)

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
                
                QuestionWithButtons(question: "Did you see any customers on site?")

                
                }
                Spacer ()
                NavigationLink(destination: Document_Assets()){

                Text("Continue")
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height:40)
                    .background(Color(hex: "#2AA241")) // Gray background when profileImage is nil
                    .cornerRadius(8)
                    .padding(.horizontal)

                
            }
            }
        }
            
        }

    }


