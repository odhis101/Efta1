//
//  CustomerDetails.swift
//  EFTA1
//
//  Created by Joshua on 4/10/24.
//

import SwiftUI

struct CustomerDetails: View {
    let receiptItems: [(String, String)] = [
            ("ID number", "Makumbosho Ltd"),
            ("Type of business", "123445"),
            ("Equipment description", "1234567"),
            ("Equipment price", "2098-0100"),
            ("Equipment price", "2098-0100"),
            ("Equipment price", "2098-0100"),
            ("Equipment price", "2098-0100"),


        
        ]
    var userData: UserData

    @EnvironmentObject var config: AppConfig

    var body: some View {
        GeometryReader { geometry in

        VStack{
        
            QuickIntro(title: "Alex Mwangi", description: "Kindly proceed to appraise the customer after confirming their details")
            ZStack{
                MapComponent(geometry: geometry)
                CustomerDetailsReceiptBox(items: receiptItems,geometry: geometry)
                    .padding(.bottom,200)
                
            }
            HStack{
                Text("Schedule")
                    .foregroundColor(config.primaryColor) // Set text color to green
                    .frame(maxWidth: .infinity)
                    .frame(height: 30)
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 8) // Apply corner radius to the background
                            .stroke(config.primaryColor, lineWidth: 2) // Set border color and width
                    )
                    .cornerRadius(20) // Apply corner radius to the text view

                NavigationLink(destination: Equipment()){
                Text("Start")
                    .foregroundColor(.white)
                    .cornerRadius(8)
                    .frame(maxWidth: .infinity)
                    .frame(height:30)
                    .padding()
                    .background(config.primaryColor) // Set background color to green when enabled, gray when disabled
                    .cornerRadius(20)
                }
            }
            .padding(.top,-50)

            
            
            
            }
            
            
            
            
            
        }
    }
    
}



