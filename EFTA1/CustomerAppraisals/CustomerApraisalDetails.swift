//
//  CustomerApraisalDetails.swift
//  EFTA1
//
//  Created by Joshua on 4/9/24.
//

import SwiftUI
import MapKit

struct CustomerApraisalDetails: View {
    let receiptItems: [(String, String)] = [
            ("ID number", "Makumbosho Ltd"),
            ("Type of business", "123445"),
            ("Equipment description", "1234567"),
            ("Equipment price", "2008-0100"),
        
        ]
    var userData: UserData
    @EnvironmentObject var config: AppConfig
    @Environment(\.presentationMode) var presentationMode


    var body: some View {
        GeometryReader { geometry in
        VStack{
            VStack{
            QuickIntro(title: "Alex Mwangiss", description: "Kindly proceed to appraise the customer after confirming their details",presentationMode: presentationMode)
            ZStack{
                MapComponent(geometry: geometry)
                CustomerDetailsReceiptBox(items: receiptItems,geometry: geometry)
                    .padding(.bottom,200)
                
            }
            }
            .padding(.top, -50)

            
            Spacer()

            HStack{
                Text("Schedule")
                    .foregroundColor(config.primaryColor) // Set text color to green
                    .frame(maxWidth: .infinity)
                    .frame(height: 30)
                    .padding()
                    .background(Color.clear)
                    .cornerRadius(20)
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(config.primaryColor, lineWidth: 2) // Set border color and width
                    )


                NavigationLink(destination: SiteDetails()){
                Text("Start")
                    .foregroundColor(.white)
                    .cornerRadius(8)
                    .frame(maxWidth: .infinity)
                    .frame(height:30)
                    .padding()
                    .background(config.primaryColor) // Set background color to green when enabled, gray when disabledx
                    .cornerRadius(20)

                    
                }
            }
            .padding()
            .padding(.top,-50)


            
            
            }
            
            
            
            
            
        }
      
        
        
    }
}

struct CustomerDetailsReceiptBox: View {
    let items: [(String, String)]
    let geometry: GeometryProxy

    @EnvironmentObject var config: AppConfig

    var body: some View {
        VStack(spacing: 10) {
            RoundedRectangle(cornerRadius: 10)
                .fill(Color(hex: "#F6F6F6").opacity(0.9))
                .frame(maxWidth: .infinity)
                .frame(height: geometry.size.height * 0.5)
                .padding()
                .overlay(
                    VStack(spacing: 0) {
                        Text("Customer details")
                            .foregroundColor(config.primaryColor)
                        ForEach(items, id: \.0) { item in
                            HStack {
                                Text(item.0)
                                    .padding(.leading,30)
                                Spacer()
                                Text(item.1)
                                    .padding(.trailing,30)
                            }
                            .padding(.vertical, 5)
                            Divider()
                        }
                        RoundedRectangle(cornerRadius: 20)
                            .fill(config.primaryColor.opacity(0.3))
                            .frame(height:40)
                            .padding()

                            .overlay(
                                HStack{
                                    Spacer()
                                    Image(systemName: "phone")
                                    Text("Contact Consumer ")
                                        .padding(.trailing,20)
                                    
                                    Spacer()
                                }
                            
                            )
                        
                        RoundedRectangle(cornerRadius: 20)
                            .fill(config.primaryColor.opacity(0.3))
                            .frame(height:40)
                            .padding()
                            .overlay(
                                HStack{
                                    Spacer()
                                    Image(systemName: "location")
                                    Text("Get Directions")
                                        .padding(.trailing,20)
                                    
                                    Spacer()
                                }
                            
                            )
                        
                    }
                )
        }
    }
}
struct MapComponent: View {
    let geometry: GeometryProxy

    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194),
        span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
    )

    var body: some View {
        Map(coordinateRegion: $region)
            .frame(height: geometry.size.height * 0.7)
            .cornerRadius(10)
    }
    
}
