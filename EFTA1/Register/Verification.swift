//
//  Verification.swift
//  EFTA
//
//  Created by Joshua on 3/27/24.
//

import SwiftUI

struct Verification: View {
    @State private var timerValue = 10
    @State private var isResendEnabled = false
    @State private var timer: Timer?
    @State private var shouldNavigateToNextPage = false // State variable for navigation
    @State private var verificationCodes: [String] = Array(repeating: "", count: 5)
    @FocusState private var focusedTextField: Int? // Track the focused text field index
    @State private var isNavigationActive = false // State variable to track navigation
    @StateObject private var networkManager = NetworkManager()
    @State private var showAlert = false // State variable to control the alert
    @EnvironmentObject var config: AppConfig

    
    var body: some View {
     
            GeometryReader { geometry in
                VStack {
                    Image(config.splashImageName)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: geometry.size.width * 0.4, height: geometry.size.width * 0.4)
                        .padding(.top, -150)

                    VStack{
                        HStack {
                            VStack(alignment: .leading) { // Align content to the leading edge (left)
                                Text("Verifying your details")
                                    .font(.title)
                                    .fontWeight(.bold)
                                    .foregroundColor(config.primaryColor)
                                
                                Text("Just sit back and relax we will verify you")
                                    .font(.headline)
                                    .foregroundColor(Color.gray)
                            }
                        }
                     
                            Image("lazyMan")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: geometry.size.width * 0.8, height: geometry.size.width * 0.5)
                                .padding()
                        
                        HStack(spacing: 10) {
                            ForEach(0..<verificationCodes.count, id: \.self) { index in
                                TextField("0", text: self.$verificationCodes[index])
                                    .frame(width: 50, height: 50)
                                    .foregroundColor(.black)
                                    .background(Color.gray.opacity(0.2))
                                    .cornerRadius(8)
                                    .multilineTextAlignment(.center)
                                    .keyboardType(.numberPad)
                                    .onChange(of: verificationCodes[index]) { value in
                                        // Move focus to the next text field when a number is entered
                                        if !value.isEmpty && value.count == 1 {
                                            if index < verificationCodes.count - 1 {
                                                focusedTextField = index + 1
                                            }
                                            else {
                                                print(verificationCodes)
                                                networkManager.sendVerificationRequest(verificationCodes: verificationCodes) { success in
                                                    if success {
                                                        
                                                        // Navigate to the next screen upon receiving a successful response
                                                        isNavigationActive = true
                                                        focusedTextField = nil
                                                    } else {
                                                        // Reset focusedTextField to nil if the request fails
                                                        self.verificationCodes = Array(repeating: "", count: verificationCodes.count)
                                                        focusedTextField = nil
                                                        
                                                        showAlert = true

                                                    }
                                                }
                                            }
                                        }
                                    }
                                    .focused($focusedTextField, equals: index) // Track focused text field
                            }
                        }

                        
                        Text("Resend Code ")
                            .font(.headline)
                            .foregroundColor(Color.gray)
                        
                        Text(" \(timerValue) seconds")
                            .font(.headline)
                            .foregroundColor(config.primaryColor)
        
                            .onAppear {
                                self.startTimer()
                            }
                        }
                        
                        Spacer() // Add spacer to push the button to the bottom
                    
                    
                    NavigationLink(destination: PINEntryView(), isActive: $shouldNavigateToNextPage) { // NavigationLink to the next page
                                           EmptyView() // Invisible navigation link
                                       }
                    
                        // Resend Button
                    Button(action: {
                        self.timerValue = 20
                        self.isResendEnabled = false
                        self.startTimer() // Start or restart the timer when the button is tapped
                    }) {
                        Text("Continue")
                            .foregroundColor(.white)
                            .padding()
                            .background(isResendEnabled ? config.primaryColor : Color.gray) // Set background color to green when enabled, gray when disabled
                            .cornerRadius(8)
                            .frame(maxWidth: .infinity)
                    }
                    .disabled(!isResendEnabled)
                    .frame(width: geometry.size.width * 0.8)

                }
                .padding()
            }
            .background(
                NavigationLink(
                    destination: PINEntryView(), // Destination page to navigate
                    isActive: $isNavigationActive, // Binding to control navigation
                    label: { EmptyView() }
                )
            )
            .onReceive(networkManager.$response) { response in
                // Check if the response is not nil and if its status code is 200
                if let httpResponse = response, httpResponse.statusCode == 200 {
                    // Navigate to the next screen upon receiving a successful response
                    isNavigationActive = true
                }
            }
            .alert(isPresented: $showAlert) {
                       Alert(title: Text("Verification Failed"), message: Text("The entered verification code is incorrect. Please try again."), dismissButton: .default(Text("OK")))
                   }
        }
    
    
    private func startTimer() {
        self.timer?.invalidate() // Invalidate previous timer if exists
        self.timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
            if self.timerValue > 0 {
                self.timerValue -= 1
            } else {
                timer.invalidate()
                self.isResendEnabled = true // Enable the resend button when timer completes
                // add navigation logic to go to another page
                //self.shouldNavigateToNextPage = true // Navigate to the next page


            }
        }
    }
}

