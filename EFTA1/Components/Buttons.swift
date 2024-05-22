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

    var body: some View {
        NavigationLink(destination: destination) {
            Text(label)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .frame(height: 60)
                .background(backgroundColor)
                .cornerRadius(10)
                .padding(.horizontal)
                .padding(.vertical)
        }
    }
}
