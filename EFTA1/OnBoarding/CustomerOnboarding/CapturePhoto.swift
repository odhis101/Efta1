import SwiftUI
import UIKit

struct CapturePhoto: View {
    @ObservedObject var viewModel = PhotoCaptureViewModel() // Initialize the ViewModel
    @State private var progress: CGFloat = 0.56// Initial progress
    @EnvironmentObject var onboardingData: OnboardingData  // Use the shared onboarding data
    @EnvironmentObject var config: AppConfig

    @Environment(\.presentationMode) var presentationMode
    
    var isFormComplete: Bool {
        onboardingData.profileImage != nil
    }
    

    var body: some View {
        GeometryReader { geometry in
            VStack {
                ProgressBar(geometry: geometry, progress: $progress, presentationMode: presentationMode, title: "Capture photo", description: "Kindly collect the following information from the customer")
                
                VStack(spacing: 10) {
                    Spacer ()
                    ZStack {
                        if let image = onboardingData.profileImage {
                            Button(action: {
                                // Capture a new photo
                                onboardingData.isPickerPresented.toggle()
                                onboardingData.sourceType = .camera // Change to camera
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
                                // Capture a new photo
                                onboardingData.isPickerPresented.toggle()
                                onboardingData.sourceType = .camera // Change to camera
                            }) {
                                
                                Circle()
                                    .fill(Color(hex:"#F2F2F7"))
                                    .frame(width: 280, height: 280)
                                    .overlay(
                                                                      Image(config.user)
                                                                          .resizable()
                                                                          .aspectRatio(contentMode: .fit)
                                                                          .frame(width: 280, height: 280)
                                                                          .clipShape(Circle())
                                                                  
                                                                  )
                                
                            }
                        }
                    }
                    .padding()
                    
                    Spacer()
                    
                    CustomNavigationButton(
                                    destination: CustomerLocation(),
                                    label: "Continue",
                                    backgroundColor: isFormComplete ? config.primaryColor : Color.gray // Pass the color conditionally
                                )
                    
                }
            }
            .sheet(isPresented: $onboardingData.isPickerPresented) {
                ImagePicker(image: $onboardingData.profileImage, isPickerPresented: $onboardingData.isPickerPresented, sourceType: onboardingData.sourceType)
            }
        }
    }
}
struct CapturePhoto_Previews: PreviewProvider {
    static var previews: some View {
        CapturePhoto()
            .environmentObject(OnboardingData()) // Provide a dummy OnboardingData object
            .environmentObject(AppConfig(region: .efken)) // Provide a dummy AppConfig object
    }
}
