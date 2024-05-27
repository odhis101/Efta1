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
    @Environment(\.presentationMode) var presentationMode



    var body: some View {
        GeometryReader { geometry in
        VStack{
            VStack{
                QuickIntro(title: "Alex Mwangiss", description: "Kindly proceed to appraise the customer after confirming their details", presentationMode: presentationMode)
            ZStack{
                MapComponent(geometry: geometry)
                CustomerDetailsReceiptBox(items: receiptItems,geometry: geometry)
                    .padding(.bottom,200)
                
            }
            }
            .padding(.top, -50)

            
            Spacer()

  /*

                NavigationLink(destination: EquipmentDeliveryItems()){
                Text("Start")
                    .foregroundColor(.white)
                    .cornerRadius(8)
                    .frame(width:geometry.size.width * 0.8)
                    .frame(height:30)
                    .padding()
                    .background(config.primaryColor) // Set background color to green when enabled, gray when disabledx
                    .cornerRadius(20)

                    
                }
         */
            CustomNavigationButton(destination: EquipmentDeliveryItems(), label: "Start", backgroundColor: config.primaryColor)
          


            
            
            }
            
            
            
            
            
        }
      
        
        
    }

}



