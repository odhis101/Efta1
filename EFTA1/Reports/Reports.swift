//
//  Reports.swift
//  EFTA1
//
//  Created by Joshua on 4/16/24.
//

import SwiftUI
import SwiftUICharts  // Import the SwiftUICharts library


struct Reports: View {
    @EnvironmentObject var config: AppConfig
    @Environment(\.presentationMode) var presentationMode

    
    
    // Create an instance of PieChartData
    @StateObject var pieChartData: PieChartData = {
        // Define your data sets, metadata, and chart style here
        let dataSets = PieDataSet(dataPoints: [
            PieChartDataPoint(value: 50.0, description: "Green: 50%", colour: .green),
            PieChartDataPoint(value: 30.0, description: "Orange: 30%", colour: .orange),
            PieChartDataPoint(value: 20.0, description: "Brown: 20%", colour: .brown)
        ], legendTitle: "legent title here")
        
        let metadata = ChartMetadata(title: "Pie Chart", subtitle: "Your Report Status")
        let chartStyle = PieChartStyle()
        
        return PieChartData(dataSets: dataSets, metadata: metadata, chartStyle: chartStyle)
    }()

    var body: some View {

        VStack {
            QuickIntro(title: "Reports", description: "Here is your current report status based on your recent activities", presentationMode: presentationMode)
                   
            
            let datas = [
                        PieSliceData(startAngle: .degrees(0), endAngle: .degrees(180), color: .green, label: "Cusomer Apraisla: 60%"),
                        PieSliceData(startAngle: .degrees(180), endAngle: .degrees(288), color: .orange, label: "Customer monitoring : 30%"),
                        PieSliceData(startAngle: .degrees(288), endAngle: .degrees(360), color: .brown, label: "Customer on boarding : 20%")
                    ]
            
          
            ScrollView{
                VStack {
                        Text("Overall report")
                        .foregroundColor(config.primaryColor)
                        Text("Below is a representation of your current report status")
                            .font(.caption)
                            .foregroundColor(.gray)
                    PieChart(chartData: pieChartData)
                                   .padding()
                                   .frame(width: 300, height: 300)
                        
                        LegendView(slices: datas)
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
                DynamicProgressComponent(icon: "appraisal", text: "Customer Appraisal", numerator: 6, denominator: 10, progressColor: .green)
                DynamicProgressComponent(icon: "monitoring-system", text: "Customer Monitoring", numerator: 3, denominator: 10, progressColor: .orange)
                DynamicProgressComponent(icon: "visit", text: "Customer Onboarding", numerator: 1, denominator: 10, progressColor: .red)
               
                
                
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
                Image(icon)
                    .foregroundColor(.blue) // You can make this dynamic too if needed
                Text(text)
                Spacer()
                Text("\(numerator)/\(denominator)")
            }
            
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



