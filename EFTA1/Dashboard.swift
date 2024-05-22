//
//  Dashboard.swift
//  EFTA1
//
//  Created by Joshua on 3/28/24.
//

import SwiftUI

struct Dashboard: View {
    var body: some View {
        GeometryReader { geometry in
            VStack(){
            ScrollView {

            TopDashboardComponent()
                    .padding()
            PointsView(geometry: geometry)

           
       
            HStack{
                
            Text("What would you like to do")
                    .font(.system(size: 16)) // Adjust font size and weight as needed
                    .foregroundColor(/*@START_MENU_TOKEN@*/.black/*@END_MENU_TOKEN@*/)
                    .bold()
                    
                Spacer()

            }
            .padding(.top,10)   
            .padding()
            
         
                      LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 15) {
                          CustomComponent(iconName: "visit 1", text: "New          Customer",variable: 1)
                          CustomComponent(iconName: "appraisal 1", text: "Customer Appraisal",variable: 2)
                          CustomComponent(iconName: "delivery 1", text: "Equipment Delivery",variable: 3)
                          CustomComponent(iconName: "monitoring-system 2", text: "Customer Monitoring",variable: 4)
                          CustomComponent(iconName: "towing-vehicle 1", text: "Customer Repossession",variable: 5)
                          CustomComponent(iconName: "clipboard_1273337 1", text: "Reports",variable: 6)
                          CustomComponent(iconName: "file_10900273 1", text: "Customer Statements",variable:7)
                      }
                      .padding()
        
        
            }
         

             
            }


        .navigationBarHidden(true)
        }
        .navigationBarHidden(true)
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

                    
                    
                    
                    
                    /*
                    Button(action: {
                        // Navigate to the desired view
                        navigateToApprasial = true
                    }) {
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color.gray.opacity(0.3))
                            .frame(height: 40)
                            .frame(width: geometry.size.width * 0.95)
                            .padding(.leading, 10)
                            .overlay(
                                VStack(spacing: 0) {
                                    HStack {
                                        Image("appraisal")
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .frame(width: 20, height: 20)
                                            .foregroundColor(.white)

                                        Text("Customer appraisal")
                                            .font(.headline)
                                            .foregroundColor(.white)
                                            .padding(.horizontal)

                                        Spacer()

                                        Circle()
                                            .foregroundColor(.green) // Set the circle color to green
                                            .frame(width: 20, height: 20) // Adjust size as needed
                                            .padding()
                                            .overlay(
                                                Text("2")
                                                    .foregroundColor(.white) // Set the text color to white
                                                    .font(.system(size: 15)) // Adjust font size and weight as needed
                                            )

                                        Image(systemName: "arrow.right")
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .frame(width: 15, height: 15)
                                            .foregroundColor(.white)
                                            .padding()
                                    }
                                    .padding()
                                }
                            )
                    }

                    Button(action: {
                        // Navigate to the desired view
                        navigateToMonitoring = true
                    }) {

                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color.gray.opacity(0.3))
                            .frame(height: 40)
                            .frame(width: geometry.size.width * 0.95)
                            .padding(.top,10)
                            .padding(.leading,10)
                            .overlay(
                                VStack(spacing: 0) {
                                    HStack {
                                        Image("monitoring-system")
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .frame(width: 20, height: 20)
                                            .foregroundColor(.white)

                                        Text("Customer monitoring")
                                            .font(.headline)
                                            .foregroundColor(.white)
                                            .padding(.horizontal)

                                        Spacer()
                                        Circle()
                                            .foregroundColor(.green) // Set the circle color to green
                                            .frame(width: 20, height: 20) // Adjust size as needed
                                            .padding()
                                            .overlay(
                                                Text("2")
                                                    .foregroundColor(.white) // Set the text color to white
                                                    .font(.system(size: 15)) // Adjust font size and weight as needed
                                            )
                                        Image(systemName: "arrow.right")
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .frame(width: 15, height: 15)
                                            .foregroundColor(.white)
                                            .padding()
                                    }
                                    .padding()
                                }
                            )
                    }
                    */
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

    var body: some View {
        HStack{
            VStack(alignment: .leading){
                
            Text("Good Morning, Nuhu")
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
            
            HStack{
                // get image called bell and image called burgericon
                Image("bell")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 20, height: 20)
                
                Image("burgerMenu")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 20, height: 20)

            
            
                }

            }


    }
}
