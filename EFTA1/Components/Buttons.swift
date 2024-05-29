//
//  Buttons.swift
//  EFTA1
//
//  Created by Joshua on 5/2/24.
//

import SwiftUI
import AlertToast

struct CustomNavigationButton<Destination>: View where Destination: View {
    var destination: Destination
    var label: String
    var backgroundColor: Color
    @EnvironmentObject var config: AppConfig
    @State private var navigate: Bool = false
    @State private var showAlert: Bool = false // Corrected: Remove the $ prefix

    var body: some View {
        VStack {
            Button(action: {
                if config.primaryColor == backgroundColor {
                    navigate = true
                } else {
                    showAlert = true // Corrected: Remove the $ prefix
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
            .toast(isPresenting: $showAlert) {
                AlertToast(displayMode: .hud, type: .error(Color.red), title: "Error", subTitle: "Please fill all data")
            }
        }
    }
}
