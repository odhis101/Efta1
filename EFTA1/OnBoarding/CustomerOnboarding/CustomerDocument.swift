//
//  CustomerDocument.swift
//  EFTA1
//
//  Created by Joshua on 4/7/24.
//

import SwiftUI
import UIKit
import FilePicker

struct CustomerDocument: View {
    @State private var progress: CGFloat = 0.9 // Initial progress
    @State private var isModalVisible = false
    @EnvironmentObject var onboardingData: OnboardingData
    @EnvironmentObject var config: AppConfig

    @Environment(\.presentationMode) var presentationMode
 
    var body: some View {

            GeometryReader { geometry in
                VStack(alignment: .center){
                    ProgressBar(geometry: geometry, progress: $progress,presentationMode: presentationMode, title:"\(onboardingData.titleForCustomerOnboarding) document",description: "Kindly upload the customer documentsssss")

                    
                    Spacer()
                    
                    Image("Frame")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 280, height: 280)
                        .padding()
                    
                    Button(action: {
                        isModalVisible.toggle()
                        
                    }){
                        RoundedRectangle(cornerRadius: 10)
                            .foregroundColor(config.primaryColor.opacity(0.3))
                            .frame(width: 200)
                            .frame(height:60)
                            .overlay(
                                HStack{
                                    Text("+")
                                    
                                        .foregroundColor(config.primaryColor)
                                        .padding(.leading)
                                    Text("Upload Document")
                                        .foregroundColor(config.primaryColor)
                                        .padding(.horizontal)

                                        

                                }
                                
                                )
                    
                    }
                    Spacer()
                    CustomNavigationButton(destination: CustomerDocumentList(), label: "Continue", backgroundColor: config.primaryColor)
                    
                }
                DocumentModalView(
                    isVisible: $isModalVisible,
                    destinationView: { CustomerDocumentList()},
                    documentHandler: onboardingData
                )
            }
        }
}

struct DocumentTypesResponse: Codable {
    let status: String
    let message: String
    let data: [DocumentType]
}

struct DocumentType: Codable {
    let id: Int
    let type: String
    let name: String
    let dateCreated: String? // Assuming dateCreated can be null or a string
    let countryId: Int
}


struct DocumentModalView<Destination: View>: View {
    @Binding var isVisible: Bool
    @GestureState private var dragState = DragState()
    @State private var selectedOptions: [String: URL] = [:] // Dictionary to store selected options and their corresponding file URLs
    var destinationView: () -> Destination
    var documentHandler: DocumentHandling
    @State private var isNavigationActive: Bool = false
    @EnvironmentObject var config: AppConfig
    @State private var keyboardHeight: CGFloat = 0
    @EnvironmentObject var onboardingData: OnboardingData
    @State private var DropdownExpand = false
    @State private var documentTypes: [String] = [] // Array to store document names

    @State private var selectedOption: String? = nil // Local state variable for selected option

