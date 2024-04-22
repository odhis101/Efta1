//
//  Reports.swift
//  EFTA1
//
//  Created by Joshua on 4/16/24.
//

import SwiftUI

struct Reports: View {

    @EnvironmentObject var config: AppConfig

    var body: some View {

        VStack {
            QuickIntro(title: "Reports", description: "Here is your current report status based on your recent activities")
                    let data = [
                        PieSliceData(startAngle: .degrees(0), endAngle: .degrees(180), color: .green, label: "Green: 50%"),
                        PieSliceData(startAngle: .degrees(180), endAngle: .degrees(288), color: .orange, label: "Orange: 30%"),
                        PieSliceData(startAngle: .degrees(288), endAngle: .degrees(360), color: .brown, label: "Brown: 20%")
                    ]
            ScrollView{
                VStack {
                        Text("Overall report")
                        .foregroundColor(config.primaryColor)
                        Text("Below is a representation of your current report status")
                            .font(.caption)
                            .foregroundColor(.gray)
                        PieChartView(slices: data)
                            .padding()
                            .frame(width: 300, height: 300)
                        
                        LegendView(slices: data)
                            .padding()
                    }
                    .padding()
                    .background(Color.white) // Set the background color so the border is visible
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.gray, lineWidth: 1) // You can adjust the color and line width
                    )
            
            
            VStack(alignment: .leading){
                Text("Breakdown of your report")
                    .foregroundColor(config.primaryColor)
                DynamicProgressComponent(icon: "star.fill", text: "Complete the task", numerator: 6, denominator: 10, progressColor: .green)
                DynamicProgressComponent(icon: "star.fill", text: "Complete the task", numerator: 3, denominator: 10, progressColor: .orange)
                DynamicProgressComponent(icon: "star.fill", text: "Complete the task", numerator: 1, denominator: 10, progressColor: .red)
               
                
                
            }
            }
            .padding(.horizontal)
            
            Spacer()
            
                }

    }
}

struct DynamicProgressComponent: View {
    var icon: String
    var text: String
    var numerator: Int
    var denominator: Int
    var progressColor: Color

    private var progressFraction: CGFloat {
        denominator > 0 ? CGFloat(numerator) / CGFloat(denominator) : 0
    }

    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Image(systemName: icon)
                    .foregroundColor(.blue) // You can make this dynamic too if needed
                Text(text)
                Spacer()
                Text("\(numerator)/\(denominator)")
            }
            .padding(.horizontal)
            
            Rectangle()
                .frame(height: 4)
                .foregroundColor(progressColor)
                .opacity(0.3) // Making the background of the progress bar visible
                .overlay(
                    GeometryReader { geometry in
                        Rectangle()
                            .frame(width: geometry.size.width * progressFraction)
                            .foregroundColor(progressColor)
                            .animation(.easeInOut, value: progressFraction)
                    }
                )
        }
        .padding()
    }
}



