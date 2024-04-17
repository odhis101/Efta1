//
//  SiteDetails.swift
//  EFTA1
//
//  Created by Joshua on 4/10/24.
//

import SwiftUI

struct SiteDetails: View {
    @State private var progress: CGFloat = 0.2 // Initial progress
    
    @State private var capturedImage: UIImage?

    
    @ObservedObject var siteQuestionData = SiteQuestionDataHandler()

    var body: some View {

        GeometryReader { geometry in
            
            VStack{
                ProgressBar(geometry: geometry, progress: $progress,title:"Individual onboarding",description: "Kindly collect the following information from the customer") // Pass progress as a binding
                    .padding(.trailing,20)

                ScrollView{
                PhotoCaptureButton(capturedImage: $capturedImage,
                                   SiteQuestionData: siteQuestionData,
                                   question: "Has a full description of the site been noted (number of buildings / warehouses / acreage etc)?",
                                   imageStorage: $siteQuestionData.profileImage)
                
                QuestionWithButtons(question: "Do you agree with the terms?")
                
                QuestionWithTextField(question: "If land is rented, did you discuss how long the applicant has rented their site for, any risks of not renewing the rental agreement, how often the applicant has to pay their rent?")
                
                
                PhotoCaptureButton(capturedImage: $capturedImage,
                                   SiteQuestionData: siteQuestionData,
                                   question: "Has a full description of the site been noted (number of buildings / warehouses / acreage etc)?",
                                   imageStorage: $siteQuestionData.profileImage)
                PhotoCaptureButton(capturedImage: $capturedImage,
                                   SiteQuestionData: siteQuestionData,
                                   question: "Has a full description of the site been noted (number of buildings / warehouses / acreage etc)?",
                                   imageStorage: $siteQuestionData.profileImage)
                }
                Spacer ()
                NavigationLink(destination: SiteDetails2()){

                Text("Continue")
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height:40)
                    .background(Color(hex: "#2AA241")) // Gray background when profileImage is nil
                    .cornerRadius(8)
                    .padding(.horizontal)
                }

                }
            }
            
        
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
                        .foregroundColor(isYesSelected ? .green : .clear)
                        .overlay(
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(Color.green, lineWidth: 2)
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
                        .foregroundColor(isNoSelected ? .green : .clear)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.green, lineWidth: 2)
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