    var body: some View {
        GeometryReader { geometry in
            VStack {
                Spacer()
                ZStack {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.white)
                        .frame(width: geometry.size.width, height: modalHeight)
                        .cornerRadius(20)
                        .padding(.bottom, keyboardHeight)
                        .shadow(color: Color.black.opacity(0.2), radius: 10, x: 0, y: 5)

                    VStack(spacing: 16) {
                        titleBar
                        QuestionWithDropdownModalDocument(question: "Type Of ID", DropdownExpand: $DropdownExpand, options: documentTypes, selectedOption: $selectedOption)
                        uploadButton
                        continueButton
                    }
                    .padding()
                    
                    NavigationLink(destination: destinationView(), isActive: $isNavigationActive) {
                        EmptyView()  // Invisible view for programmatic navigation
                    }
                }
            }
            .onAppear {
                           fetchDocumentTypes() // Call fetchDocumentTypes when the view appears
                       }
            .offset(y: isVisible ? 0 : geometry.size.height)
            .animation(.easeInOut(duration: isVisible ? 0.3 : 0))
            .gesture(
                DragGesture()
                    .updating($dragState) { value, state, _ in
                        state = DragState()
                    }
                    .onEnded { value in
                        if value.translation.height > geometry.size.height * 0.2 {
                            isVisible = false
                        }
                    }
            )
            .edgesIgnoringSafeArea(.all)
            .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardWillShowNotification)) { notification in
                if let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
                    keyboardHeight = keyboardFrame.height
                }
            }
            .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardWillHideNotification)) { _ in
                keyboardHeight = 0
            }
        }
    }

    private var modalHeight: CGFloat {
        if DropdownExpand {
            return UIScreen.main.bounds.height * 0.5
        } else {
            return UIScreen.main.bounds.height * 0.3
        }
    }

    private struct DragState { }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    private var titleBar: some View {
        Capsule()
            .fill(Color.gray.opacity(0.8))
            .frame(width: 30, height: 6)
    }

    private var uploadButton: some View {
        FilePicker(
            types: [.item],
            allowMultiple: false,
            title: "Upload Document        ",
            onPicked: { urls in
                if let url = urls.first {
                    // File picked successfully, handle the selected URL
                    print("Selected file URL: \(url)")
                    if let selectedOption = selectedOption {
                        documentHandler.addDocument(url, forIDType: selectedOption) // Add the document with the selected ID type
                    }
                    isNavigationActive = true
                } else {
                    // File picking was canceled or failed
                    print("File picking was canceled or failed.")
                }
            }
        )
        .foregroundColor(.black)
        .padding()
        .background(Color.gray.opacity(0.3))
        .cornerRadius(8)
    }

    private var continueButton: some View {
           Button(action: {
               if let selectedOption = selectedOption, let urls = selectedOptions[selectedOption] {
                   documentHandler.addDocument(urls, forIDType: selectedOption)
                   //selectedOptions.removeValue(forKey: selectedOption) // Clear selected options for the ID type
               }
               isVisible = false
               isNavigationActive = true
           }) {
               Text("Continue")
                   .foregroundColor(.white)
                   .frame(maxWidth: .infinity)
                   .frame(height: 50)
                   .background(config.primaryColor) // Gray background when profileImage is nil
                   .cornerRadius(8)
                   .padding(.horizontal)
           }
       }
    class Coordinator: NSObject, UIDocumentPickerDelegate {
        var parent: DocumentModalView

        init(_ parent: DocumentModalView) {
            self.parent = parent
        }

        func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
            print("Document picker selected URLs: \(urls)")
            if let selectedOption = parent.onboardingData.idType {
                parent.selectedOptions[selectedOption] = urls.first // Link selected option with file URL
            }
        }

        func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
            print("Document picker was cancelled.")
        }

        func documentPicker(_ controller: UIDocumentPickerViewController, didFailToPickDocumentAt url: URL, error: Error?) {
            if let error = error {
                print("Document picker failed to pick document at \(url.absoluteString) with error: \(error.localizedDescription)")
            } else {
                print("Document picker failed to pick document at \(url.absoluteString) with an unknown error.")
            }
        }

        func documentPicker(_ controller: UIDocumentPickerViewController, didFailWithError error: Error) {
            print("Document picker failed with error: \(error.localizedDescription)")
        }
    }

    private func availableOptions() -> [String] {
        guard let selectedOption = onboardingData.idType else {
            return ["Driving License", "Passport", "National ID"]
        }
        var options = ["Driving License", "Passport", "National ID"]
        options.removeAll { $0 == selectedOption } // Remove selected option
        return options
    }
    
    private func fetchDocumentTypes() {
        // Dummy data representing the response from the server
        let dummyData = """
        {
          "status": "00",
          "message": "Documents Fetched Successfully.",
          "data": [
            {
              "id": 3,
              "type": "Identification",
              "name": "National ID - TAN",
              "dateCreated": null,
              "countryId": 2
            },
            {
              "id": 4,
              "type": "Identification",
              "name": "Passport - TAN",
              "dateCreated": null,
              "countryId": 2
            },
            {
              "id": 6,
              "type": "Tax Document",
              "name": "TRA",
              "dateCreated": null,
              "countryId": 2
            }
          ]
        }
        """.data(using: .utf8)!
        
        do {
            let decoder = JSONDecoder()
            let response = try decoder.decode(DocumentTypesResponse.self, from: dummyData)
            self.documentTypes = response.data.map { $0.name }
        } catch {
            print("Error decoding JSON: \(error.localizedDescription)")
        }
    }

    // Define DocumentTypesResponse and DocumentType structs here as shown in the previous message

}


struct DocumentModalView2: View {
    @Binding var isVisible: Bool
    @GestureState private var dragState = DragState()
    @State private var selectedOptions: [String: URL] = [:] // Dictionary to store selected options and their corresponding file URLs
    var documentHandler: DocumentHandling
    @State private var isNavigationActive: Bool = false
    @EnvironmentObject var config: AppConfig
    @State private var keyboardHeight: CGFloat = 0
    @EnvironmentObject var onboardingData: OnboardingData
    @State private var DropdownExpand = false
    @State private var documentTypes: [String] = [] // Array to store document names
    @State private var selectedOption: String? = nil // Local state variable for selected option


