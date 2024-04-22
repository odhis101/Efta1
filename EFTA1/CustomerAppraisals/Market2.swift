//
//  Market2.swift
//  EFTA1
//
//  Created by Joshua on 4/10/24.
//

import SwiftUI

struct Market2: View {
    @State private var progress: CGFloat = 0.2 // Initial progress
    
    @State private var capturedImage: UIImage?

    @EnvironmentObject var config: AppConfig

    @ObservedObject var siteQuestionData = SiteQuestionDataHandler()
    var body: some View {

        GeometryReader { geometry in
            
            VStack{
                ProgressBar(geometry: geometry, progress: $progress,title:"Market",description: "Kindly complete the following details") // Pass progress as a binding
                    .padding(.trailing,20)

                ScrollView{

                    QuestionWithButtons(question: "If the sector is not familiar to EFTA, did you discuss the processes involved in production in detail?")
                    QuestionWithButtons(question: "Have you asked about the typical customers, and why they use the applicant's business?")
                    QuestionWithButtons(question: "Have you checked who are the applicant's top three customers (will these cover a high enough % of projected sales, or will we need more than 3)?")
                    QuestionWithButtons(question: "Have you confirmed who are the key competitors, where they are located, whether there is any risk of over-supply / too much competition in the local area?")
                    QuestionWithButtons(question: "Have you asked how the customer plans to differentiate themselves from their competitors?")


                
                    

                
                }
                Spacer ()
                NavigationLink(destination: Market3()){
                Text("Continue")
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height:40)
                    .background(config.primaryColor) // Gray background when profileImage is nil
                    .cornerRadius(8)
                    .padding(.horizontal)
                    
                
                }
                }
            }
            
        
    }
}

