import SwiftUI
import AlertToast
struct ConfirmPin: View {
    @State private var enteredPIN: String = ""
    private let pinLength = 4 // Define the length of the PIN
      @State var pinCode:String = ""
    @State private var shouldNavigate = false // State variable for navigation
    @EnvironmentObject var pinHandler: PinHandler
    @State private var showingConfirmation = false // State for showing the confirmation dialog

    @StateObject private var networkManager = NetworkManager()
     let goback = true // Make it static
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        
        
      
        GeometryReader { geometry in
        
        VStack {
            
            LogoAndTitleView(geometry: geometry, title: "Confirm PIN", subTitle: "Kindly confirm your 4 digit PIN for your account", presentationMode: presentationMode, goBack:goback)
              
                .toast(isPresenting: $showingConfirmation) {
                                     AlertToast(displayMode: .hud, type: .error(Color.red), title: "Error", subTitle: "Something went wrong. Please try again.")
                                 }

            // PIN Keyboard
            KeyPadView(pinCode: $pinCode,instruction:"Enter 4 digit pin")
                                .frame(minHeight:  geometry.size.height * 0.3,maxHeight:  geometry.size.height * 0.45)
                                .padding(.vertical,geometry.size.height * 0.06)
            
            
            NavigationLink(destination: SecurityQuestions(), isActive: $shouldNavigate) { // NavigationLink to the next page
                                   EmptyView() // Invisible navigation link
                               }
            
            
            
        }
    }
        .onChange(of: pinCode) { newValue in
                        // Check if the PIN length reaches 4
                        if newValue.count == pinLength {
                            
                            if pinCode != pinHandler.pinCode {
                                showingConfirmation = true
                            }
                            else {
                                NetworkManager.shared.setNewPin(pin: newValue, phoneNumber: pinHandler.phoneNumber) { success, error in
                                           if success {
                                               // PIN set successfully, you can perform any additional actions here if needed
                                               shouldNavigate = true
                                               print("PIN set successfully")
                                           } else {
                                               // Handle PIN setting failure
                                               print("Failed to set PIN: \(error?.localizedDescription ?? "Unknown error")")
                                           }
                                       }
                            }
                        }
            
            
           
        
    }
     
        .navigationBarHidden(true)

    
}
    



}
struct ConfirmPin_Previews: PreviewProvider {
    static var previews: some View {
        ConfirmPin()
            .environmentObject(AppConfig(region: .efken))
            .environmentObject(PinHandler())
    }
}
