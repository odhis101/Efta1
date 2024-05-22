//
//  Login.swift
//  EFTA1
//
//  Created by Joshua on 3/28/24.
//

import SwiftUI

struct Login: View {
    @State private var enteredPIN: String = ""
    private let pinLength = 4 // Define the length of the PIN
    @State var pinCode:String = ""
    @State private var shouldNavigate = false // State variable for navigation
    @EnvironmentObject var config: AppConfig
    @State var showError = false 
    @EnvironmentObject var pinHandler: PinHandler
    let goback = true // Make it static

    @Environment(\.presentationMode) var presentationMode
    var body: some View {
        
        NavigationView {
        GeometryReader { geometry in
            VStack{
                
                LogoAndTitleView(geometry: geometry, title: "Login", subTitle: "Kindly provide your PIN to access your account", presentationMode: presentationMode, goBack: goback)
                 
        
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
            .alert(isPresented: $showError) {
                Alert(
                    title: Text("Pin Dont Match "),
                    message: Text("Please try again "),
                    primaryButton: .destructive(Text("Retry"), action: {
                        //shouldNavigate = true
                    }),
                    secondaryButton: .cancel({
                        // Optional: Handle cancellation
                    })
                )
            }

        
        
  
}
    private func loginWithPasscode(passcode: String) {
        NetworkManager.shared.mobileAppLogin(phoneNumber: pinHandler.phoneNumber, pin: passcode) { success, error in
            DispatchQueue.main.async {
                if success {
                    shouldNavigate = true // Navigate to the next screen
                } else {
                    shouldNavigate = true // Navigate to the next screen
                    //showError = true // Show error alert
                    print("Login error: \(error?.localizedDescription ?? "Unknown error")")
                    pinCode = "" // Reset PIN code
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
