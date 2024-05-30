//
//  EFTA1App.swift
//  EFTA1
//
//  Created by Joshua on 3/28/24.
//

import SwiftUI

@main
struct EFTA1App: App {
    @StateObject var SiteQuestionData = SiteDetailsDataHandler()
    @StateObject var CustomerOnboardingData = OnboardingData() // Instantiate your DocumentHandler
    @StateObject var config = AppConfig(region: .efta)
    @StateObject var pinHandlesr = PinHandler()
    @StateObject var companyOnboarding = CompanyOnboardingData()
    @StateObject var resetPin = ResetPin()



//efken 

    var body: some Scene {
        WindowGroup {
            CustomerSummary()
                .environmentObject(SiteQuestionData)
                //.environmentObject(documentHandler)
                .environmentObject(CustomerOnboardingData)
                .environmentObject(config)
                .environmentObject(pinHandlesr)
                .environmentObject(companyOnboarding)
                .environmentObject(resetPin)
                .environment(\.font, Font.custom("Inter", size: 16)) // Set default font globally






        }
    }
}
