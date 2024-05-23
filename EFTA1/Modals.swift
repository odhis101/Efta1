//
//  Modals.swift
//  EFTA1
//
//  Created by Joshua on 5/23/24.
//

import SwiftUI

struct Modals: View {
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

struct ModalViewDgfcZAutryataLoaded : View {
    
    @State var isSuccess = false
    
    

    var body: some View {
        GeometryReader { geometry in
            VStack {
                RoundedRectangle(cornerRadius: 10)
                    .frame(width: geometry.size.width * 0.7, height: geometry.size.height * 0.4)
                    .foregroundColor(.white)
                    .overlay(
                        VStack{
                            HStack{
                                if isSuccess{
                                    Image("correct")
                                }
                                else{
                                    Image("correct")
                                    
                                }
                                
                            }
                            
                        }
                    )
            }
        }
    }
}

