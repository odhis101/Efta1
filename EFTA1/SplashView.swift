import SwiftUI

struct SplashView: View {
    @State private var isActive = false
    @State private var destinationView: AnyView = AnyView(OnBoard())  // Default to Onboarding if no token
    
    @EnvironmentObject var config: AppConfig
    @StateObject private var authManager = AuthManager.shared

    var body: some View {
        NavigationView {
            GeometryReader { geometry in
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        Image(config.splashImageName)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width:geometry.size.width * 0.5)
                            .onAppear {
                                checkTokenStatus()
                            }
                        Spacer()
                    }
                    Spacer()
                }
                .edgesIgnoringSafeArea(.all)
                .navigationBarHidden(true)
                
                // Conditional navigation based on token presence
                .background(
                    NavigationLink(
                        destination: destinationView,
                        isActive: $isActive,
                        label: { EmptyView() }
                    )
                )
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
    
    private func checkTokenStatus() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {  // Delay for splash screen duration
            if let _ = AuthManager.shared.loadToken() {
                destinationView = AnyView(LoginOnBoarding())  // Set to login view if token exists
                print("this is auth manager",AuthManager.shared.loadPhoneNumber())
            } else {
                destinationView = AnyView(OnBoard())  // Set to initial onboarding if no token
            }
            isActive = true  // Trigger navigation after determining the destination
        }
    }
}
