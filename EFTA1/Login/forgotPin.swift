//
//  forgotPin.swift
//  EFTA1
//
//  Created by Joshua on 3/28/24.
//

import SwiftUI

struct forgotPin: View {
    @State private var answer1: String = ""
    @EnvironmentObject var config: AppConfig


    var body: some View {
        GeometryReader { geometry in
            VStack{
                /*
                LogoAndTitleView(geometry: geometry, title: "Forgot PIN", subTitle: "Sorry for the inconvenience kindly answer the following question to proceed")
                    .padding(.bottom,10)
                 */
                VStack(alignment: .leading) {
                    Text("Question: What is the name of your pet? ")
                        // italics
                        .italic()
                        .foregroundColor(config.primaryColor)

                }
                .padding()
                AnswerView(answer: $answer1)

                
                Spacer()
                
                
               NavigationLink(destination: PINEntryView()){
                    Text("Continue")
                        .foregroundColor(.white)
                        .padding()
                        .background(config.primaryColor) // Set background color to green when enabled, gray when disabled
                        .cornerRadius(8)
                        .frame(maxWidth: .infinity)
                }
                
                
                
                
                
            
                }
            
            }
            

        
    }
}

