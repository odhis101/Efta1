//
//  SecurityQuestions.swift
//  EFTA1
//
//  Created by Joshua on 3/28/24.
//

import SwiftUI

struct SecurityQuestions: View {
    let questions = ["What is your favorite color?", "What is your pet's name?", "Where were you born?"]
        @State private var selectedQuestionIndex = 0
        @State private var isExpanded: Bool = false
        @State private var selectedQuestion1: String?
        @State private var selectedQuestion2: String?
        @State private var selectedQuestion3: String?
        @State private var answer1: String = ""
        @State private var answer2: String = ""
        @State private var answer3: String = ""



    var body: some View {
        GeometryReader { geometry in
        
        VStack {
            LogoAndTitleView(geometry: geometry, title: "Set your security questions", subTitle: "Kindly set security questions to be able to reset your PIN incase you forget")
                .padding(.bottom,10)
                        
            QuestionWithDropdown(question: "Security Question #1:", options: availableOptions(selectedQuestion1, excluding: [selectedQuestion2, selectedQuestion3]), selectedOption: $selectedQuestion1)
            AnswerView(answer: $answer1)
            QuestionWithDropdown(question: "Security Question #2:", options: availableOptions(selectedQuestion2, excluding: [selectedQuestion1, selectedQuestion3]), selectedOption: $selectedQuestion2)
            AnswerView(answer: $answer2)
            QuestionWithDropdown(question: "Security Question #3:", options: availableOptions(selectedQuestion3, excluding: [selectedQuestion1, selectedQuestion2]), selectedOption: $selectedQuestion3)
            AnswerView(answer: $answer3)

            Spacer()
            
          NavigationLink(destination: LoginOnBoarding()){
                Text("Continue")
                    .foregroundColor(.white)
                    .padding()
                    .background( Color.green ) // Set background color to green when enabled, gray when disabled
                    .cornerRadius(8)
                    .frame(maxWidth: .infinity)
            }
            
            
                
            }
        }
    }
    func availableOptions(_ selectedOption: String?, excluding others: [String?]) -> [String] {
          let excluded = Set(others.compactMap { $0 })
          return questions.filter { !excluded.contains($0) }
      }
}

