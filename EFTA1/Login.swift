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
    @State var pinCode:String = ""
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
    

    @Environment(\.presentationMode) var presentationMode
    var body: some View {
        
        NavigationView {
        GeometryReader { geometry in
            VStack{
                
                LogoAndTitleView(geometry: geometry, title: "Login", subTitle: "Kindly provide your PIN to access your account", presentationMode: presentationMode, goBack: goback)
                
                    .toast(isPresenting: $showAlert) {
                                         AlertToast(displayMode: .hud, type: .error(Color.red), title: "Error", subTitle: "Login Error" + errorMessage)
                                     }
        
        // PIN Keyboard
        KeyPadView(pinCode: $pinCode,instruction:"Enter Pin")
                            .frame(minHeight:  geometry.size.height * 0.3,maxHeight:  geometry.size.height * 0.45)
                            .padding(.vertical,geometry.size.height * 0.06)
                
                Spacer()
                NavigationLink(destination: forgotPin()){
                    Text("Forgot Pin")
                        .foregroundColor(config.primaryColor)
                }
                
                
                

                NavigationLink(destination: MyTabView(), isActive: $shouldNavigate) { // NavigationLink to the next page
                                       EmptyView() // Invisible navigation link
                                   }
                
                
                }
            }
        }        .navigationBarHidden(true) // Hide the navigation bar
        
            .onChange(of: pinCode) { newValue in
                print("change something changed ")
                print("new value",newValue)
                print(newValue.count)
                            // Check if the PIN length reaches 4
                            if newValue.count == pinLength {
                                
                                loginWithPasscode(passcode: newValue)

                                
                              
                            }

    }
            .overlay(isLoading ? LoadingModal() : nil)
            .toast(isPresenting: $showToast) {
                AlertToast(type: isSuccess ? .complete(.green) : .error(.red), title: toastMessage)
            }
        

        
        
  
}
    private func loginWithPasscode(passcode: String) {
        // Retrieve phone number from Keychain
        //shouldNavigate = true // Navigate to the next screen
        isLoading = true


        guard let phoneNumber = AuthManager.shared.loadPhoneNumber() else {
            print("Phone number not found in Keychain")
            
            return
        }
        print("this the first request asking for number ", phoneNumber)

        // network that might cause annoying bugs later 
        
        NetworkManager.shared.mobileAppLogin(phoneNumber: phoneNumber, pin: passcode) { success, error in
            DispatchQueue.main.async {
                
                self.isLoading = false
                self.showToast = true
                self.isSuccess = success
                self.shouldNavigate = true
                //self.toastMessage = error
                print("Login error: \(error?.localizedDescription ?? "Unknown error")")

                
                // Hide toast after 3 seconds
                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                    self.showToast = false
                }
            }
        }
    }
}
struct Login_Previews: PreviewProvider {
    static var previews: some View {
        Login()
            .environmentObject(AppConfig(region: .efken))
            .environmentObject(PinHandler())
    }
}
