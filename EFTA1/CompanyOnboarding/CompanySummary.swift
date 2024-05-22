//
//  CustomerSummary.swift
//  EFTA1
//
//  Created by Joshua on 4/8/24.
//

import SwiftUI

struct CompanySummary: View {
    @State private var progress: CGFloat = 1 // Initial progress
    let receiptItems: [(String, String)] = [
            ("Company name", "Makumbosho Ltd"),
            ("TIN", "123445"),
            ("VRN", "1234567"),
            ("Postal address", "2098-0100"),
            ("Region", "Makumbusho"),
            ("District", "Corresponding 6"),
            ("District", "Baga moyo"),
            ("ward", "Makumbusho")
        ]
    @EnvironmentObject var config: AppConfig
    

    @Environment(\.presentationMode) var presentationMode
    let navigateToCustomerDetails = false
    @State private var navigateToCustomerDetailss = false // State to handle navigation to CustomerName


    var body: some View {
        GeometryReader { geometry in
            
            VStack{
                ProgressBar(geometry: geometry, progress: $progress,presentationMode: presentationMode, title:"Summary",description: "Kindly review the information collected")
                .padding(.trailing,20)

                ScrollView{

                    ReceiptBox(items: receiptItems, geometry: geometry, size: 0.5) {
                        navigateToCustomerDetailss = true
                    }
                   

                    DocumentContainerView(title: "Document Title")



                
    
                    }
                Spacer()
                
                Text("Continue")
                    .foregroundColor(.white)
                    .cornerRadius(8)
                    .frame(maxWidth: .infinity)
                    .frame(height:20)
                    .padding()
                    .background(config.primaryColor) // Set background color to green when enabled, gray when disabled
                    .cornerRadius(20)
                
                
 
                
                }
            }
    }
}





