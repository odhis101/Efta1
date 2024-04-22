//
//  RepossesionPickUp.swift
//  EFTA1
//
//  Created by Joshua on 4/12/24.
//

import SwiftUI
import SwiftUIDigitalSignature  // Ensure you import the package

struct RepossesionPickUp: View {
    @State private var progress: CGFloat = 0.5 // Initial progress
    
    @State private var capturedImage: UIImage?
    
    
    @State private var signature: UIImage?
    
    @State private var image: UIImage?

    @EnvironmentObject var config: AppConfig


    var body: some View {

        GeometryReader { geometry in
            
            VStack{
                ProgressBar(geometry: geometry, progress: $progress,title:"Repossesions Pick UP",description: "Kindly complete the following details") // Pass progress as a binding
                    .padding(.trailing,20)
                    .padding(.bottom,10)

                ScrollView{

                    QuestionWithButtons(question: "Did you see the asset?")
                    //QuestionWithDropdown(question: "What is the condition of the equipment?", options: ["Option 1", "Option 2", "Option 3"])
                    QuestionWithTextField(question: "Comments about Condition of Equipment")
                    
                    QuestionWithButtons(question: "Customer Interviewed?")
                    
                    
                    QuestionWithTextField(question: "Comments about Condition of Equipment")

                    QuestionWithTextField(question: "Notes from Customer Interview, if Held")
                    
                    SignatureCaptureField(signatureImage: $signature)
                         .padding()
                    
                    PhotoCaptureField(image: $image)
                        .padding()
                    

                
                }
                Spacer ()
                NavigationLink(destination: RepossesionsStorage()){

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
