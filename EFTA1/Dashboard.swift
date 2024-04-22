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
        VStack{
            
            TopDashboardComponent()
                .padding()
            PointsView(geometry: geometry)

           
       
            HStack{
                
            Text("What would you like to do")
                    .bold()
                    .padding()
                Spacer()

            }
            
            ScrollView {
                      LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 5) {
                          CustomComponent(iconName: "visit", text: "New Customer",variable: 1)
                          CustomComponent(iconName: "appraisal", text: "Customer Appraisal",variable: 2)
                          CustomComponent(iconName: "delivery1", text: "Equipment Delivery",variable: 3)
                          CustomComponent(iconName: "monitoring-system", text: "Customer Monitoring",variable: 4)
                          CustomComponent(iconName: "tow-truck", text: "Customer Repossession",variable: 5)
                          CustomComponent(iconName: "clipboard", text: "Reports",variable: 6)
                          CustomComponent(iconName: "fileFast", text: "Customer Statements",variable:7)
                      }
        
        
            }
            .padding()
             
            }
        .navigationBarHidden(true)
        }
        .navigationBarHidden(true)

    }

}




struct PointsView: View {
    @EnvironmentObject var config: AppConfig

    let geometry: GeometryProxy
    
    var body: some View {
        VStack {
            ZStack(alignment: .topLeading) {
                Image(config.dashboardColor)
                    //.frame(height: geometry.size.height * 0.3)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(height:200)
                    .frame(width: geometry.size.width * 0.90)
                    .foregroundColor(.purple)
                    .padding(.horizontal)
                

                VStack{
                    Text("Task Summary ")
                            .foregroundColor(.white)

                    .padding(.top,30)
                    .padding(.bottom,10)
                    
                    
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.gray.opacity(0.3))
                    .frame(height: 50)
                    .frame(width: geometry.size.width * 0.95)
                    .padding(.leading,10)
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
                                    .overlay(
                                        Text("2")
                                            .foregroundColor(.white) // Set the text color to white
                                            .font(.system(size: 16, weight: .bold)) // Adjust font size and weight as needed
                                    )

                                Image(systemName: "arrow.right")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 20, height: 20)
                                .foregroundColor(.white)
                                .padding()
                            
                    }
                    .padding()
                    
             
                }

                            )
                    
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.gray.opacity(0.3))
                        .frame(height: 50)
                        .frame(width: geometry.size.width * 0.95)
                        .padding(.top,10)
                        .padding(.leading,10)
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
                                        .overlay(
                                            Text("2")
                                                .foregroundColor(.white) // Set the text color to white
                                                .font(.system(size: 16, weight: .bold)) // Adjust font size and weight as needed
                                        )
                                Image(systemName: "arrow.right")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 20, height: 20)
                                .foregroundColor(.white)
                                .padding()
                                .foregroundColor(.white)
                            
                        }
                        .padding()
                        
                 
                    }

                                )
                    
                    
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
                        .font(.system(size: 20))
                        .padding(.leading, 10)
                      

                    Spacer()
                    Image(systemName: "arrow.right")
                        .font(.system(size: 12))
                        .foregroundColor(.gray)
                }
                .padding(.bottom, 10)
                
                
                Text(text)
                    .fixedSize(horizontal: false, vertical: true) // Allow text to wrap and grow vertically
                    .foregroundColor(.black)
                    .font(.headline)
                    .padding(.leading, 10)
                
            }
            .frame(width: UIScreen.main.bounds.width * 0.45, height: UIScreen.main.bounds.width * 0.25)
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
