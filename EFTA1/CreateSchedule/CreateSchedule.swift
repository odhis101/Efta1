//
//  CreateSchedule.swift
//  EFTA1
//
//  Created by Joshua on 4/16/24.
//

import SwiftUI

struct CreateSchedule: View {
    @State private var searchText = ""
    @State private var isActiveFirstText = true
    @State private var Search:String=""
    @EnvironmentObject var config: AppConfig

    var body: some View {
        VStack{
        QuickIntro(title: "Equipment Delivery", description: "Kindly select one of the customers to make equipment delivery")
        
        QuestionWithDate(question: "Schedule Date ")
        
        QuestionWithTime(question: "Schedule Time ")
            Spacer ()
            
            NavigationLink(destination: Dashboard()) {
                Text("Continue")
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 40)
                    .background(config.primaryColor) // Gray background when profileImage is nil
                    .cornerRadius(8)
                    .padding(.horizontal)
            }
            
        }

    }
}

