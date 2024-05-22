//
//  SelectProfile.swift
//  EFTA1
//
//  Created by Joshua on 4/16/24.
//

import SwiftUI

struct SelectProfile: View {
    let goback = true
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        
        NavigationView {
        GeometryReader { geometry in
            VStack{
                
                LogoAndTitleView(geometry: geometry, title: "Select your profile", subTitle: "Hello, kindly select the type of profile you will be registering on the app", presentationMode: presentationMode, goBack: goback)
            .padding(.bottom,20)
                 
                VStack{
                RectangleOptions(imageIcon:"userOnboarding",geometry: geometry, title:"Individual", variable: 8)
                RectangleOptions(imageIcon:"leadershipIcon" ,geometry: geometry,title:"Sole proprietor", variable: 8)

                RectangleOptions(imageIcon:"groupIcon" ,geometry: geometry,title:"Partnership", variable: 8)
        
                }
                .padding(.trailing, 20.0)

                
      
                
                Spacer()
             
                
                
                }
            }
        }
        .navigationBarHidden(/*@START_MENU_TOKEN@*/true/*@END_MENU_TOKEN@*/)
        
}
}

