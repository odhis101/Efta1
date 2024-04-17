//
//  CustomerDocument.swift
//  EFTA1
//
//  Created by Joshua on 4/7/24.
//

import SwiftUI
import UIKit

struct CustomerDocument: View {
    @State private var progress: CGFloat = 0.9 // Initial progress
    @State private var isModalVisible = false
    @State private var selectedFiles: [URL] = []
    @StateObject var documentHandler = DocumentHandler() // Use @ObservedObject if passed from parent view
    @EnvironmentObject var onboardingData: OnboardingData



    var body: some View {

            GeometryReader { geometry in
                VStack{
                    ProgressBar(geometry: geometry, progress: $progress,title:"\(onboardingData.titleForCustomerOnboarding) document",description: "Kindly upload the customer documents ")
                        .padding(.trailing,20)
                    
                    Spacer()
                    
                    Image("Frame")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 280, height: 280)
                        .padding()
                    
                    Button(action: {
                        isModalVisible.toggle()
                        
                    }){
                    Text("Upload Document")
                        .foregroundColor(.white)
                        .frame(width: 280)
                        .frame(height:60)
                        .background(Color(hex: "#2AA241")) // Gray background when profileImage is nil
                        .opacity(0.5)
                        .cornerRadius(8)
                        .padding(.horizontal)
                    }
                    Spacer()
                    NavigationLink( destination: CustomerSummary()){
                    Text("Continue")
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height:40)
                        .background(Color(hex: "#2AA241")) // Gray background when profileImage is nil
                        .cornerRadius(8)
                        .padding(.horizontal)
                    }
                    
                }
                DocumentModalView(isVisible: $isModalVisible, destinationTitle: "Customer Onboarding", documentHandler: CustomerMonitoringDocumentHandler())
            }
        }
}
    




struct DocumentModalView: View {
    @Binding var isVisible: Bool
    @GestureState private var dragState = DragState()
    @State private var selectedFileURLs: [URL] = []
    let destinationTitle: String

    @State private var isNavigationActive: Bool = false  // State to control navigation


    var documentHandler: DocumentHandling // Use the protocol type here

    // State variable to track keyboard height
    @State private var keyboardHeight: CGFloat = 0

    var onSelectFiles: (([URL]) -> Void)? // Closure to pass selected files

    var body: some View {
        GeometryReader { geometry in
            VStack {
                Spacer()
                ZStack {
                    Rectangle()
                        .fill(Color.white)
                        .frame(width: geometry.size.width, height: modalHeight)
                        .cornerRadius(20)
                        .padding(.bottom, keyboardHeight) // Move below keyboard

                    VStack(spacing: 16) {
                        // Title
                        HStack {
                            RoundedRectangle(cornerRadius: 10)
                                .fill(LinearGradient(gradient: Gradient(colors: [Color.gray.opacity(0.5), Color.gray.opacity(0.1)]), startPoint: .leading, endPoint: .trailing))
                                .frame(width: 80, height: 20) // Adjust size as needed
                                .padding(.vertical, 8)
                                .overlay(
                                    Capsule()
                                        .fill(Color.gray.opacity(0.8))
                                        .frame(width: 30, height: 6)
                                )
                        }

                        // Upload Button
                        Button(action: {
                            // Present file picker
                            let documentPicker = UIDocumentPickerViewController(documentTypes: ["public.content"], in: .import)
                            documentPicker.delegate = makeCoordinator() // Use the coordinator here
                            UIApplication.shared.windows.first?.rootViewController?.present(documentPicker, animated: true, completion: nil)
                        }) {
                            HStack {
                                Image(systemName: "square.and.arrow.up")
                                Text("Upload Files")
                            }
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.blue)
                            .cornerRadius(8)
                        }

                        // List of selected files
                        if !selectedFileURLs.isEmpty {
                            VStack(alignment: .leading) {
                                Text("Selected Files:")
                                    .font(.headline)
                                    .padding(.bottom, 4)
                                ForEach(selectedFileURLs, id: \.self) { fileURL in
                                    Text(fileURL.lastPathComponent)
                                        .foregroundColor(.secondary)
                                }
                            }
                        }

                        // Continue Button
                        Button(action: {
                            // Handle continue button action here
                            isVisible.toggle()
                            documentHandler.addDocuments(selectedFileURLs) // Use DocumentHandler to manage documents
                            isNavigationActive = true  // Set the navigation flag to true to trigger navigation

                        }) {
                            Text("Continue")
                                .foregroundColor(.white)
                                .cornerRadius(8)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.green)
                        }
                    
                        

                    }
                    .padding()
                    NavigationLink(destination: CustomerMonitoringDocumentList(title: destinationTitle), isActive: $isNavigationActive) {
                        EmptyView()  // Invisible view for programmatic navigation
                    }
                }
            }
            .offset(y: isVisible ? 0 : geometry.size.height) // Adjust offset
            .animation(.easeInOut(duration: isVisible ? 0.3 : 0)) // Apply animation duration conditionally
            .gesture(
                DragGesture()
                    .updating($dragState) { value, state, _ in
                        state = DragState()
                    }
                    .onEnded { value in
                        let screenHeight = geometry.size.height
                        let threshold = screenHeight * 0.2 // Adjust threshold as needed
                        if value.translation.height > threshold {
                            isVisible = false
                        }
                    }
            )
            .edgesIgnoringSafeArea(.all)
        }
        .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardWillShowNotification)) { notification in
            guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
            self.keyboardHeight = keyboardFrame.height
        }
        .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardWillHideNotification)) { _ in
            self.keyboardHeight = 0
        }
    }

    private var modalHeight: CGFloat {
        UIScreen.main.bounds.height * 0.3
    }

    private struct DragState {
        // No need for any member here
    }

    // Coordinator for UIDocumentPickerViewController
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, UIDocumentPickerDelegate {
        var parent: DocumentModalView

        init(_ parent: DocumentModalView) {
            self.parent = parent
        }

        func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
            parent.selectedFileURLs = urls
        }

        func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
            // Handle document picker cancellation
        }
    }
}