    var body: some View {
        GeometryReader { geometry in
            VStack {
                Spacer()
                ZStack {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.white)
                        .frame(width: geometry.size.width, height: modalHeight)
                        .cornerRadius(20)
                        .padding(.bottom, keyboardHeight)
                        .shadow(color: Color.black.opacity(0.2), radius: 10, x: 0, y: 5)

                    VStack(spacing: 16) {
                        titleBar
                        QuestionWithDropdownModalDocument(question: "Type Of ID", DropdownExpand: $DropdownExpand, options: documentTypes, selectedOption: $selectedOption)
                        uploadButton
                        continueButton
                    }
                    .padding()
                    
                }
            }
            .onAppear {
                           fetchDocumentTypes() // Call fetchDocumentTypes when the view appears
                       }

            .offset(y: isVisible ? 0 : geometry.size.height)
            .animation(.easeInOut(duration: isVisible ? 0.3 : 0))
            .gesture(
                DragGesture()
                    .updating($dragState) { value, state, _ in
                        state = DragState()
                    }
                    .onEnded { value in
                        if value.translation.height > geometry.size.height * 0.2 {
                            isVisible = false
                        }
                    }
            )
            .edgesIgnoringSafeArea(.all)
            .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardWillShowNotification)) { notification in
                if let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
                    keyboardHeight = keyboardFrame.height
                }
            }
            .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardWillHideNotification)) { _ in
                keyboardHeight = 0
            }
        }
    }

    private var modalHeight: CGFloat {
        if DropdownExpand {
            return UIScreen.main.bounds.height * 0.5
        } else {
            return UIScreen.main.bounds.height * 0.3
        }
    }

    private struct DragState { }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    private var titleBar: some View {
        Capsule()
            .fill(Color.gray.opacity(0.8))
            .frame(width: 30, height: 6)
    }

    private var uploadButton: some View {
           FilePicker(
               types: [.item],
               allowMultiple: false,
               title: "Upload Document        ",
               onPicked: { urls in
                   if let url = urls.first {
                       // File picked successfully, handle the selected URL
                       print("Selected file URL: \(url)")
                       if let selectedOption = selectedOption {
                                              documentHandler.addDocument(url, forIDType: selectedOption) // Add the document with the selected ID type
                                          }
                       isNavigationActive = true
                   } else {
                       // File picking was canceled or failed
                       print("File picking was canceled or failed.")
                   }
               }
           )
           .foregroundColor(.black)
           .padding()
           .background(Color.gray.opacity(0.3))
           .cornerRadius(8)
       }
    private var continueButton: some View {
        Button(action: {
            if let selectedOption = selectedOption, let urls = selectedOptions[selectedOption] {
                          documentHandler.addDocument(urls, forIDType: selectedOption)
                          //selectedOptions.removeValue(forKey: selectedOption) // Clear selected options for the ID type
                      }
            isVisible = false
            isNavigationActive = true
        }) {
            Text("Continue")
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .frame(height:50)
                .background(config.primaryColor) // Gray background when profileImage is nil
                .cornerRadius(8)
                .padding(.horizontal)
        }
    }

    class Coordinator: NSObject, UIDocumentPickerDelegate {
        var parent: DocumentModalView2

        init(_ parent: DocumentModalView2) {
            self.parent = parent
        }

        func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
            print("Document picker selected URLs: \(urls)")
            if let selectedOption = parent.onboardingData.idType {
                parent.selectedOptions[selectedOption] = urls.first // Link selected option with file URL
            }
        }

        func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
            print("Document picker was cancelled.")
        }

        func documentPicker(_ controller: UIDocumentPickerViewController, didFailToPickDocumentAt url: URL, error: Error?) {
            if let error = error {
                print("Document picker failed to pick document at \(url.absoluteString) with error: \(error.localizedDescription)")
            } else {
                print("Document picker failed to pick document at \(url.absoluteString) with an unknown error.")
            }
        }

        func documentPicker(_ controller: UIDocumentPickerViewController, didFailWithError error: Error) {
            print("Document picker failed with error: \(error.localizedDescription)")
        }
    }

    private func availableOptions() -> [String] {
        guard let selectedOption = onboardingData.idType else {
            return ["Driving License", "Passport", "National ID"]
        }
        var options = ["Driving License", "Passport", "National ID"]
        options.removeAll { $0 == selectedOption } // Remove selected option
        return options
    }
    
    private func fetchDocumentTypes() {
        // Dummy data representing the response from the server
        let dummyData = """
        {
          "status": "00",
          "message": "Documents Fetched Successfully.",
          "data": [
            {
              "id": 3,
              "type": "Identification",
              "name": "National ID - TAN",
              "dateCreated": null,
              "countryId": 2
            },
            {
              "id": 4,
              "type": "Identification",
              "name": "Passport - TAN",
              "dateCreated": null,
              "countryId": 2
            },
            {
              "id": 6,
              "type": "Tax Document",
              "name": "TRA",
              "dateCreated": null,
              "countryId": 2
            }
          ]
        }
        """.data(using: .utf8)!
        
        do {
            let decoder = JSONDecoder()
            let response = try decoder.decode(DocumentTypesResponse.self, from: dummyData)
            self.documentTypes = response.data.map { $0.name }
        } catch {
            print("Error decoding JSON: \(error.localizedDescription)")
        }
    }

}
