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
            return "Rectangle 1"
        case .efken:
            return "EFKen_Logo 1"
        }
    }

    var primaryColor: Color {
        switch currentRegion {
        case .efta:
            return Color(hex: "#2AA241") // Change as needed
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
    
    var user: String {
        switch currentRegion {
        case .efta:
            return "user 1 "
        case .efken:
            return "user 2"
        }
    }
    
}
