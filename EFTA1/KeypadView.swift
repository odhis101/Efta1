//
//  KeyPadView.swift
//  mobilebanking
//
//  Created by Daniel Kimani on 07/02/2024.
//

import Foundation
import SwiftUI


struct KeyPadView:View{
    
    
    @State var state:CalculationState = CalculationState()
    
    @Binding var pinCode:String
    var instruction:String
    
    var displayedNumber :String {
        let s = String (state.currentNumber)
        let maskedName = String(repeating: "*", count: s.count)
        return  maskedName
    }
    
    var body: some View{
        VStack(spacing:0){
            Spacer()
            CircleView(name: displayedNumber)
                .padding(.top,20)
            
            Text(instruction)
                .font(.headline)
                .foregroundColor(Color.gray)
                .padding(.bottom,20)
                .padding()

            
            
            
            Spacer()
            VStack{
                //123
                HStack{
                    NumberView(number: 1,state: $state)
                    Spacer()
                    NumberView(number: 2,state: $state)
                    Spacer()
                    NumberView(number: 3,state: $state)
                }.padding(.vertical,4)
                //456
                HStack{
                    NumberView(number: 4,state: $state)
                    Spacer()
                    NumberView(number: 5,state: $state)
                    Spacer()
                    NumberView(number: 6,state: $state)
                }
                .padding(.vertical,4)
                //789
                HStack{
                    NumberView(number: 7,state: $state)
                    Spacer()
                    NumberView(number: 8,state: $state)
                    Spacer()
                    NumberView(number: 9,state: $state)
                }
                .padding(.vertical,4)
                //0 ,Clear
                HStack{
                    //NumberView(number: 7,state: $state)
                    
                    Spacer()
                    Spacer()
                    NumberView(number: 0,state: $state)
                        .padding(.leading, 10.0)

                    
                    Spacer()
                    ClearButtonView(state: $state)
                }
                .padding(.vertical,4)
            }
            Spacer()
        }
        //.padding(.vertical,8)
        .padding(.horizontal,32)
        .onChange(of: state.currentNumber) { newValue in
            pinCode = newValue
        }
    }
    
}

struct CircleView: View {
    let name: String
    @EnvironmentObject var config: AppConfig

    
    var body: some View {
        HStack(spacing: 10) {
            ForEach(0..<4) { index in
                Circle()
                    .foregroundColor(index < self.name.count ? config.primaryColor : .gray.opacity(0.5))
                    .frame(width: 20, height: 20)
                /*
                 .overlay(
                 Text(index < self.name.count ? String(self.name[self.name.index(self.name.startIndex, offsetBy: index)]) : "")
                 .foregroundColor(.white)
                 )
                 */
                
            }
        }
    }
}

struct NumberView: View {
    let number: Int
    @Binding var state: CalculationState
    
    var numberString: String {
        return String(Int(number))
    }
    
    var body: some View {
        Button(action: {
            self.state.appendNumber(numberString)
        }) {
            ZStack {
                Circle()
                    .foregroundColor(Color.gray.opacity(0.2)) // Gray background with high opacity
                    .frame(width: 64, height: 64)
                
                Text(numberString)
                    .foregroundColor(Color.black)
                    .font(.title)
                    .bold()
            }
        }
        .frame(width: 64, height: 64)
        .padding(4) // Add some padding to the button
    }
}



struct ClearButtonView:View{
    @Binding var state:CalculationState
    
    var body: some View{
        //Image(systemName: "xmark.diamond.fill")
        Image("arrow-back-keypad")
            .font(.title)
            .foregroundColor(Color.black)
            .frame(width: 64,height: 64)
        //.background(Color.blue)
            .cornerRadius(40)
        //.shadow(color: .blue, radius: 10,x: 0,y: 10)
            .onTapGesture { //[unowned self] in
                state.dropLastNumber()
            }
    }
    
}


struct CalculationState{
    
    var currentNumber:String = ""
    
    mutating func appendNumber(_ input :String){
        if currentNumber != ""{
            if currentNumber.count >= 4{
                //DO NOT ADD
            }else{
                currentNumber += input
            }
        }else{
            currentNumber = input
        }
        
        
    }
    
    mutating func dropLastNumber(){
        if currentNumber != "" || currentNumber !=  nil{
            let s = String(currentNumber).dropLast()
            currentNumber = String(s)
            print("1 \(currentNumber)")
        }else{
            currentNumber = ""
            print("2 \(currentNumber)")
        }
    }
}


