//
//  SecurityQuestions.swift
//  EFTA1
//
//  Created by Joshua on 3/28/24.
//

import SwiftUI

struct SecurityQuestions: View {
    let questions = ["What is your favorite color?", "What is your pet's name?", "Where were you born?", "Where were you bornkenya?", "Where were you born rural?"]
        @State private var selectedQuestionIndex = 0
        @State private var isExpanded: Bool = false
        @EnvironmentObject var pinHandler: PinHandler
        @State private var shouldNavigate = false // State variable for navigation
        @State private var showingAlert = false // State for showing the confirmation dialog

        @EnvironmentObject var config: AppConfig


    var body: some View {
        GeometryReader { geometry in
        
        VStack {
            LogoAndTitleView(geometry: geometry, title: "Set your security questions", subTitle: "Kindly set security questions to be able to reset your PIN incase you forget")
                .padding(.bottom,10)
                        
            QuestionWithDropdown(question: "Security Question #1:", options: availableOptions(pinHandler.selectedQuestion1, excluding: [pinHandler.selectedQuestion2, pinHandler.selectedQuestion3]), selectedOption: $pinHandler.selectedQuestion1)
            AnswerView(answer: $pinHandler.answer1)
            QuestionWithDropdown(question: "Security Question #2:", options: availableOptions(pinHandler.selectedQuestion2, excluding: [pinHandler.selectedQuestion1, pinHandler.selectedQuestion3]), selectedOption: $pinHandler.selectedQuestion2)
            AnswerView(answer: $pinHandler.answer2)
            QuestionWithDropdown(question: "Security Question #3:", options: availableOptions(pinHandler.selectedQuestion3, excluding: [pinHandler.selectedQuestion1, pinHandler.selectedQuestion2]), selectedOption: $pinHandler.selectedQuestion3)
            AnswerView(answer: $pinHandler.answer3)

            Spacer()
            NavigationLink(destination: LoginOnBoarding(), isActive: $shouldNavigate) { // NavigationLink to the next page
                                   EmptyView() // Invisible navigation link
                               }
            
            Button(action: {
                submitPinData()
                         }) {
              
                Text("Continue")
                    .foregroundColor(.white)
                    .padding()
                    .background( config.primaryColor)
                    .cornerRadius(8)
                    .frame(maxWidth: .infinity)
            }
            
            
                
            }
        }
        .alert(isPresented: $showingAlert) {
            Alert(
                title: Text("Confirm Submission"),
                message: Text("You are about to submit customer details. Are you sure you want to proceed?"),
                primaryButton: .destructive(Text("Submit"), action: {
                    shouldNavigate = true
                }),
                secondaryButton: .cancel({
                    // Optional: Handle cancellation
                })
            )
        }

    }
    func availableOptions(_ selectedOption: String?, excluding others: [String?]) -> [String] {
          let excluded = Set(others.compactMap { $0 })
          return questions.filter { !excluded.contains($0) }
      }
    
    private func submitPinData() {
        NetworkManager.shared.sendPinData(pinData: pinHandler) { success, token in
            DispatchQueue.main.async {
                if success, let token = token {
                    // Save the token using AuthManager
                    AuthManager.shared.saveToken(token)
                    shouldNavigate = true
                } else {
                    // Handle error case, perhaps update UI to show an error message
                    self.showingAlert = true
                }
            }
        }
    }


}
