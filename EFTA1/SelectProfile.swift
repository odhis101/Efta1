//
//  SelectProfile.swift
//  EFTA1
//
//  Created by Joshua on 4/16/24.
//

import SwiftUI

struct SelectProfile: View {

    var body: some View {
        
        NavigationView {
        GeometryReader { geometry in
            VStack{
        LogoAndTitleView(geometry: geometry, title: "Login", subTitle: "Hello, kindly select the type of profile you will be registering on the app")
            .padding(.bottom,40)
                
                RectangleOptions(imageIcon:"userOnboarding",geometry: geometry, title:"Individual", variable: 8)
                RectangleOptions(imageIcon:"leadershipIcon" ,geometry: geometry,title:"Sole proprietor", variable: 8)

                RectangleOptions(imageIcon:"groupIcon" ,geometry: geometry,title:"Partnership", variable: 8)
        
      
                
                Spacer()
             
                
                
                }
            }
        }
        
}
}

