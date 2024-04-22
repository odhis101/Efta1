//
//  CustomerDetails.swift
//  EFTA1
//
//  Created by Joshua on 4/10/24.
//

import SwiftUI

struct EquipmentDeliveryDetails: View {
    let receiptItems: [(String, String)] = [
            ("Customer number", "1234567"),
            ("TLease contract", "W912HN-01-C-0022 0034."),
            ("Delivery date", "12-03-2024"),



        
        ]
    @EnvironmentObject var config: AppConfig

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
         

                NavigationLink(destination: EquipmentDeliveryItems()){
                Text("Continue")
                    .foregroundColor(.white)
                    .cornerRadius(8)
                    .frame(maxWidth: .infinity)
                    .frame(height:30)
                    .padding()
                    .background(config.primaryColor) // Set background color to green when enabled, gray when disabled
                    .cornerRadius(20)
                    .padding(.top,-50)
            }
            
            
            
            }
            
            
            
            
            
        }
    }
    
}



