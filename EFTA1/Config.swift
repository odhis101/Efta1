//
//  Config.swift
//  EFTA1
//
//  Created by Joshua on 4/18/24.
//

import SwiftUI

class AppConfig: ObservableObject {
    enum Region {
        case efta
        case efken
    }

    @Published var currentRegion: Region

    init(region: Region) {
        self.currentRegion = region
    }

    var splashImageName: String {
        switch currentRegion {
        case .efta:
            return "splashView"
        case .efken:
            return "EFKen_Logo"
        }
    }

    var primaryColor: Color {
        switch currentRegion {
        case .efta:
            return Color.green // Change as needed
        case .efken:
            return Color(hex: "#7FAB4B") // Change as needed
        }
    }
    
    var dashboardColor: String {
        switch currentRegion {
        case .efta:
            return "greenDashboard"
        case .efken:
            return "EFKENDashboard"
        }
    }
}



