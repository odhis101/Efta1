//
//  Reports.swift
//  EFTA1
//
//  Created by Joshua on 4/16/24.
//

import SwiftUI

struct Reports: View {


    var body: some View {
        VStack {
            
            QuickIntro(title: "Reports", description: "Here is your current report status based on your recent activities")
                    let data = [
                        PieSliceData(startAngle: .degrees(0), endAngle: .degrees(180), color: .green, label: "Green: 50%"),
                        PieSliceData(startAngle: .degrees(180), endAngle: .degrees(288), color: .orange, label: "Orange: 30%"),
                        PieSliceData(startAngle: .degrees(288), endAngle: .degrees(360), color: .brown, label: "Brown: 20%")
                    ]
                    Text("Overall report")
                        .foregroundColor(.green)
                    Text("Below is a representation of your current report status")
                        .font(.caption)
                        .foregroundColor(.gray)
                    PieChartView(slices: data)
                        .padding()
                        .frame(width: 300, height: 300)
                    
                    LegendView(slices: data)
                        .padding()
            
            Spacer()
            
                }
        .padding()
    }
}


