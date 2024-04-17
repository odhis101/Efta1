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

    var body: some View {
        
        NavigationView {
        GeometryReader { geometry in
            VStack{
        LogoAndTitleView(geometry: geometry, title: "Login", subTitle: "Kindly provide your PIN to access your account")
            .padding(.bottom,40)
        
        // PIN Keyboard
        KeyPadView(pinCode: $pinCode,instruction:"Enter Pi")
                            .frame(minHeight:  geometry.size.height * 0.3,maxHeight:  geometry.size.height * 0.45)
                            .padding(.vertical,10)
                
                Spacer()
                NavigationLink(destination: forgotPin()){
                    Text("Forgot Pin")
                        .foregroundColor(Color(hex: "#2AA241"))
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
                                // Navigate to the next page
                                print("this is true")
                                shouldNavigate = true
                            }

    }
}
}
