import SwiftUI
import UIKit

struct CapturePhoto: View {
    @ObservedObject var viewModel = PhotoCaptureViewModel() // Initialize the ViewModel
    @State private var progress: CGFloat = 0.7// Initial progress
    @EnvironmentObject var onboardingData: OnboardingData  // Use the shared onboarding data

    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                ProgressBar(geometry: geometry, progress: $progress, title: "Capture photo", description: "Kindly collect the following information from the customer")
                    .padding(.trailing, 20)
                
                VStack(spacing: 10) {
                    ZStack {
                        if let image = onboardingData.profileImage {
                            Button(action: {
                                onboardingData.isPickerPresented.toggle()
                                onboardingData.sourceType = .photoLibrary
                            }) {
                                Image(uiImage: image)
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 280, height: 280)
                                    .clipShape(Circle())
                                    .overlay(Circle().stroke(Color.gray, lineWidth: 3))
                                    .padding()
                            }
                        } else {
                            Button(action: {
                                onboardingData.isPickerPresented.toggle()
                                onboardingData.sourceType = .photoLibrary
                            }) {
                                Image(systemName: "person.circle.fill")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 280, height: 280)
                                    .clipShape(Circle())
                                    .overlay(Circle().stroke(Color.gray, lineWidth: 3))
                                    .padding()
                            }
                        }
                    }
                    .padding()
                    
                    Spacer()
                    NavigationLink(destination: CustomerLocation()) {
                        Text("Continue")
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 40)
                            .background(onboardingData.profileImage == nil ? Color.gray : Color(hex: "#2AA241"))
                            .cornerRadius(8)
                            .padding(.horizontal)
                    }
                }
            }
            .sheet(isPresented: $onboardingData.isPickerPresented) {
                ImagePicker(image: $onboardingData.profileImage, isPickerPresented: $onboardingData.isPickerPresented, sourceType: onboardingData.sourceType)
            }
        }
    }
}
