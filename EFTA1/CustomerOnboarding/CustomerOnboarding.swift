//
//  CustomerOnboarding.swift
//  EFTA1
//
//  Created by Joshua on 4/1/24.
//

import SwiftUI

struct CustomerOnboarding: View {
    @State private var progress: CGFloat = 0.2 // Initial progress


    var body: some View {
            GeometryReader { geometry in
                VStack {
                    ProgressBar(geometry: geometry, progress: $progress,title:"Customer onboarding",description: "Kindly collect the following information from the customer")
                        .padding(.trailing, 20)


                    VStack{
                        ScrollView{
                    RectangleOptions(imageIcon:"userOnboarding",geometry: geometry, title:"Individual", variable: 1)
                    RectangleOptions(imageIcon:"leadershipIcon" ,geometry: geometry,title:"Sole proprietor", variable: 2)

                    RectangleOptions(imageIcon:"groupIcon" ,geometry: geometry,title:"Partnership", variable: 3)
                    RectangleOptions(imageIcon:"verified-user" ,geometry: geometry,title:"Trustees", variable: 4)

                    RectangleOptions(imageIcon:"groupOfUsers" ,geometry: geometry,title:"groups or Amcos", variable: 5)
                    RectangleOptions(imageIcon:"corporate" ,geometry: geometry,title:"Limmid Company", variable: 6)
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

    let title:String
    
    let description:String
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        HStack {
            Button(action: {
                   self.presentationMode.wrappedValue.dismiss()
                print("pressed back")
               }) {
                   Image(systemName: "arrow.left")
                       .font(.system(size: 20))
                       .padding(.leading, 10)
               }
            ZStack(alignment: .leading) {
                Rectangle()
                    .frame(width: geometry.size.width - 40, height: 20) // Adjusted width to account for padding
                    .foregroundColor(.gray)
                    .cornerRadius(10)
                
                Rectangle()
                    .frame(width: (geometry.size.width - 40) * progress, height: 20) // Adjusted width to account for padding
                    .foregroundColor(config.primaryColor)
                    .cornerRadius(10)
            }
        }
        .frame(width: geometry.size.width * 0.8) // Adjust width as needed
        .padding(.horizontal, 20) // Add horizontal padding to the HStack
        .padding(.leading,10)
        .padding(.top,-50)

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
        .padding(.top,-20)

    }
}




struct RectangleOptions: View {
    @EnvironmentObject var onboardingData: OnboardingData
    let imageIcon :String
    
    let geometry: GeometryProxy
    
    let title:String
    
    let variable:Int
  
    var body: some View {
        NavigationLink(destination: destinationView()) {

        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.white)
                .shadow(color: Color.gray.opacity(0.4), radius: 4, x: 0, y: 2) // Add shadow
            
            HStack {
                Image(imageIcon) // Example icon
                    .foregroundColor(.blue) // Example color
                    .padding()
                
                Text(title) // Example text
                    .foregroundColor(.black) // Example color
                    .padding()
                /*
                Spacer()
                
                Image(systemName: "chevron.right") // Example arrow icon
                    .foregroundColor(.black) // Example color
                    .padding()
                 */
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
                    }
            )
        case 2:
            return AnyView(
                IndividualOnboarding()
                    .onAppear {
                        onboardingData.titleForCustomerOnboarding = "Sole Proprietor"
                    }
            )
        case 3:
            return AnyView(
                IndividualOnboarding()
                    .onAppear {
                        onboardingData.titleForCustomerOnboarding = "Partnership"
                    }
            )
        case 4:
            return AnyView(
                IndividualOnboarding()
                    .onAppear {
                        onboardingData.titleForCustomerOnboarding = "Trustees"
                    }
            )
        case 5:
            return AnyView(
                IndividualOnboarding()
                    .onAppear {
                        onboardingData.titleForCustomerOnboarding = "Groups or Amcos"
                    }
            )
        case 6:
            return AnyView(
                IndividualOnboarding()
                    .onAppear {
                        onboardingData.titleForCustomerOnboarding = "Limmid Company"
                    }
            )
        case 8:
            return AnyView(
                MyTabView()
                    
            )
            
        default:
            return AnyView(Text("Selection not available"))
        }
    }

            
}
