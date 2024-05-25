import SwiftUI

struct ImpactReportingCustomerMonitoring: View {
    @State private var progress: CGFloat = 1 // Initial progress
    @State private var capturedImage: UIImage?
    @ObservedObject var siteQuestionData = SiteDetailsDataHandler()
    @State private var CurrentMonthlyWage: String = ""
    @State private var CurrentDailyWage: String = ""
    @State private var RevenueLastMonth: String = ""
    @State private var RevenueNexttMonth: String = ""
    @State private var showingConfirmation = false // State for showing the confirmation dialog
    @State private var navigateToDashboard = false

    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var config: AppConfig

    var body: some View {
        GeometryReader { geometry in
            VStack {
                ProgressBar(geometry: geometry, progress: $progress, presentationMode: presentationMode, title: "Impact Reporting", description: "Kindly complete the following details") // Pass progress as a binding
/*
                ScrollView {
                    /*
                    HStack {
                        Text("Previous impact report")
                            .foregroundColor(config.primaryColor)
                            .bold()
                        Spacer()
                    }
                     */
                    //.padding()

                    ImpactReportingButton(geometry: geometry)

                    HStack {
                        Text("Current impact report")
                            .foregroundColor(config.primaryColor)
                            .bold()
                        Spacer()
                    }
                    .padding()

                    QuestionWithSmallTextField(question: "Number of Permanent male employees", placeholder: "Enter Number", selectedOption: $CurrentMonthlyWage)
                    QuestionWithSmallTextField(question: "Number of Permanent female employees", placeholder: "Enter Number", selectedOption: $CurrentDailyWage)
                    QuestionWithSmallTextField(question: "Number of casual male employees", placeholder: "Enter Number", selectedOption: $RevenueLastMonth)
                    QuestionWithSmallTextField(question: "Number of casual female employees", placeholder: "Enter Number", selectedOption: $RevenueLastMonth)
                    QuestionWithSmallTextField(question: "Days employed per month by casuals", placeholder: "Enter Number", selectedOption: $CurrentMonthlyWage)
                    QuestionWithSmallTextField(question: "Health benefits for permanent employees", placeholder: "Enter Number Of days", selectedOption: $RevenueNexttMonth)

                    NavigationLink(destination: ImpactReporting(), isActive: $navigateToDashboard) {
                        EmptyView()
                    }

                    Spacer()
                    CustomNavigationButton(destination: ImpactReportingCustomerMonitoring2(), label: "Continue", backgroundColor: config.primaryColor)

                  
                }
 */
            }
        }
    }
}

struct ImpactReportingCustomerMonitoring_Previews: PreviewProvider {
    static var previews: some View {
        ImpactReportingCustomerMonitoring()
            .environmentObject(AppConfig(region: .efken))
            .environmentObject(PinHandler())
    }
}
