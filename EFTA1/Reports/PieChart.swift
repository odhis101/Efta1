import SwiftUI

// Define the data structure for each pie slice and its legend.
struct PieSliceData {
    var startAngle: Angle
    var endAngle: Angle
    var color: Color
    var label: String  // Label for the legend
}

// Create a view that draws a single pie slice.
struct PieSliceView: View {
    var pieSliceData: PieSliceData
    
    var body: some View {
        GeometryReader { geometry in
            Path { path in
                let width = min(geometry.size.width, geometry.size.height)
                let height = width
                let center = CGPoint(x: width * 0.5, y: height * 0.5)
                let radius = width * 0.5
                
                path.move(to: center)
                path.addArc(center: center, radius: radius, startAngle: pieSliceData.startAngle, endAngle: pieSliceData.endAngle, clockwise: false)
                path.closeSubpath()
            }
            .fill(pieSliceData.color)
        }
    }
}

// Combine multiple PieSliceViews to create the complete pie chart.
struct PieChartView: View {
    var slices: [PieSliceData]
    
    var body: some View {
        ZStack {
            ForEach(slices.indices, id: \.self) { index in
                PieSliceView(pieSliceData: slices[index])
            }
        }
        .aspectRatio(1, contentMode: .fit)
    }
}

// Create a legend for the pie chart.
struct LegendView: View {
    var slices: [PieSliceData]
    
    var body: some View {
        HStack(alignment: .center, spacing: 15) {
            ForEach(slices, id: \.label) { slice in
                HStack {
                    Circle()
                        .fill(slice.color)
                        .frame(width: 20, height: 20)
                    Text(slice.label)
                        .font(.caption)
                }
            }
        }
    }
}
