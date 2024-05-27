//
//  CustomerOnboarding.swift
//  EFTA1
//
//  Created by Joshua on 4/1/24.
//

import SwiftUI

struct CustomerOnboarding: View {
    @State private var progress: CGFloat = 0.14 // Initial progress
    @Environment(\.presentationMode) var presentationMode


    var body: some View {
            GeometryReader { geometry in
                VStack {
                    ProgressBar(geometry: geometry, progress: $progress, presentationMode: presentationMode, title: "Customer onboarding", description: "Kindly collect the following information from the customer")
                    
                    


                    VStack{
                        ScrollView{
                    RectangleOptions(imageIcon:"userOnboarding",geometry: geometry, title:"Individual", variable: 1)
                    RectangleOptions(imageIcon:"leadershipIcon" ,geometry: geometry,title:"Sole proprietor", variable: 2)

                    RectangleOptions(imageIcon:"groupIcon" ,geometry: geometry,title:"Partnership", variable: 3)
                    RectangleOptions(imageIcon:"verified-user" ,geometry: geometry,title:"Trustees", variable: 4)

                    RectangleOptions(imageIcon:"groupOfUsers" ,geometry: geometry,title:"Groups or Amcos", variable: 5)
                    RectangleOptions(imageIcon:"corporate" ,geometry: geometry,title:"Limited Company", variable: 6)
                        }
                    }
                    .padding(.trailing, 25)


                    
           

                
            }
                
            }
           
        

    }
        
}

struct ProgressBar: View {
    let geometry: GeometryProxy
    @Binding var progress: CGFloat // Binding for dynamic progress
    @EnvironmentObject var config: AppConfig
    @Binding var presentationMode: PresentationMode // Binding for navigation
    
    @State private var showAlert = false // State for showing the alert


    let title:String
    
    let description:String

    var body: some View {
        VStack{
        HStack {
            Button(action: {
                print("pressed")
                self.presentationMode.dismiss()
                //self.showAlert = true // Set showAlert to true to show the alert

            }) {
                Image("Leading-icon-button")
                    .font(.system(size: 20))
                    .foregroundColor(Color(hex: "#49454F"))
                    .padding(.leading, 10)
            }
            
            .alert(isPresented: $showAlert) {
                          Alert(title: Text("Button Pressed"), message: nil, dismissButton: .default(Text("OK")))
                      }
            ZStack(alignment: .leading) {
                Rectangle()
                    .frame(width: geometry.size.width - 60, height: 10) // Adjusted width to account for padding
                    .foregroundColor(.gray.opacity(0.4))
                    .cornerRadius(10)
                
                Rectangle()
                    .frame(width: (geometry.size.width - 60) * progress, height: 10) // Adjusted width to account for padding
                    .foregroundColor(config.primaryColor)
                    .cornerRadius(10)
            }
            .padding(.trailing,30) // changed the progress thing 
        }
        .frame(width: geometry.size.width * 0.6) // Adjust width as needed
        .padding(.horizontal,20)
        .padding(.horizontal, 40)

        //.padding(.horizontal, 20) // Add horizontal padding to the HStack
        //.padding(.leading,50)

        HStack{
        VStack(alignment: .leading){
            Text(title)
                .font(.system(size: 24))
                .bold()
            
            Text(description)
                .font(.system(size: 12))
                .font(.headline)
                .foregroundColor(Color.gray)
        }
            Spacer ()
        }
        .padding(.horizontal)
        .navigationBarBackButtonHidden(true)
        .navigationBarHidden(true)
            


    }
        .padding(.top,10)

    }

               
}





struct RectangleOptions: View {
    @EnvironmentObject var onboardingData: OnboardingData
    let imageIcon :String
    
    let geometry: GeometryProxy
    
    let title:String
    
    let variable:Int
    
    @State private var isActive = false // Separate isActive state variable for each instance

  
    var body: some View {
        NavigationLink(destination: destinationView(), isActive: $isActive) { // Use separate isActive variable

        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .fill(Color(hex: "#F6F6F6"))
                //.shadow(color: Color.gray.opacity(0.4), radius: 4, x: 0, y: 2) // Add shadow
            
            HStack {
                Image(imageIcon) // Example icon
                    .foregroundColor(.blue) // Example color
                    .padding()
                
                Text(title) // Example text
                    .foregroundColor(.black) // Example color
                    .padding()
                Spacer()
              
                
                Image("navigate_next")
                    .font(.system(size: 12))
                    .foregroundColor(.gray)
                    .padding(.horizontal, 10)

                 
            }
        }
        .frame(width: geometry.size.width * 0.9, height: 80) // Adjust width as needed
        .padding(.leading,20)
    
    }
    }
    func destinationView() -> some View {
        switch variable {
        case 1:
            return AnyView(
                IndividualOnboarding()
                    .onAppear {
                        onboardingData.titleForCustomerOnboarding = "Individual"
                        isActive = false // Reset isActive when navigating

                    }
            )
        case 2:
            return AnyView(
                CompanyOnboarding()
                    .onAppear {
                        onboardingData.titleForCustomerOnboarding = "Sole Proprietor"
                        isActive = false // Reset isActive when navigating

                    }
            )
        case 3:
            return AnyView(
                CompanyOnboarding()
                    .onAppear {
                        onboardingData.titleForCustomerOnboarding = "Partnership"
                        isActive = false // Reset isActive when navigating

                    }
            )
        case 4:
            return AnyView(
                CompanyOnboarding()
                    .onAppear {
                        onboardingData.titleForCustomerOnboarding = "Trustees"
                        isActive = false // Reset isActive when navigating

                    }
            )
        case 5:
            return AnyView(
                CompanyOnboarding()
                    .onAppear {
                        onboardingData.titleForCustomerOnboarding = "Groups or Amcos"
                        isActive = false // Reset isActive when navigating

                    }
            )
        case 6:
            return AnyView(
                CompanyOnboarding()
                    .onAppear {
                        onboardingData.titleForCustomerOnboarding = "Limited Company"
                        isActive = false // Reset isActive when navigating

                    }
            )
        case 8:
            return AnyView(
                MyTabView()
                    .onAppear {
                        isActive = false // Reset isActive when navigating

                    }
                    
            )
            
        default:
            return AnyView(Text("Selection not available"))
        }
    }

            
}

