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
    @ObservedObject var siteQuestionData = SiteDetailsDataHandler()
    @EnvironmentObject var config: AppConfig
    @Environment(\.presentationMode) var presentationMode

    
    let bulletedQuestions1 = ["Disrupting or destroying biodiversity", "Leading to harmful or high levels of emissions, hazardous waste products or other pollution", "Contribution to or partaking in unacceptable non-renewable resource extraction or degradation"]
    
    var body: some View {
            GeometryReader { geometry in
                VStack {
                    ProgressBar(geometry: geometry, progress: $progress, presentationMode: presentationMode, title: "Customer Information Sheet", description: "Kindly complete the following details")
                        .padding(.bottom, 10)
                    
                    ScrollView {
                        QuestionWithOptionView(question: "What benefits do employees receive?", options: ["Formal Training", "Contract", "Paid Leave", "Health Benefit, NSSF or PPF", "Other"])
                       // QuestionWithDropdown(question: "How is the business performing?", options: ["Option 1", "Option 2", "Option 3"])
                        //QuestionWithTextField(question: "Comments")
                        QuestionWithBulletpoints(question: "Environmental:", bulletPoints: bulletedQuestions1)
                    }
                    
                    Spacer()
                    /*
                    NavigationLink(destination: CustomerInformationSheet2()) {
                        Text("Continue")
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 40)
                            .background(config.primaryColor) // Gray background when profileImage is nil
                            .cornerRadius(8)
                            .padding(.horizontal)
                    }
                   */
                    CustomNavigationButton(destination: CustomerInformationSheet2(), label: "Continue", backgroundColor: config.primaryColor)
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





struct CustomerInformationSheet_Previews: PreviewProvider {
    static var previews: some View {
        CustomerInformationSheet()
            .environmentObject(AppConfig(region: .efken))
            .environmentObject(PinHandler())
    }
}

