//
//  FormTypes.swift
//  EFTA1
//
//  Created by Joshua on 4/15/24.
//

import Foundation
import SwiftUI

struct DropdownQuestionView: View {
    let questions: [String]
    @Binding var selectedQuestionIndex: Int
    
    var body: some View {
        VStack {
            HStack {
                Text("Selected Question: \(questions[selectedQuestionIndex])")
                    .padding(.horizontal)
                Spacer()
                Image(systemName: "chevron.down")
                    .padding(.horizontal)
            }
            .frame(height: 50)
            .background(Color.gray.opacity(0.2))
            .cornerRadius(8)
            .onTapGesture {
                // Toggle the picker visibility
                isPickerVisible.toggle()
            }
            
            if isPickerVisible {
                Picker(selection: $selectedQuestionIndex, label: Text("")) {
                    ForEach(0..<questions.count, id: \.self) { index in
                        Text(self.questions[index])
                    }
                }
                .pickerStyle(MenuPickerStyle())
            }
        }
        .padding()
    }
    
    // Add a state variable to control the picker visibility
    @State private var isPickerVisible = false
}
struct AnswerView: View {
    @Binding var answer: String

    var body: some View {
        TextField("Your Answer", text: $answer)
            .padding()
            .frame(height: 50)
            .background(Color.gray.opacity(0.2))
            .cornerRadius(8)
            .padding(.horizontal)
    }
}

struct QuestionWithOptionView: View {
    var question: String
    var options: [String]

    // Tracks selected options
    @State private var selectedOptions: Set<String> = []

    // Define layout for the options
    private var rows: [[String]] {
        options.chunked(into: 2)
    }

    var body: some View {
        HStack{
        VStack(alignment: .leading, spacing: 10) {
            Text(question)
                .font(.headline)
            
            ForEach(rows, id: \.self) { row in
                HStack {
                    ForEach(row, id: \.self) { option in
                        OptionCheckBox(option: option, isSelected: selectedOptions.contains(option)) {
                            if selectedOptions.contains(option) {
                                selectedOptions.remove(option)
                            } else {
                                selectedOptions.insert(option)
                            }
                        }
                    }
                }
            }
        }
            Spacer()
    }
        .padding()

    }
}

struct OptionCheckBox: View {
    var option: String
    var isSelected: Bool
    var action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 5) {
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.black, lineWidth: 2)
                    .frame(width: 24, height: 24)
                    .overlay(
                        isSelected ? Image(systemName: "checkmark").foregroundColor(.green) : nil
                    )
                Text(option)
            }
            .padding(.vertical, 8)
            .foregroundColor(.black)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct QuestionWithDropdown: View {
    var question: String
    let options: [String]
    @State private var isExpanded = false
    @Binding public var selectedOption: String?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(question)
                .font(.headline)
                .padding(.horizontal)

            Button(action: {
                withAnimation(.spring()) {
                    isExpanded.toggle()
                }
            }) {
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.gray.opacity(0.2))
                    .frame(height: 50)
                    .overlay(
                        HStack {
                            Text(selectedOption ?? "Select an option")
                                .foregroundColor(.black)
                                .padding(.leading)
                            Spacer()
                            Image(systemName: "chevron.down")
                                .foregroundColor(.gray)
                                .rotationEffect(Angle(degrees: isExpanded ? 180 : 0))
                                .padding(.trailing)
                        }
                    )
                    .padding(.horizontal)
            }
            
            if isExpanded {
                ForEach(options, id: \.self) { option in
                    Button(action: {
                        withAnimation(.spring()) {
                            selectedOption = option
                            isExpanded = false
                        }
                    }) {
                        Text(option)
                            .padding()
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    .foregroundColor(.black)
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(5)
                    .padding(.horizontal)
                }
            }
        }
        .animation(.spring(), value: isExpanded)
    }
}

struct QuestionWithSmallTextField: View {
    var question: String
    var placeholder:String
    @Binding public var selectedOption: String

    var body: some View {
        VStack(spacing: 10) {
            HStack{
                Text(question)
                    .font(.headline)
            Spacer()
            }
            .padding(.horizontal)

            

            RoundedRectangle(cornerRadius: 10)
                .fill(Color(hex: "#F2F2F7"))
                .frame(height: 40) // Adjust height as needed
                .frame(maxWidth:.infinity)
                .overlay(
                    TextField(placeholder, text: $selectedOption ?? .constant(""))
                        .padding()
                )
                .padding(.horizontal)
        }
   
    }
}
