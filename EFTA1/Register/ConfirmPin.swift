import SwiftUI

struct ConfirmPin: View {
    @State private var enteredPIN: String = ""
    private let pinLength = 4 // Define the length of the PIN
      @State var pinCode:String = ""
    @State private var shouldNavigate = false // State variable for navigation
    @EnvironmentObject var pinHandler: PinHandler
    @State private var showingConfirmation = false // State for showing the confirmation dialog

    @StateObject private var networkManager = NetworkManager()
    

    var body: some View {
        
        
      
        GeometryReader { geometry in
        
        VStack {
            
            LogoAndTitleView(geometry: geometry, title: "Confirm PIN", subTitle: "Kindly confirm your 4 digit PIN for your account")
                .padding(.bottom,40)
            
            // PIN Keyboard
            KeyPadView(pinCode: $pinCode,instruction:"enter 4 digit pin")
                                .frame(minHeight:  geometry.size.height * 0.3,maxHeight:  geometry.size.height * 0.45)
                                .padding(.vertical,10)
            
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
                                shouldNavigate = true
                                
                            }
                        }
            
            
           
        
    }
        .alert(isPresented: $showingConfirmation) {
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



}
