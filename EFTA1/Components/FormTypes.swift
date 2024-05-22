//
//  FormTypes.swift
//  EFTA1
//
//  Created by Joshua on 4/15/24.


// joshua is the greatest alivessss
//

import Foundation
import SwiftUI
import UIKit
import SwiftUIDigitalSignature

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
            .background(Color(hex: "#F2F2F7"))
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
    @EnvironmentObject var config: AppConfig

    var body: some View {
        Button(action: action) {
            HStack(spacing: 5) {
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.black, lineWidth: 2)
                    .frame(width: 24, height: 24)
                    .overlay(
                        isSelected ? Image(systemName: "checkmark").foregroundColor(config.primaryColor) : nil
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
                //.font(.headline)
                .padding(.horizontal)


            Button(action: {
                withAnimation(.spring()) {
                    isExpanded.toggle()
                }
            }) {
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color(hex: "#F2F2F7"))
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

struct QuestionWithDropdownStatement: View {
    var question: String
    let options: [String]
    @State private var isExpanded = false
    @Binding public var selectedOption: String?
    @EnvironmentObject var config: AppConfig

    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(question)
                .font(.caption)
                .foregroundColor(Color.gray)
                .multilineTextAlignment(.leading)
            Button(action: {
                withAnimation(.spring()) {
                    isExpanded.toggle()
                }
            }) {
                RoundedRectangle(cornerRadius: 10)
                    .fill(.white)
                    .frame(height: 50)
                    .overlay(
                        VStack{
                        HStack {
                            Text(selectedOption ?? "Select an option")
                                .foregroundColor(Color.gray)
                                .multilineTextAlignment(.leading)
                                .padding(.bottom)

                            Spacer()
                            Image(systemName: "chevron.down")
                                .foregroundColor(.gray)
                                .rotationEffect(Angle(degrees: isExpanded ? 180 : 0))
                                .padding(.trailing)
                        }
                            Rectangle()
                                .frame(height: 3)
                                .foregroundColor(config.primaryColor) // Adjust color as needed
                               
                            
                        }
                    )
                
                
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
        .padding(.horizontal)
        .animation(.spring(), value: isExpanded)
    }
}


struct QuestionWithDropdownModal: View {
    var question: String
    @Binding public var DropdownExpand: Bool
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
                    DropdownExpand.toggle()
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
                            DropdownExpand = false

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

struct QuestionWithDropdownModalDocument: View {
    var question: String
    @Binding public var DropdownExpand: Bool
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
                    DropdownExpand.toggle()
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
                            DropdownExpand = false
                        }
                    }) {
                        Text(option)
                            .padding()
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .opacity(selectedOption == option ? 0.5 : 1.0) // Apply reduced opacity to the selected option
                            .disabled(selectedOption == option) // Disable the button if it's the selected option
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
            Spacer()
            }
            .padding(.horizontal)
             

            

            RoundedRectangle(cornerRadius: 10)
                .fill(Color(hex: "#F2F2F7"))
                .frame(height: 50) // Adjust height as needed
                .frame(maxWidth:.infinity)
                .overlay(
                    TextField(placeholder, text: $selectedOption ?? .constant(""))
                        .padding()
                )
                .padding(.horizontal)
        }
   
    }
}

struct QuestionWithSmallField: View {
    var question: String
    var placeholder:String
    @Binding public var selectedOption: String
    @EnvironmentObject var config: AppConfig

    var body: some View {
        VStack(spacing: 10) {
            HStack{
                Text(question)
                    .foregroundColor(.gray)
                    .font(.caption)
            Spacer()
            }
            .padding(.horizontal)
                    TextField(placeholder, text: $selectedOption ?? .constant(""))
                        .padding()
                Rectangle ()
                    .frame(height: 2)
                    .foregroundColor(config.primaryColor)


                        
                    
                
                .padding(.horizontal)
        }
        .padding(.top,5)
   
    }}

struct QuestionWithSearchFeild: View {
    var question: String
    var placeholder:String
    @Binding public var selectedOption: String

    var body: some View {
        VStack(spacing: 10) {
            HStack{
                Text(question)
            Spacer()
            }
            .padding(.horizontal)

            

            RoundedRectangle(cornerRadius: 10)
                .fill(Color(hex: "#F2F2F7"))
                .frame(height: 40) // Adjust height as needed
                .frame(maxWidth:.infinity)
                .overlay(
                    HStack{
                        Image("magnifyingglass")
                        TextField(placeholder, text: $selectedOption ?? .constant(""))
                        .padding()
                    }
                )
                .padding(.horizontal)
        }
   
    }
}

