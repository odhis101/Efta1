//
//  EFTA1App.swift
//  EFTA1
//
//  Created by Joshua on 3/28/24.
//

import SwiftUI

@main
struct EFTA1App: App {
    @StateObject var SiteQuestionData = SiteQuestionDataHandler()
    //@StateObject var documentHandler = DocumentHandler() // Instantiate your DocumentHandler
    @StateObject var CustomerOnboardingData = OnboardingData() // Instantiate your DocumentHandler
    @StateObject var config = AppConfig(region: .efta)
    @StateObject var pinHandlesr = PinHandler()



    var body: some Scene {
        WindowGroup {
            SplashView()
                .environmentObject(SiteQuestionData)
                //.environmentObject(documentHandler)
                .environmentObject(CustomerOnboardingData)
                .environmentObject(config)
                //.environmentObject(pinHandler)





        }
    }
}
