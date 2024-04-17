//
//  BusinessPerformance.swift
//  EFTA1
//
//  Created by Joshua on 4/11/24.
//

import SwiftUI

struct BusinessPerformance: View {
    @State private var progress: CGFloat = 0.2 // Initial progress
    
    @State private var capturedImage: UIImage?

    
    @ObservedObject var siteQuestionData = SiteQuestionDataHandler()
    var body: some View {

        GeometryReader { geometry in
            
            VStack{
                ProgressBar(geometry: geometry, progress: $progress,title:"Equipment",description: "Kindly complete the following details") // Pass progress as a binding
                    .padding(.trailing,20)
                    .padding(.bottom,10)

                ScrollView{

                    QuestionWithButtons(question: "The end products or services are consistent with the appraisal")
                    QuestionWithTextField(question: "Comments")
                    QuestionWithButtons(question: "There is sufficient customer demand.")
                    QuestionWithTextField(question: "Comments")

        



                
                    

                
                }
                Spacer ()
                NavigationLink(destination: CustomerInformationSheet()){

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