struct ToggleableTextComponent: View {
    var text1: String
    var text2: String
    var isActiveFirstText: Bool
    var onToggle: () -> Void // Closure to handle toggle action
    @EnvironmentObject var config: AppConfig

    var body: some View {
        RoundedRectangle(cornerRadius: 20)
            .fill(Color.white)
            .frame(height: 40)
            .frame(maxWidth: .infinity)
            .padding()
            .overlay(
                HStack {
                    Button(action: {
                        // toggle active state
                        onToggle()
                    }) {
                        RoundedRectangle(cornerRadius: 20)
                            .fill(isActiveFirstText ? config.primaryColor : Color.clear) // Use green color if active
                            .frame(height: 40)
                            .frame(maxWidth: .infinity)

                            .padding()



                            .overlay(
                                Text(text1)
                                    .foregroundColor(isActiveFirstText ? .white : .black) // Text color changes based on active state
                                    .padding()
                            )
                    }
                    Spacer()
                    Button(action: {
                        // toggle active state
                        onToggle()
                    }) {
                        RoundedRectangle(cornerRadius: 20)
                            .fill(!isActiveFirstText ? config.primaryColor: Color.clear) // Use green color if active
                            .frame(height: 40)
                        
                            .padding()

                            .overlay(
                                Text(text2)
                                    .foregroundColor(!isActiveFirstText ? .white : .black) // Text color changes based on active state
                                    .padding()
                            )
                    }
                }
            )
    }
}

struct QuestionWithDate: View {
    @State private var showDatePicker = false
    @State private var selectedDate = Date()
    var question: String

    var body: some View {
        VStack(spacing:10)  {
            HStack{
            Text(question)
                .font(.caption)
                .multilineTextAlignment(.leading)
            Spacer ()
            }
            Button(action: {
                // Action to show date picker
                showDatePicker.toggle()
            }) {
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.gray.opacity(0.2))
                    .frame(height: 60) // Adjust height as needed
                    .overlay(
                        HStack {
                            Text(verbatim: selectedDate.formatted(date: .numeric, time: .omitted))
                                .foregroundColor(.black)
                                .padding(.leading)
                            
                            Spacer()
                            
                            Image(systemName: "calendar")
                                .foregroundColor(.gray)
                                .padding(.trailing)
                        }
                    )
            }
            .sheet(isPresented: $showDatePicker) {
                // Date picker modal
                DatePicker("Select a date", selection: $selectedDate, displayedComponents: .date)
                    .datePickerStyle(GraphicalDatePickerStyle())
                    .padding()
            }
        }
        .padding(.horizontal)

    }
}

struct QuestionWithDateStatement: View {
    @State private var showDatePicker = false
    @State private var selectedDate = Date()
    @EnvironmentObject var config: AppConfig

    var question: String

    var body: some View {
        VStack(spacing:10)  {
            HStack{
            Text(question)
                    .font(.caption)
                    .foregroundColor(Color.gray)
                    .multilineTextAlignment(.leading)
                Spacer()
            }
            Button(action: {
                // Action to show date picker
                showDatePicker.toggle()
            }) {
                RoundedRectangle(cornerRadius: 10)
                    .fill(.white)
                    .frame(height: 60) // Adjust height as needed
                    .overlay(
                        VStack{
                        HStack {
                            Text(verbatim: selectedDate.formatted(date: .numeric, time: .omitted))
                                .foregroundColor(.black)
                                .padding(.leading)
                            
                            Spacer()
                            
                            Image(systemName: "calendar")
                                .foregroundColor(.gray)
                                .padding(.trailing)
                        }
                            Rectangle()
                                .frame(height: 3)
                                .foregroundColor(config.primaryColor) // Adjust color as needed
                            
                        }
                        
                    )
            }
            .sheet(isPresented: $showDatePicker) {
                // Date picker modal
                DatePicker("Select a date", selection: $selectedDate, displayedComponents: .date)
                    .datePickerStyle(GraphicalDatePickerStyle())
                    .padding()
            }
        }
        .padding(.horizontal)

    }
}


struct QuestionWithTime: View {
    @State private var showTimePicker = false
    @State private var selectedTime = Date()
    var question: String

    var body: some View {
        VStack(spacing: 10) {
            HStack {
                Text(question)
                    .font(.headline)
                    .multilineTextAlignment(.leading)
                Spacer()
            }
            Button(action: {
                // Toggle visibility of the time picker
                showTimePicker.toggle()
            }) {
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.gray.opacity(0.2))
                    .frame(height: 50) // Standard form field height
                    .overlay(
                        HStack {
                            Text(selectedTime, format: .dateTime.hour().minute())
                                .foregroundColor(.black)
                                .padding(.leading)
                            
                            Spacer()
                            
                            Image(systemName: "clock")
                                .foregroundColor(.gray)
                                .padding(.trailing)
                        }
                    )
            }
            .sheet(isPresented: $showTimePicker) {
                // Use a date picker within a modal sheet
                DatePicker("Select Time", selection: $selectedTime, displayedComponents: .hourAndMinute)
                    .datePickerStyle(WheelDatePickerStyle())
                    .padding()
                    .toolbar {
                        // Adding a Done button to toolbar for better UX
                        ToolbarItem(placement: .confirmationAction) {
                            Button("Done") {
                                showTimePicker = false
                            }
                        }
                    }
            }
        }
        .padding(.horizontal)
    }
}

