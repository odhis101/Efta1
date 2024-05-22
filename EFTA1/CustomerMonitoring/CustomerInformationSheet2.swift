//
//  CustomerInformationSheet2.swift
//  EFTA1
//
//  Created by Joshua on 4/11/24.
//

import SwiftUI

struct CustomerInformationSheet2: View {
    @State private var progress: CGFloat = 0.4 // Initial progress
    
    @State private var capturedImage: UIImage?

    @EnvironmentObject var config: AppConfig

    @ObservedObject var siteQuestionData = SiteQuestionDataHandler()
    
    @Environment(\.presentationMode) var presentationMode
    
    let bulletedQuestions1 = ["Promoting or partaking in unethical or antisocial activities","Partaking in forced compulsory labor;employing anyone lessthan 18 years of age;showing evidence of discrimination onrejecting employee unions","Having health & safety incidents or lacking health & safetyequipment"]
    let bulletedQuestions2 = ["Evading legal and regulatory requirements","In conflict of interest with EFTA or any of our present customers","Conducting dishonest or disreputable practices either within the broader community or with our past and present customers"]
    var body: some View {
        NavigationView {

        GeometryReader { geometry in
            
            VStack{
                ProgressBar(geometry: geometry, progress: $progress,presentationMode: presentationMode, title:"Customer information sheet",description: "Kindly complete the following details") // Pass progress as a binding
                    .padding(.bottom,10)

                ScrollView{

                    
                    QuestionWithBulletpoints(question: "Social:", bulletPoints: bulletedQuestions1)
                    
                    QuestionWithBulletpoints(question: "Governance:", bulletPoints: bulletedQuestions2)
                    
                    QuestionWithTextField(question: "Actions that were agreed with the customer at this site visit")

                    

                    

                    
                    
                }
                Spacer ()
                /*
                NavigationLink(destination: CustomerMonitioringDocument()){

                Text("Continue")
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height:40)
                    .background(config.primaryColor) // Gray background when profileImage is nil
                    .cornerRadius(8)
                    .padding(.horizontal)

                }
                */
                CustomNavigationButton(destination: ImpactReportingCustomerMonitoring(), label: "Continue", backgroundColor: config.primaryColor)
            }
            }
            
        }
        .navigationBarHidden(true)

    }
}



struct ImpactReportingButton: View {
    let geometry: GeometryProxy
    @EnvironmentObject var config: AppConfig

    var body: some View {
        
        RoundedRectangle(cornerRadius: 8)
            .fill(Color(hex: "#F9F9F9"))
            .padding(.horizontal)
            .frame(maxWidth:.infinity)
            .frame(height:60)
            .overlay(
                HStack{
                    Image(systemName: "document")
                    Text("Impact Reporting")
                    Spacer()
                    RoundedRectangle(cornerRadius: 8)
                        .fill(config.primaryColor.opacity(0.3))
                        .frame(width:geometry.size.width*0.3)
                        .frame(height:40)
                        .overlay(
                            Button( action: {
                                print("hello world")
                            }){
                                Text("View Report")
                                    .foregroundColor(config.primaryColor)
                            }
                        
                        )
                }
                    .padding(.horizontal)
            )
      
    }
}

struct CustomerInformationSheet2_Previews: PreviewProvider {
    static var previews: some View {
        GeometryReader{ geometry in
            ImpactReportingButton(geometry: geometry)
                .environmentObject(AppConfig(region: .efken))
                .environmentObject(PinHandler())
        }
    }
}
