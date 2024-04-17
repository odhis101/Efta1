//
//  EquipmentUserPage.swift
//  EFTA1
//
//  Created by Joshua on 4/15/24.
//

import SwiftUI

struct EquipmentUserPage: View {
    @State private var searchText = ""
    @State private var isActiveFirstText = true
    @State private var Search:String=""

    @State private var data: [UserData] = [UserData(name: "John Doe", phoneNumber: "1234567890"),
                                            UserData(name: "Jane Smith", phoneNumber: "0987654321")]
    
  
    var body: some View {
        VStack{
            QuickIntro(title: "Equipment Delivery", description: "Kindly select one of the customers to make equipment delivery")
            
            QuestionWithSmallTextField(question: "Search",placeholder: "Search",selectedOption: $Search)

            DataListComponent(data: data, destinationType: .equipmentDeliveryDetails)
                            .padding()


            Spacer()

        }
        
    }
}
