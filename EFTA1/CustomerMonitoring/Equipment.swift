//
//  Equipment.swift
//  EFTA1
//
//  Created by Joshua on 4/10/24.
//

import SwiftUI

struct Equipment: View {
    @State private var progress: CGFloat = 0.2 // Initial progress
    
    @State private var capturedImage: UIImage?

    @EnvironmentObject var config: AppConfig

    
    @ObservedObject var siteQuestionData = SiteQuestionDataHandler()
    
    @Environment(\.presentationMode) var presentationMode

    var body: some View {

        GeometryReader { geometry in
            
            VStack{
                ProgressBar(geometry: geometry, progress: $progress,presentationMode: presentationMode, title:"Equipment",description: "Kindly complete the following details") // Pass progress as a binding
                    .padding(.bottom,10)

                ScrollView{

                    QuestionWithButtons(question: "Did you see the asset?")
                    QuestionWithTextField(question: "Comments")
                    
                    QuestionWithButtons(question: "Have you asked about the typical customers, and why they use the applicant's business?")
                    
                    QuestionWithDate(question: "Date to see the equipment?")
                    
                    QuestionWithButtons(question: "Was the serial number attached?")
                    
                    
                    QuestionWithButtons(question: "Equipment seen operating")
                    // we need to make a proper dropdown thingy


                    QuestionWithButtons(question: "Service on the equipment is acceptable?")
                    QuestionWithButtons(question: "Is the GPS tracker working?")
                    QuestionWithButtons(question: "The equipment has insurance?")
                    QuestionWithDate(question: "Date insurance ends")




                
                    

                
                }
                Spacer ()
                /*
                NavigationLink(destination: BusinessPerformance()){

                Text("Continue")
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height:40)
                    .background(config.primaryColor) // Gray background when profileImage is nil
                    .cornerRadius(8)
                    .padding(.horizontal)
                    
                }
                 
                 */
                CustomNavigationButton(destination: BusinessPerformance(), label: "Continue", backgroundColor: config.primaryColor)
                

                }
            

            }


        
    }

}

struct Equipment_Previews: PreviewProvider {
    static var previews: some View {
        Equipment()
            .environmentObject(AppConfig(region: .efken))
            .environmentObject(PinHandler())
    }
}
