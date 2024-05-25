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

    @EnvironmentObject var config: AppConfig

    @Environment(\.presentationMode) var presentationMode
    var body: some View {

        GeometryReader { geometry in
            
            VStack{
                ProgressBar(geometry: geometry, progress: $progress,presentationMode: presentationMode, title:"Equipment",description: "Kindly complete the following details") // Pass progress as a binding
                    .padding(.bottom,10)

                ScrollView{

                   // QuestionWithButtons(question: "The end products or services are consistent with the appraisal")
                    //QuestionWithTextField(question: "Comments")
                 //   QuestionWithButtons(question: "There is sufficient customer demand.")
                    //QuestionWithTextField(question: "Comments")

        



                
                    

                
                }
                Spacer ()
                /*
                NavigationLink(destination: CustomerInformationSheet()){

                Text("Continue")
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height:40)
                    .background(config.primaryColor) // Gray background when profileImage is nil
                    .cornerRadius(8)
                    .padding(.horizontal)

                }
                */
                CustomNavigationButton(destination: CustomerInformationSheet(), label: "Continue", backgroundColor: config.primaryColor)
            }
            }
            
      

    }

}




struct BusinessPerformance_Previews: PreviewProvider {
    static var previews: some View {
        BusinessPerformance()
            .environmentObject(AppConfig(region: .efken))
            .environmentObject(PinHandler())
    }
}
