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
    //@StateObject var documentHandler = DocumentHandler() // Instantiate your DocumentHandler
    @StateObject var CustomerOnboardingData = OnboardingData() // Instantiate your DocumentHandler
    @StateObject var config = AppConfig(region: .efta)
    @StateObject var pinHandlesr = PinHandler()
    @StateObject var companyOnboarding = CompanyOnboardingData()


//efken 

    var body: some Scene {
        WindowGroup {
            LoginOnBoarding()
                .environmentObject(SiteQuestionData)
                //.environmentObject(documentHandler)
                .environmentObject(CustomerOnboardingData)
                .environmentObject(config)
                .environmentObject(pinHandlesr)
                .environmentObject(companyOnboarding)
                .environment(\.font, Font.custom("Inter", size: 16)) // Set default font globally






        }
    }
}
