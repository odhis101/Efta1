//
//  CustomerDetails.swift
//  EFTA1
//
//  Created by Joshua on 4/10/24.
//

import SwiftUI

struct ReposessionDetails: View {
    let receiptItems: [(String, String)] = [
            ("ID number", "Makumbosho Ltd"),
            ("Type of business", "123445"),
            ("Equipment description", "1234567"),
            ("Equipment price", "2098-0100"),



        
        ]
    var userData: CustomerData
    @EnvironmentObject var config: AppConfig
    @Environment(\.presentationMode) var presentationMode



    var body: some View {
        GeometryReader { geometry in
        VStack{
            VStack{
                QuickIntro(title: "Alex Mwangiss", description: "Kindly proceed to appraise the customer after confirming their details",presentationMode:presentationMode)
            ZStack{
                MapComponent(geometry: geometry)
                CustomerDetailsReceiptBox(items: receiptItems,geometry: geometry)
                    .padding(.bottom,200)
                
            }
            }
            .padding(.top, -50)

            
            Spacer()

   

/*
                NavigationLink(destination: RepossesionPickUp()){
                Text("Continue")
                    .foregroundColor(.white)
                    .cornerRadius(8)
                    .frame(height:30)
                    .frame(width:geometry.size.width * 0.8)
                    .padding()
                    .background(config.primaryColor) // Set background color to green when enabled, gray when disabledx
                    .cornerRadius(20)

                    
                }
 */
            
            CustomNavigationButton(destination: RepossesionPickUp(), label: "Continue", backgroundColor: config.primaryColor)
            


            
            
            }
            
            
            
            
            
        }
      
        
        
    }

}



