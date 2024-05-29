//
//  Dashboard.swift
//  EFTA1
//
//  Created by Joshua on 3/28/24.
//

import SwiftUI

struct Dashboard: View {
    @State private var isMenuPresented = false
    @State private var isNavigateToChangePin = false
    @State private var isNavigateLogin = false

    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                VStack {
                    ScrollView {
                        TopDashboardComponent(isMenuPresented: $isMenuPresented)
                            .padding()
                        PointsView(geometry: geometry)

                        HStack {
                            Text("What would you like to do")
                                .font(.system(size: 16))
                                .foregroundColor(.black)
                                .bold()
                            Spacer()
                        }
                        .padding(.top, 10)
                        .padding()

                        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 15) {
                            CustomComponent(iconName: "visit 1", text: "New \nCustomer", variable: 1)
                            CustomComponent(iconName: "appraisal 1", text: "Customer \nAppraisal", variable: 2)
                            CustomComponent(iconName: "delivery 1", text: "Equipment \n Delivery", variable: 3)
                            CustomComponent(iconName: "monitoring-system 2", text: "Customer \nMonitoring", variable: 4)
                            CustomComponent(iconName: "towing-vehicle 1", text: "Customer \nRepossession", variable: 5)
                            CustomComponent(iconName: "clipboard_1273337 1", text: "Reports", variable: 6)
                            CustomComponent(iconName: "file_10900273 1", text: "Customer\nStatements", variable: 7)
                        }
                        .padding()
                    }
                }
                .disabled(isMenuPresented) // Disable interaction with the background when the menu is presented

                BottomSheet(isPresented: $isMenuPresented) {
                    VStack {
                        Button(action: {
                            print("Change PIN selected")
                            isNavigateToChangePin = true
                            isMenuPresented = false
                        }) {
                            Text("Change PIN")
                                .padding()
                                .frame(maxWidth: .infinity)
                        }
                        .background(Color.white)
                        .cornerRadius(8)
                        .shadow(radius: 2)

                        Button(action: {
                            print("Log Out selected")
                            isMenuPresented = false
                            AuthManager.shared.deleteToken()
                            isNavigateLogin = true


                        }) {
                            Text("Log Out")
                                .padding()
                                .frame(maxWidth: .infinity)
                        }
                        .background(Color.white)
                        .cornerRadius(8)
                        .shadow(radius: 2)
                        .padding(.bottom, 100) // Adjust this value to control how high the bottom sheet appears

                    }
                    .padding()
                }
            }
            NavigationLink(destination: ChangePin(), isActive: $isNavigateToChangePin) { EmptyView() }

            NavigationLink(destination: LoginOnBoarding(), isActive: $isNavigateLogin) { EmptyView() }

        }
        .navigationBarHidden(true)
    }
}




struct PointsView: View {
    @EnvironmentObject var config: AppConfig

    let geometry: GeometryProxy
    
    @State private var navigateToApprasial = false
    @State private var navigateToMonitoring = false
    
    var body: some View {
        VStack() {
            ZStack() {
                Image(config.dashboardColor)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(height: 220)
                    .frame(width: geometry.size.width * 0.95)
                    .foregroundColor(.purple)
                    .cornerRadius(20)
                
                VStack{
                    HStack{
                        Text("Task Summary ")
                            .foregroundColor(.white)
                            .padding(.top,30)
                            .padding(.bottom,10)
                            .padding(.leading,30)
                        Spacer()
                    }
                    .padding(.horizontal)
                    
                    VStack(alignment: .center){
                        
                        Button(action: {
                            // Navigate to the desired view
                            navigateToApprasial = true
                        }) {
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color.gray.opacity(0.5))
                            .frame(height:50)
                            .frame(width:geometry.size.width * 0.84)
                            .padding(.bottom,10)
                            .overlay(
                                VStack(alignment: .center) {
                                    HStack {
                                        Image("appraisal 2")
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .frame(width: 20, height: 20)
                                            .foregroundColor(.white)

                                        Text("Customer appraisal")
                                            .foregroundColor(.white)
                                            .padding(.horizontal)

                                        Spacer()

                                        Circle()
                                            .foregroundColor(.green) // Set the circle color to green
                                            .frame(width: 15, height: 15) // Adjust size as needed
                                            
                                        
                                            .overlay(
                                                Text("2")
                                                    .foregroundColor(.white) // Set the text color to white
                                                    .font(.system(size: 12)) // Adjust font size and weight as needed
                                            )

                                        Image("icon-1")
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .padding(.leading,2)
                                            .frame(width: 10, height: 10)
                                            .foregroundColor(.white)
                                        
                                    }
                                    .padding(.top,-5)
                                    .padding()
                                }
                            )
                        }
                        Button(action: {
                            // Navigate to the desired view
                            navigateToMonitoring = true
                        }) {
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color.gray.opacity(0.5))
                            .frame(height:50)
                            .frame(width:geometry.size.width * 0.84)
                            .padding(.bottom,10)
                            .overlay(
                                VStack(alignment: .center) {
                                    HStack {
                                        Image("monitoring-system 1")
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .frame(width: 20, height: 20)
                                            .foregroundColor(.white)

                                        Text("Customer monitoring")
                                            .foregroundColor(.white)
                                            .padding(.horizontal)

                                        Spacer()
                                        Circle()
                                            .foregroundColor(.green) // Set the circle color to green
                                            .frame(width: 15, height: 15) // Adjust size as needed
                                            
                                        
                                            .overlay(
                                                Text("2")
                                                    .foregroundColor(.white) // Set the text color to white
                                                    .font(.system(size: 12)) // Adjust font size and weight as needed
                                            )
                                        Image("icon-1")
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .padding(.leading,2)
                                            .frame(width: 10, height: 10)
                                            .foregroundColor(.white)

                                            
                                    }
                                    .padding(.top,-5)
                                    .padding()
                                }
                            )

                            
                        }
                        
                        
                        
                        
                        
                        
                    }
                    .padding(.top,5)

                    
                    Spacer()

                    NavigationLink(destination: CustomerApraisalsSearch(), isActive: $navigateToApprasial) { EmptyView() }
                    NavigationLink(destination: CustomerMonitoringSearch(), isActive: $navigateToMonitoring) { EmptyView() }
                }
            }
        }
    
}
}

