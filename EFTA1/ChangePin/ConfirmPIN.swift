import SwiftUI
import AlertToast

struct ConfirmPIN: View {
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
    //@State private var isSuccess  // Success status for the toast
    @EnvironmentObject var resetPin: ResetPin
    @State private var isSuccess: Bool? = nil // Success status for the modal
    @State var showingConfirmation = false
    @State var showMismatch = false
    @State var showingModal = false
    @State var message = ""
    @State var passwords = ""


    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        NavigationView {
            GeometryReader { geometry in
                VStack {
                    LogoAndTitleView(geometry: geometry, title: "Create new PIN", subTitle: "Kindly create your 4 digit PIN for your account", presentationMode: presentationMode, goBack: goback)
                        .toast(isPresenting: $showAlert) {
                            AlertToast(displayMode: .hud, type: .error(Color.red), title: "Error", subTitle: "Login Error " + errorMessage)
                        }
                        .toast(isPresenting: $showMismatch) {
                            AlertToast(displayMode: .hud, type: .error(Color.red), title: "Error", subTitle: "New PIN does not match")
                        }

                    // PIN Keyboard
                    KeyPadView(pinCode: $pinCode, instruction: "Enter a 4 digit PIN")
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
        .navigationBarHidden(true) // Hide the navigation bar
        .onChange(of: pinCode) { newValue in
            // Check if the PIN length reaches 4
            if newValue.count == pinLength {
                 passwords = newValue
                showingModal = true
            }
        }
        .overlay(isLoading ? LoadingModal() : nil)
        .toast(isPresenting: $showToast) {
            AlertToast(type: isSuccess ?? true ? .complete(.green) : .error(.red), title: toastMessage)
        }
        .overlay(CustomModal(isPresented: $showingModal, isLoading: $isLoading, isSuccess: $isSuccess, message: $message, Navigation: $shouldNavigate, onSubmit: {
            loginWithPasscode(passcode: passwords)
        }))
    }

    private func loginWithPasscode(passcode: String) {
        isLoading = true
        showToast = false // Reset toast state

        guard let phoneNumber = AuthManager.shared.loadPhoneNumber() else {
            print("Phone number not found in Keychain")
            return
        }

        NetworkManager.shared.updatePin(phoneNumber: phoneNumber, oldPin: resetPin.OldPin, newPin: passcode) { success, message in
            DispatchQueue.main.async {
                self.isLoading = false
                self.isSuccess = success
                self.toastMessage = message
                self.showToast = true
                self.message = message
                //self.showingModal = true
                if success {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        self.shouldNavigate = true
                    }
                } else {
                    self.pinCode = ""
                }
            }
        }
    }
}
