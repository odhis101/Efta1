//
//  Verification.swift
//  EFTA
//
//  Created by Joshua on 3/27/24.
//

import SwiftUI
import Combine
import AlertToast

struct Verification: View {
    @State private var timerValue = 10
    @State private var isResendEnabled = false
    @State private var timer: Timer?
    @State private var shouldNavigateToNextPage = false // State variable for navigation
    @State private var verificationCodes: [String] = Array(repeating: "", count: 4)
    @FocusState private var focusedTextField: Int? // Track the focused text field index
    @State private var isNavigationActive = false // State variable to track navigation
    @StateObject private var networkManager = NetworkManager()
    @State private var showAlert = false // State variable to control the alert
    @EnvironmentObject var config: AppConfig
    @EnvironmentObject var pinHandler: PinHandler

    @State private var keyboardHeight: CGFloat = 0

    @Environment(\.presentationMode) var presentationMode
    
    @State private var boxesMove = -0.05 // happy with 0.5

    var body: some View {
     
            GeometryReader { geometry in
                VStack {
                    Image(config.splashImageName)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: geometry.size.width * 0.4, height: geometry.size.width * 0.4)
                        .padding(.top, geometry.size.height * boxesMove)

                    VStack{
                        HStack {
                            VStack(alignment: .leading) { // Align content to the leading edge (left)
                                Text("Verifying your details")
                                    .font(.title)
                                    .fontWeight(.bold)
                                    .foregroundColor(config.primaryColor)
                                
                                Text("Just sit back and relax we will verify you")
                                    .font(.system(size: 16)) // Set the font size to 24 points
                                    .foregroundColor(Color.gray)
                            }
                        }
                        .toast(isPresenting: $showAlert) {
                                             AlertToast(displayMode: .hud, type: .error(Color.red), title: "Error", subTitle: "Something went wrong. Please try again.")
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
                                                // this might cause problems 
                                            
                                            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                                                            
                                                print(verificationCodes)
                                                networkManager.sendVerificationRequest(phoneNumber: pinHandler.phoneNumber, otp: verificationCodes.joined()) { success in                                                    if success {
                                                        // Navigate to the next screen upon receiving a successful response
                                                        isNavigationActive = true
                                                        focusedTextField = nil
                                                        AuthManager.shared.savePhoneNumber(pinHandler.phoneNumber)

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
                        .padding(.bottom, keyboardHeight) // Add padding when the keyboard appears
                        

                        
                        
                        
                        
                        
                        
                        Text("Resend Code in ")
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
                    Button("Resend Code") {
                        self.timerValue = 20
                        self.isResendEnabled = false
                        self.startTimer() // Start or restart the timer when the button is tapped
                    }
                    .disabled(!isResendEnabled)
                    .foregroundColor(.white)
                    .cornerRadius(8)
                    .frame(width: geometry.size.width * 0.8, height: 30)
                    .padding()
                    .background(isResendEnabled ? config.primaryColor : Color.gray.opacity(0.5)) // Use gray with reduced opacity when disabled
                    .cornerRadius(10)
                    
                 
                

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
            .onTapGesture { UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil) } // Dismiss the keyboard when tapping outside
            .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardWillShowNotification)) { notification in
                guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
                self.keyboardHeight = keyboardFrame.height
                
                boxesMove = -0.5
                
            }
            .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardWillHideNotification)) { _ in
                self.keyboardHeight = 0
            }
            .onReceive(networkManager.$response) { response in
                // Check if the response is not nil and if its status code is 200
                if let httpResponse = response, httpResponse.statusCode == 200 {
                    // Navigate to the next screen upon receiving a successful response
                    isNavigationActive = true
                }
            }
            .navigationBarBackButtonHidden(true)
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

struct Verification_Previews: PreviewProvider {
    static var previews: some View {
        Verification()
            .environmentObject(AppConfig(region: .efken))
            .environmentObject(PinHandler())
    }
}