struct CustomComponent: View {
    var iconName: String
    var text: String
    var variable: Int
    
    var body: some View {
        NavigationLink(destination: destinationView()) {
            VStack(alignment: .leading ){
                HStack() {
                    Image(iconName)
                        .font(.system(size: 14))
                        .padding(.leading, 10)
                        .padding(.horizontal, 10)
                        .padding(.top,5)

                      

                    Spacer()
                    Image("navigate_next")
                        .font(.system(size: 12))
                        .foregroundColor(.gray)
                        .padding(.horizontal, 10)

                }
                .padding(.bottom, 10)
                
                
                Text(text)
                    .multilineTextAlignment(.leading)
                    .fixedSize(horizontal: false, vertical: true) // Allow text to wrap and grow vertically
                    .foregroundColor(Color(hex: "#343E25"))
                    .font(.headline)
                    .padding(.horizontal, 10)
                
            }
            .frame(width: UIScreen.main.bounds.width * 0.43, height: UIScreen.main.bounds.width * 0.30)
            .background(Color(hex: "#E1E2E2").opacity(0.5))
            .cornerRadius(10)
        }
    }
    
    func destinationView() -> some View {
        // Determine the destination view based on the variable
        if variable == 1 {
            return AnyView(CustomerOnboarding())
        }
        if variable == 2 {
            return AnyView(CustomerApraisalsSearch())
        }
        if variable == 3 {
            return AnyView(EquipmentUserPage())
        }
        if variable == 4 {
            return AnyView(CustomerMonitoringSearch())
        }
        if variable == 5 {
            return AnyView(CustomerReposessions())
        }
        if variable == 6 {
            return AnyView(Reports())
        }
        if variable == 7 {
            return AnyView(Statements())
        }
        
        
        
        else {
            // Add more cases for different variables if needed
            return AnyView(CustomerMonitoringSearch())
        }
    }
}



struct TopDashboardComponent: View {
    @EnvironmentObject var config: AppConfig
    @Binding var isMenuPresented: Bool
    @State private var username: String = ""

    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text("Good Morning, \(username)")
                    .fontWeight(.bold)
                    .foregroundColor(.black)
                    .font(.title2)

                Text("last login: 04:00pm")
                    .font(.headline)
                    .foregroundColor(Color.gray)

                Rectangle()
                    .frame(height: 2)
                    .foregroundColor(config.primaryColor)
                    .frame(width: 38)
            }
            Spacer()

            HStack {
                Image("bell")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 20, height: 20)

                Button(action: {
                    withAnimation {
                        isMenuPresented.toggle()
                    }
                }) {
                    Image("burgerMenu")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 20, height: 20)
                }
            }
        }
        .onAppear {
            if let loadedUsername = AuthManager.shared.loadUsername() {
                username = loadedUsername
            } else {
                print("Username not found in Keychain")
            }
        }
    }
}

struct BottomSheet<Content: View>: View {
    @Binding var isPresented: Bool
    let content: Content

    init(isPresented: Binding<Bool>, @ViewBuilder content: () -> Content) {
        self._isPresented = isPresented
        self.content = content()
    }

    var body: some View {
        ZStack {
            if isPresented {
                Color.black.opacity(0.3)
                    .edgesIgnoringSafeArea(.all)
                    .onTapGesture {
                        withAnimation {
                            isPresented = false
                        }
                    }

                VStack {
                    Spacer()
                    VStack {
                        content
                    }
                    .background(Color.white)
                    .cornerRadius(16)
                    .shadow(radius: 10)
                    .transition(.move(edge: .bottom))
                    .animation(.easeInOut)
                }
                .edgesIgnoringSafeArea(.bottom)
            }
        }
    }
}
