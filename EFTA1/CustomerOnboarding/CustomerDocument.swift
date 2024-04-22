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


    var body: some View {

            GeometryReader { geometry in
                VStack{
                    ProgressBar(geometry: geometry, progress: $progress,title:"\(onboardingData.titleForCustomerOnboarding) document",description: "Kindly upload the customer documentsssss")
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
                        .background(config.primaryColor) // Gray background when profileImage is nil
                        .opacity(0.5)
                        .cornerRadius(8)
                        .padding(.horizontal)
                    }
                    Spacer()
                    NavigationLink( destination: CustomerDocumentList()){
                    Text("Continue")
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height:40)
                        .background(config.primaryColor) // Gray background when profileImage is nil
                        .cornerRadius(8)
                        .padding(.horizontal)
                    }
                    
                }
                DocumentModalView(
                    isVisible: $isModalVisible,
                    destinationView: { CustomerDocumentList()},
                    documentHandler: onboardingData
                )
            }
        }
}
    




struct DocumentModalView<Destination: View>: View {
    @Binding var isVisible: Bool
    @GestureState private var dragState = DragState()
    @State private var selectedFileURLs: [URL] = []
    var destinationView: () -> Destination
    var documentHandler: DocumentHandling
    @State private var isNavigationActive: Bool = false
    @EnvironmentObject var config: AppConfig
    @State private var keyboardHeight: CGFloat = 0

    var body: some View {
        GeometryReader { geometry in
            VStack {
                Spacer()
                ZStack {
                    Rectangle()
                        .fill(Color.white)
                        .frame(width: geometry.size.width, height: modalHeight)
                        .cornerRadius(20)
                        .padding(.bottom, keyboardHeight)

                    VStack(spacing: 16) {
                        titleBar
                        uploadButton
                        fileList
                        continueButton
                    }
                    .padding()
                    
                    NavigationLink(destination: destinationView(), isActive: $isNavigationActive) {
                        EmptyView()  // Invisible view for programmatic navigation
                    }
                }
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
        UIScreen.main.bounds.height * 0.3
    }

    private struct DragState { }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    private var titleBar: some View {
        HStack {
            RoundedRectangle(cornerRadius: 10)
                .fill(LinearGradient(gradient: Gradient(colors: [Color.gray.opacity(0.5), Color.gray.opacity(0.1)]), startPoint: .leading, endPoint: .trailing))
                .frame(width: 80, height: 20)
                .padding(.vertical, 8)
                .overlay(
                    Capsule()
                        .fill(Color.gray.opacity(0.8))
                        .frame(width: 30, height: 6)
                )
        }
    }

    public var uploadButton: some View {
        FilePicker(
            types: [.item],
            allowMultiple: false,
            title: "Upload Files",
            onPicked: { urls in
                if let url = urls.first {
                    // File picked successfully, handle the selected URL
                    print("Selected file URL: \(url)")
                    selectedFileURLs = [url]
                } else {
                    // File picking was canceled or failed
                    print("File picking was canceled or failed.")
                }
            }
        )
        .foregroundColor(.white)
        .padding()
        .background(Color.blue)
        .cornerRadius(8)
    }


    // Define a custom button style for the FilePicker

    private var fileList: some View {
        VStack(alignment: .leading) {
            if !selectedFileURLs.isEmpty {
                Text("Selected Files:")
                    .font(.headline)
                    .padding(.bottom, 4)
                ForEach(selectedFileURLs, id: \.self) { fileURL in
                    Text(fileURL.lastPathComponent)
                        .foregroundColor(.secondary)
                }
            }
        }
    }

    private var continueButton: some View {
        Button(action: {
            isVisible = false
            documentHandler.addDocuments(selectedFileURLs)
            isNavigationActive = true
        }) {
            Text("Continue")
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .frame(height:40)
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
            parent.selectedFileURLs = urls
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
}