struct QuestionWithTextField: View {
    var question: String
    @State private var answer = ""

    var body: some View {
        VStack(spacing: 10) {
            HStack{
            Text(question)
                .font(.caption)
            Spacer()
            }

            RoundedRectangle(cornerRadius: 10)
                .fill(Color(hex: "#F2F2F7"))
                .frame(height: 80) // Adjust height as needed
                .frame(maxWidth:.infinity)
                .overlay(
                    TextField("Enter your answer", text: $answer)
                        .padding()
                )
        }
        .padding(.horizontal)

   
    }
}


struct QuestionWithBulletpoints: View {
    var question: String
    var bulletPoints: [String]

    @State private var answer = ""

    var body: some View {
        VStack(spacing: 10) {
            HStack{
            Text(question)
                .font(.caption)
            Spacer()
            }
            ForEach(bulletPoints, id: \.self) { bulletPoint in
                          HStack {
                              Text("•")
                                  .font(.system(size: 12))
                                  .foregroundColor(Color.black) // Bullet point color
                              Text(bulletPoint)
                                  .font(.system(size: 12))
                                  .foregroundColor(Color.black)
                                  .italic()
                              Spacer()
                          }
            }

            RoundedRectangle(cornerRadius: 10)
                .fill(Color(hex: "#F2F2F7"))
                .frame(height: 80) // Adjust height as needed
                .frame(maxWidth:.infinity)
                .overlay(
                    TextField("Enter your answer", text: $answer)
                        .padding()
                )
        }
        .padding(.horizontal)

   
    }
}

struct PhotoCaptureButton: View {
    @Binding var capturedImage: UIImage?
    @ObservedObject var SiteQuestionData: SiteQuestionDataHandler
    var question: String
    
    var imagePickerTitle: String = "Select Photo"
    @State private var isPickerPresented = false
    var imageStorage: Binding<UIImage?> // Binding to a dynamic image storage property

    var body: some View {
        VStack{
            Text(question)
                .font(.caption) // Adjust font size as needed
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.gray.opacity(0.2))
                .frame(maxWidth: .infinity)
                .frame(height:60)
                .overlay(
                    HStack {
                        Text("Capture a Photo ")
                            .padding(.leading, 20)
                        Spacer()
                        Button(action: {
                            // Toggle image picker presentation
                            isPickerPresented.toggle()
                        }) {
                            Image(systemName: "photo")
                                .padding(.trailing,30)

                        }
                        if SiteQuestionData.profileImage != nil {
                            Button(action: {
                                // Clear the captured image
                                imageStorage.wrappedValue = nil
                            }) {
                                Image(systemName: "xmark.circle.fill")
                                    .foregroundColor(.red)
                            }
                        }
                    }
                )
            if let storedImage = imageStorage.wrappedValue {
                Image(uiImage: storedImage)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 60, height: 60)
                    .clipShape(Circle())
                    .overlay(Circle().stroke(Color.gray, lineWidth: 3))
                    .padding()
                    .offset(x: 150, y: -20) // Adjust position as needed
            }
        }
    }
        .padding()

        .sheet(isPresented: $isPickerPresented) {
            ImagePicker(image: $capturedImage, isPickerPresented: $isPickerPresented, sourceType: .photoLibrary)
        }
        .onChange(of: capturedImage) { newValue in
            // Update the profile image in the imageStorage when capturedImage changes
            imageStorage.wrappedValue = newValue
        }
    }
}

struct QuestionWithButtons: View {
    var question: String
    @State private var isYesSelected = false
    @State private var isNoSelected = false
    @EnvironmentObject var config: AppConfig


