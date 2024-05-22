//
//  SecurityQuestions.swift
//  EFTA1
//
//  Created by Joshua on 3/28/24.
//

import SwiftUI
import AlertToast
struct SecurityQuestions: View {
        @State private var questions: [String] = [] // State variable to hold the fetched questions
        @State private var selectedQuestionIndex = 0
        @State private var isExpanded: Bool = false
        @EnvironmentObject var pinHandler: PinHandler
        @State private var shouldNavigate = false // State variable for navigation
        @State private var showingAlert = false // State for showing the confirmation dialog

        @EnvironmentObject var config: AppConfig
        let goback = true // Make it static

        @Environment(\.presentationMode) var presentationMode




    var body: some View {
        GeometryReader { geometry in
        
        VStack {
            ScrollView{
                LogoAndTitleView(geometry: geometry, title: "Set your security questions", subTitle: "Kindly set security questions to be able to reset your PIN incase you forget", presentationMode: presentationMode, goBack: goback)
                
                    .toast(isPresenting: $showingAlert) {
                                         AlertToast(displayMode: .hud, type: .error(Color.red), title: "Error", subTitle: "Something went wrong. Please try again.")
                                     }

            QuestionWithDropdown(question: "Security Question 1:", options: availableOptions(pinHandler.selectedQuestion1, excluding: [pinHandler.selectedQuestion2, pinHandler.selectedQuestion3]), selectedOption: $pinHandler.selectedQuestion1)
            AnswerView(answer: $pinHandler.answer1)
            QuestionWithDropdown(question: "Security Question 2:", options: availableOptions(pinHandler.selectedQuestion2, excluding: [pinHandler.selectedQuestion1, pinHandler.selectedQuestion3]), selectedOption: $pinHandler.selectedQuestion2)
            AnswerView(answer: $pinHandler.answer2)
            QuestionWithDropdown(question: "Security Question 3:", options: availableOptions(pinHandler.selectedQuestion3, excluding: [pinHandler.selectedQuestion1, pinHandler.selectedQuestion2]), selectedOption: $pinHandler.selectedQuestion3)
            AnswerView(answer: $pinHandler.answer3)
            }

            Spacer()
            NavigationLink(destination: LoginOnBoarding(), isActive: $shouldNavigate) { // NavigationLink to the next page
                                   EmptyView() // Invisible navigation link
                               }
            
  
            
   
            Button("Continue") {
                submitPinData()
            }
            .foregroundColor(.white)
            .cornerRadius(8)
            .frame(width:geometry.size.width * 0.8)
            .frame(height:30)
            .padding()
            .background(config.primaryColor)
            .cornerRadius(10)
            
                
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
        .onAppear {
                // Fetch security questions when the view appears
                fetchSecurityQuestions()
                   }
        .navigationBarHidden(true)


    }
    
    func availableOptions(_ selectedOption: String?, excluding others: [String?]) -> [String] {
          let excluded = Set(others.compactMap { $0 })
          return questions.filter { !excluded.contains($0) }
      }
    private func fetchSecurityQuestions() {
        NetworkManager.shared.getSecurityQuestions { questions, error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                // Handle error
            } else if let questions = questions {
                // Update the state variable with fetched questions
                self.questions = questions
                print("English security questions: \(questions)")
            } else {
                print("Unknown error occurred")
            }
        }
    }
    private func submitPinData() {
        var answers: [(answer: String, question: String)] = []

        if let question1 = pinHandler.selectedQuestion1 {
            answers.append((pinHandler.answer1, question1))
        }

        if let question2 = pinHandler.selectedQuestion2 {
            answers.append((pinHandler.answer2, question2))
        }

        if let question3 = pinHandler.selectedQuestion3 {
            answers.append((pinHandler.answer3, question3))
        }


        NetworkManager.shared.submitSecurityQuestions(answers: answers, phoneNumber: pinHandler.phoneNumber) { success, error in
            if success {
                print("Security questions submitted successfully")
                shouldNavigate = true
                
            } else {
                print("Failed to submit security questions: \(error?.localizedDescription ?? "Unknown error")")
                shouldNavigate = true
                //showingAlert = true

            }
        }

    }


}
struct SecurityQuestions_Previews: PreviewProvider {
    static var previews: some View {
        SecurityQuestions()
            .environmentObject(AppConfig(region: .efken))
            .environmentObject(PinHandler())
    }
}
