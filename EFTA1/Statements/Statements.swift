//
//  Statements.swift
//  EFTA1
//
//  Created by Joshua on 4/17/24.
//

import SwiftUI

struct Statements: View {
    @State private var searchText = ""
    @State private var isActiveFirstText = true
    @State private var Search:String=""

    @State private var data: [UserData] = [UserData(name: "John Doe", phoneNumber: "1234567890"),
                                            UserData(name: "Jane Smith", phoneNumber: "0987654321")]
    
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        VStack{
            QuickIntro(title: "Equipment Delivery", description: "Kindly select one of the customers to make equipment delivery",presentationMode:presentationMode)
            
            QuestionWithSmallTextField(question: "Search",placeholder: "Search",selectedOption: $Search)

            DataListComponent(data: data, destinationType:.customerStatements)
                            .padding()


            Spacer()

        }
        
    }}

