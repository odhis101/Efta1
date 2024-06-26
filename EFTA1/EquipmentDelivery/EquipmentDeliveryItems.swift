//
//  EquipmentDeliveryItems.swift
//  EFTA1
//
//  Created by Joshua on 4/15/24.
//

import SwiftUI

struct EquipmentDeliveryItems: View {
    @State private var progress: CGFloat = 0.2 // Initial progress
    
    @State private var capturedImage: UIImage?
    @EnvironmentObject var config: AppConfig
    
    @Environment(\.presentationMode) var presentationMode
    var body: some View {

        GeometryReader { geometry in
            
            VStack{
                ProgressBar(geometry: geometry, progress: $progress,presentationMode: presentationMode, title:"Equipments for delivery",description: "Kindly select one of the equipments to fulfill delivery") // Pass progress as a binding
                    .padding(.trailing,20)
                
                ScrollView{
                    
                    EquipmentDeliveryItemsList(ItemTitle: "Equipment", ItemDescription: "CIMC 53 Foot Truck Flatbed Trailer")
                 
                    EquipmentDeliveryItemsList(ItemTitle: "Equipment", ItemDescription: "CIMC 53 Foot Truck Flatbed Trailer")


                
                }
                
                
                
                

                
                
                }
            }
        
    }
}

struct EquipmentDeliveryItemsList : View {
    var ItemTitle: String
    var ItemDescription : String

    
    var body: some View {
        NavigationLink(destination: EquipmentDeliveryForm1()) {

        VStack{
            RoundedRectangle(cornerRadius: 8)
                .foregroundColor(.gray.opacity(0.2))
                .frame(maxWidth:.infinity)
                .padding(.horizontal)
                .frame(height:50)
                .overlay(
                    VStack{
                    HStack{
                        Text(ItemTitle)
                            .font(.subheadline)
                            .padding(.horizontal)
                            .foregroundColor(.gray)
                        Spacer()
                        Image(systemName: "arrow.right")
                            .padding(.horizontal, 10)
                            .foregroundColor(.gray)
                        
                    }
                    .padding(.horizontal)
                        Text(ItemDescription)
                            .padding(.horizontal)
                            .foregroundColor(.black)
                            .padding(.horizontal, 10)
                        
                    }
                    
                )
            
            
        }
        
        
    
    
    }
}
}
