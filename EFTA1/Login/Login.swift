//
//  Login.swift
//  EFTA1
//
//  Created by Joshua on 3/28/24.
//

import SwiftUI
import AlertToast

struct Login: View {
    @State private var enteredPIN: String = ""
    private let pinLength = 4 // Define the length of the PIN
    @State var pinCode: String = ""
    @State private var shouldNavigate = false // State variable for navigation
    @EnvironmentObject var config: AppConfig
    @State var showError = false
    @EnvironmentObject var pinHandler: PinHandler
    let goback = true // Make it static
    @State var showAlert = false
    @State var errorMessage = ""
    @State private var isLoading = false // State for loading indicator
    @State private var showToast = false // State to show toast message
    @State private var toastMessage = "" // Message for the toast
    @State private var isSuccess = false // Success status for the toast
    @State private var remainingAttempts: Int? = nil // State to store remaining attempts

    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        NavigationView {
            GeometryReader { geometry in
                VStack {
                    LogoAndTitleView(geometry: geometry, title: "Login", subTitle: "Kindly provide your PIN to access your account", presentationMode: presentationMode, goBack: goback)
                        .toast(isPresenting: $showToast) {
                            AlertToast(type: isSuccess ? .complete(.green) : .error(.red), title: toastMessage)
                        }
                    
                    if let attempts = remainingAttempts {
                        Text("Remaining Attempts: \(attempts)")
                            .foregroundColor(.red)
                            .padding(.bottom, 10)
                    }
                    
                    KeyPadView(pinCode: $pinCode, instruction: "Enter Pin")
                        .frame(minHeight: geometry.size.height * 0.3, maxHeight: geometry.size.height * 0.45)
                        .padding(.vertical, geometry.size.height * 0.06)
                    
                    Spacer()
                    
                    NavigationLink(destination: forgotPin()) {
                        Text("Forgot Pin")
                            .foregroundColor(config.primaryColor)
                    }
                    
                    NavigationLink(destination: MyTabView(), isActive: $shouldNavigate) {
                        EmptyView() // Invisible navigation link
                    }
                }
            }
        }
        .navigationBarHidden(true)
        .onChange(of: pinCode) { newValue in
            if newValue.count == pinLength {
                loginWithPasscode(passcode: newValue)
            }
        }
        .overlay(isLoading ? LoadingModal() : nil)
    }

    private func loginWithPasscode(passcode: String) {
        isLoading = true

        guard let phoneNumber = AuthManager.shared.loadPhoneNumber() else {
            print("Phone number not found in Keychain")
            return
        }

        NetworkManager.shared.mobileAppLogin(phoneNumber: phoneNumber, pin: passcode) { success, message, attempts in
            DispatchQueue.main.async {
                self.isLoading = false
                self.showToast = true
                self.toastMessage = message // Capture the message
                self.remainingAttempts = attempts // Capture remaining attempts

                if success {
                    self.isSuccess = success
                    // Display toast for a bit longer before navigating
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        self.shouldNavigate = true
                    }
                } else {
                    self.isSuccess = false
                    // Hide toast after 3 seconds
                    DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                        self.showToast = false
                    }
                }
            }
        }
    }
}
