//
//  createNewPin.swift
//  EFTA1
//
//  Created by Joshua on 5/29/24.
//

import SwiftUI
import AlertToast

struct CreateNewPin: View {
    @State private var enteredPIN: String = ""
    private let pinLength = 4 // Define the length of the PIN
    @State var pinCode:String = ""
    @State private var shouldNavigate = false // State variable for navigation
    @EnvironmentObject var config: AppConfig
    @State var showError = false
    @EnvironmentObject var pinHandler: PinHandler
    @EnvironmentObject var resetPin: ResetPin

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
                
                LogoAndTitleView(geometry: geometry, title: "Create new PIN", subTitle: "Kindly create your 4 digit PIN for your account", presentationMode: presentationMode, goBack: goback)
                
                    .toast(isPresenting: $showAlert) {
                                         AlertToast(displayMode: .hud, type: .error(Color.red), title: "Error", subTitle: "Login Error" + errorMessage)
                                     }
        
        // PIN Keyboard
        KeyPadView(pinCode: $pinCode,instruction:"Enter a 4 digit PIN ")
                            .frame(minHeight:  geometry.size.height * 0.3,maxHeight:  geometry.size.height * 0.45)
                            .padding(.vertical,geometry.size.height * 0.06)
                
                Spacer()
           
                
                
                

                NavigationLink(destination: ConfirmPIN(), isActive: $shouldNavigate) { // NavigationLink to the next page
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
        
        resetPin.NewPin = passcode
        shouldNavigate = true // Navigate to the next screen
   
    }
}


struct CreateNewPin_Previews: PreviewProvider {
    static var previews: some View {
        Login()
            .environmentObject(AppConfig(region: .efken))
            .environmentObject(PinHandler())
    }
}
