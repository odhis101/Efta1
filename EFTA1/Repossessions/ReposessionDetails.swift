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
    var userData: UserData


    var body: some View {
        GeometryReader { geometry in

        VStack{
        
            QuickIntro(title: "Alex Mwangi", description: "Kindly proceed to appraise the customer after confirming their details")
            ZStack{
                MapComponent(geometry: geometry)
                CustomerDetailsReceiptBox(items: receiptItems,geometry: geometry)
                    .padding(.bottom,200)
                
            }
            Spacer()
         

                NavigationLink(destination: RepossesionPickUp()){
                Text("Continue")
                    .foregroundColor(.white)
                    .cornerRadius(8)
                    .frame(maxWidth: .infinity)
                    .frame(height:30)
                    .padding()
                    .background(Color.green) // Set background color to green when enabled, gray when disabled
                    .cornerRadius(20)
                    .padding(.bottom,100)
                
            }
                .padding(.top,-50)
            
            
            
            }
            
            
            
            
            
        }
    }
    
}



