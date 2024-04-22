import SwiftUI

struct PINEntryView: View {
    @State private var enteredPIN: String = ""
    private let pinLength = 4 // Define the length of the PIN

    @EnvironmentObject var pinHandler: PinHandler
    
    @State private var shouldNavigate = false // State variable for navigation

    
    var body: some View {
        
        
    
        GeometryReader { geometry in
        
        VStack {
            LogoAndTitleView(geometry: geometry, title: "Create new PIN", subTitle: "Kindly create a 4 digit PIN for your account")
                .padding(.bottom,60)

            // PIN Keyboard
            KeyPadView(pinCode: $pinHandler.pinCode,instruction:"enter 4 digit pin")
                                .frame(minHeight:  geometry.size.height * 0.3,maxHeight:  geometry.size.height * 0.45)
                                .padding(.vertical,10)
            
            NavigationLink(destination: ConfirmPin(), isActive: $shouldNavigate) { // NavigationLink to the next page
                                   EmptyView() // Invisible navigation link
                               }
            
            
        }
    }
        .onChange(of: pinHandler.pinCode) { newValue in
            print("change something changed ")
            print("new value",newValue)
            print(newValue.count)
                        // Check if the PIN length reaches 4
                        if newValue.count == pinLength {
                            // Navigate to the next page
                            // save this to the enviroment and send it later 
                            print("this is true")
                            shouldNavigate = true
                        }
            
          
        }
        }
    }
    


struct PINDotView: View {
    let isFilled: Bool
    @EnvironmentObject var config: AppConfig

    
    var body: some View {
        Circle()
            .fill(isFilled ? config.primaryColor : Color.gray)
            .frame(width: 20, height: 20)
    }
}
struct LogoAndTitleView: View {
    @EnvironmentObject var config: AppConfig
    let geometry: GeometryProxy
    var title: String
    var subTitle : String
    
    var body: some View {
        VStack {
            Image(config.splashImageName)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: geometry.size.width * 0.3, height: geometry.size.width * 0.2)
                .padding(.top, -100)
            
            VStack(alignment: .leading) {
                Text(title)
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(config.primaryColor)
                
                Text(subTitle)
                    .font(.headline)
                    .foregroundColor(Color.gray)
            }
            .frame(maxWidth: .infinity, alignment: .leading) // Allow the VStack to expand horizontally
            .padding()
        }
    }
}


