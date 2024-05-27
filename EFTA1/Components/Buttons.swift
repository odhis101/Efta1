//
//  Buttons.swift
//  EFTA1
//
//  Created by Joshua on 5/2/24.
//

import SwiftUI


struct CustomNavigationButton<Destination>: View where Destination: View {
    var destination: Destination
    var label: String
    var backgroundColor: Color
    @EnvironmentObject var config: AppConfig
    @State private var navigate: Bool = false
    
    var body: some View {
        Button(action: {
            if config.primaryColor == backgroundColor {
                navigate = true
            }
        }) {
            Text(label)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .frame(height: 60)
                .background(backgroundColor)
                .cornerRadius(10)
                .padding(.horizontal)
                .padding(.vertical)
        }
        .disabled(backgroundColor != config.primaryColor) // Disable if the color is not the primary color
        .background(
            NavigationLink(destination: destination, isActive: $navigate) {
                EmptyView()
            }
        )
    }
}
