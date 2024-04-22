//
//  CustomerMonitoringDocumentList.swift
//  EFTA1
//
//  Created by Joshua on 4/11/24.
//
/*
import SwiftUI

struct CustomerMonitoringDocumentList: View {
    var title: String

    @StateObject var documentHandler = CustomerMonitoringDocumentHandler()
    
    @State private var progress: CGFloat = 0.6 // Initial progress
    @EnvironmentObject var config: AppConfig


    var body: some View {

        GeometryReader { geometry in
            
            VStack{
                ProgressBar(geometry: geometry, progress: $progress,title:title,description: "Kindly complete the following details") // Pass progress as a binding
                    .padding(.trailing,20)

                ScrollView{
                    
                    
                    ForEach(documentHandler.selectedDocuments, id: \.self) { documentURL in
                            ListedDocument(documentName: documentURL.lastPathComponent)
                            }
           
                    
                }
                Spacer ()
                NavigationLink(destination: Dashboard()){
                Text("Continue")
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height:40)
                    .background(config.primaryColor) // Gray background when profileImage is nil
                    .cornerRadius(8)
                    .padding(.horizontal)
                }

                }
            }
            
       

    }
}
/*
struct ListedDocument: View {
    var documentName: String
    @EnvironmentObject var config: AppConfig

    var body: some View {
        VStack {
            RoundedRectangle(cornerRadius: 8)
                .fill(Color.gray.opacity(0.2))
                .frame(maxWidth: .infinity)
                .frame(height: 50)
                .overlay(
                    VStack {
                        HStack {
                            Image(systemName: "doc")
                                .resizable()
                                .frame(width: 30, height: 30) // Adjusted size for better layout
                                .foregroundColor(config.primaryColor)
                            
                            Text(documentName) // Use the passed document name
                                .font(.headline)
                            Spacer()

                            Image(systemName: "checkmark")
                                .resizable()
                                .frame(width: 20, height: 20) // Adjusted size for better layout
                                .foregroundColor(config.primaryColor)
                        }
                        RoundedRectangle(cornerRadius: 8)
                            .fill(config.primaryColor)
                            .frame(maxWidth: .infinity)
                            .frame(height: 1)
                    }
                )
        }
    }
}
*/
*/
