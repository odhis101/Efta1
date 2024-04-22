//
//  CustomerInformationSheet.swift
//  EFTA1
//
//  Created by Joshua on 4/11/24.
//

import SwiftUI

struct CustomerInformationSheet: View {
    @State private var progress: CGFloat = 0.4 // Initial progress
    
    @State private var capturedImage: UIImage?
    @ObservedObject var siteQuestionData = SiteQuestionDataHandler()
    @EnvironmentObject var config: AppConfig

    
    let bulletedQuestions1 = ["Disrupting or destroying biodiversity", "Leading to harmful or high levels of emissions, hazardous waste products or other pollution", "Contribution to or partaking in unacceptable non-renewable resource extraction or degradation"]
    
    var body: some View {
            GeometryReader { geometry in
                VStack {
                    ProgressBar(geometry: geometry, progress: $progress, title: "Customer Information Sheet", description: "Kindly complete the following details")
                        .padding(.trailing, 20)
                        .padding(.bottom, 10)
                    
                    ScrollView {
                        QuestionWithOptionView(question: "What benefits do employees receive?", options: ["Formal Training", "Contract", "Paid Leave", "Health Benefit, NSSF or PPF", "Other"])
                       // QuestionWithDropdown(question: "How is the business performing?", options: ["Option 1", "Option 2", "Option 3"])
                        QuestionWithTextField(question: "Comments")
                        QuestionWithBulletpoints(question: "Environmental:", bulletPoints: bulletedQuestions1)
                    }
                    
                    Spacer()
                    
                    NavigationLink(destination: CustomerInformationSheet2()) {
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
}

// Assuming other struct definitions (like QuestionWithOptionView) are correct and are omitted here for brevity.





// Helper extension to chunk the options array into rows
extension Array {
    func chunked(into size: Int) -> [[Element]] {
        stride(from: 0, to: count, by: size).map {
            Array(self[$0 ..< Swift.min($0 + size, count)])
        }
    }
}






