//
//  EquipmentDelivery1.swift
//  EFTA1
//
//  Created by Joshua on 4/15/24.
//

import SwiftUI

struct EquipmentDeliveryForm1: View {
    @State private var progress: CGFloat = 0.2 // Initial progress
    @EnvironmentObject var config: AppConfig

    let receiptItems: [(String, String)] = [
            ("Equipment name & model:", "Trailer"),
            ("Model:", "CIMC 53 Foot Truck"),
            ("Equipment Serial number:", "1234567"),
            ("6975766100292", "6975766100292"),
        ]

    var body: some View {
        GeometryReader { geometry in
            
            VStack{
                ProgressBar(geometry: geometry, progress: $progress,title:"Equipments for delivery",description: "Kindly select one of the equipments to fulfill delivery") // Pass progress as a binding
                    .padding(.trailing,20)                
                ScrollView{
                    ReceiptBox(items: receiptItems,geometry: geometry,size: 0.3)
                    QuestionWithOptionView(question: "What benefits do employees receive?", options: ["Accessories", "Manual instructions", "Vehicle jack", "Training ", "Carrying case"])
                    QuestionWithFileType()
                    QuestionWithFileType()
                    QuestionWithFileType()

                    
                    

                    

                 
                    

                
                }
                Spacer()
                
                
                NavigationLink(destination: EquipmentDeliveryForm2()) {
                    Text("Continue")
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 40)
                        .background(config.primaryColor) // Gray background when profileImage is nil
                        .cornerRadius(8)
                        .padding(.horizontal)
                }

                

                
                
                }
            }
        
    }
}

import SwiftUI
import UniformTypeIdentifiers

struct QuestionWithFileType: View {
    @State private var isShowingDocumentPicker = false
    @State private var selectedFileURLs: [URL] = []

    var body: some View {
        VStack {
            RoundedRectangle(cornerRadius: 9)
                .fill(Color.gray.opacity(0.2))
                .frame(maxWidth: .infinity)
                .frame(height:50)
                .padding()
                .overlay(
                    Button(action: {
                        isShowingDocumentPicker = true
                    }) {
                        HStack {
                            Text("Upload supplier tax invoice (EFD Receipt)")
                                .foregroundColor(.black)
                            Spacer()
                            Image(systemName: "file")
                        }
                        .padding(.horizontal)
                    }
                )
        }
        .sheet(isPresented: $isShowingDocumentPicker) {
            DocumentPicker(selectedFileURLs: $selectedFileURLs)
        }
    }
}

struct DocumentPicker: UIViewControllerRepresentable {
    @Binding var selectedFileURLs: [URL]

    func makeUIViewController(context: Context) -> UIDocumentPickerViewController {
        let picker = UIDocumentPickerViewController(forOpeningContentTypes: [UTType.content], asCopy: true)
        picker.delegate = context.coordinator
        return picker
    }

    func updateUIViewController(_ uiViewController: UIDocumentPickerViewController, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, UIDocumentPickerDelegate {
        var parent: DocumentPicker

        init(_ parent: DocumentPicker) {
            self.parent = parent
        }

        func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
            parent.selectedFileURLs = urls
        }

        func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
            // Handle cancellation
        }
    }
}