    var body: some View {
        VStack(spacing: 10) {
            HStack{
            Text(question)
                .font(.caption)
            Spacer ()
            }

            HStack {
                Button(action: {
                    isYesSelected.toggle()
                    isNoSelected = false
                }) {
                    RoundedRectangle(cornerRadius: 20)
                        .frame(width: 30, height: 30)
                        .foregroundColor(isYesSelected ? config.primaryColor : .clear)
                        .overlay(
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(config.primaryColor, lineWidth: 2)
                                .padding(2)
                        )
                }
                Text("Yes")
                    .padding(.leading, 5)


                Button(action: {
                    isNoSelected.toggle()
                    isYesSelected = false
                }) {
                    RoundedRectangle(cornerRadius: 8)
                        .frame(width: 30, height: 30)
                        .foregroundColor(isNoSelected ? config.primaryColor : .clear)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(config.primaryColor, lineWidth: 2)
                                .padding(2)
                        )
                }
                Text("No")
                    .padding(.trailing, 5)
                
                Spacer()

            }

        }
        .padding()
    }
}



struct SignatureCaptureView: UIViewRepresentable {
    @Binding var signatureImage: UIImage?
    
    class Coordinator: NSObject {
        var path = UIBezierPath()
        var currentPoint: CGPoint = .zero
        
        func touchMoved(to point: CGPoint) {
            path.move(to: currentPoint)
            path.addLine(to: point)
            currentPoint = point
        }
        
        func getImage(from view: UIView) -> UIImage {
            UIGraphicsBeginImageContextWithOptions(view.bounds.size, false, UIScreen.main.scale)
            view.layer.render(in: UIGraphicsGetCurrentContext()!)
            let image = UIGraphicsGetImageFromCurrentImageContext()!
            UIGraphicsEndImageContext()
            return image
        }
    }
    
    func makeUIView(context: Context) -> UIView {
        let view = UIView()
        view.backgroundColor = .white
        view.isUserInteractionEnabled = true
        let panRecognizer = UIPanGestureRecognizer(target: context.coordinator, action: #selector(Coordinator.panGesture(_:)))
        view.addGestureRecognizer(panRecognizer)
        return view
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator()
    }
}


extension SignatureCaptureView.Coordinator {
    @objc func panGesture(_ sender: UIPanGestureRecognizer) {
        let location = sender.location(in: sender.view)
        
        switch sender.state {
        case .began:
            currentPoint = location
        case .changed:
            touchMoved(to: location)
            sender.view?.setNeedsDisplay()
        case .ended:
            if let view = sender.view {
                let image = getImage(from: view)
                DispatchQueue.main.async {
                    //self.signatureImage = image
                }
            }
        default:
            break
        }
    }
}

struct SignatureCaptureField: View {
    @Binding var signatureImage: UIImage?
    @State private var isPresentingSignatureView = false

    var body: some View {
        Button(action: {
            isPresentingSignatureView = true
        }) {
            HStack {
                if signatureImage != nil {
                    Image(uiImage: signatureImage!)
                        .resizable()
                        .scaledToFit()
                        .frame(height: 30)
                    Text("Tap to change signature")
                        .foregroundColor(.gray)
                        .font(.caption)
                } else {
                    Text("Tap to add signature")
                        .foregroundColor(.gray)
                }
                Spacer()
                Image(systemName: "pencil")
            }
            .padding()
            .background(Color.white)
            .overlay(
                RoundedRectangle(cornerRadius: 5)
                    .stroke(Color.gray, lineWidth: 1)
            )
        }
        .sheet(isPresented: $isPresentingSignatureView) {
            SignatureView(availableTabs: [.draw], onSave: { image in
                self.signatureImage = image
                isPresentingSignatureView = false
            }, onCancel: {
                isPresentingSignatureView = false
            })
        }
    }
}


struct PhotoCaptureField: View {
    @Binding var image: UIImage?
    @State private var isPresentingCamera = false
    @State private var isPickerPresented = false

    var body: some View {
        Button(action: {
            isPresentingCamera = true
        }) {
            HStack {
                if image != nil {
                    Image(uiImage: image!)
                        .resizable()
                        .scaledToFit()
                        .frame(height: 30)
                    Text("Tap to retake photo")
                        .foregroundColor(.gray)
                        .font(.caption)
                } else {
                    Text("Tap to take photo Of Signature ")
                        .foregroundColor(.gray)
                }
                Spacer()
                Image(systemName: "camera")
            }
            .padding()
            .background(Color.white)
            .overlay(
                RoundedRectangle(cornerRadius: 5)
                    .stroke(Color.gray, lineWidth: 1)
            )
        }
        .sheet(isPresented: $isPresentingCamera) {
            ImagePicker(image: $image, isPickerPresented: $isPickerPresented, sourceType: .camera)
        }
    }
}

struct QuestionWithDropdownStatement_Previews: PreviewProvider {
    @State static var selectedOption: String = ""
    @StateObject var config = AppConfig(region: .efken)

    static var previews: some View {
        
            QuestionWithSmallTextField(question: "Select your option",placeholder: "Enter Name" , selectedOption: $selectedOption)
                .environmentObject(AppConfig(region: .efken))

            
           
        
    }
}
