import SwiftUI
import Combine


/*
 on boarding screen
 */

struct OnBoard: View {
    // Array containing carousel items
    let carouselItems: [(String, [String])] = [
        ("background1", ["Welcome to EFTA", "“When other lenders say no, we often say yes."]),
        ("background2", ["Access Equipment Financing", "For small and medium enterprises across all sectors."]),
        ("background3", ["Flexible repayment plan", "To bring a transformative impact to the people "]),
    ]
    @State private var isModalVisible = false

    @State private var currentIndex = 0
    @State private var StaffNumber:String=""
    @State private var PhoneNumber:String=""



    var body: some View {
        NavigationView {
            GeometryReader { geometry in
                ZStack(alignment: .bottom) {
                    // Background Image Carousel
                    ForEach(carouselItems.indices, id: \.self) { index in
                        Image(carouselItems[index].0)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: geometry.size.width, height: geometry.size.height)
                            .opacity(index == currentIndex ? 1 : 0) // Show only the current image
                            .animation(.easeInOut(duration: 1.0)) // Add animation for opacity change
                            .transition(.opacity) // Apply opacity transition
                            .padding(index == 1 ? .bottom : .top, 0)

                    }
                    
                    // Main content
                    ScrollView {
                        VStack {
                            // Logo or Image
                            Spacer()
                            
                            HStack(alignment: .center) {
                                Image("splashView")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: geometry.size.width * 0.5, height: geometry.size.width * 0.3)
                            }
                            .padding(.bottom, geometry.safeAreaInsets.bottom+300) // Adjust the bottom padding as needed

                            ZStack {
                                        RoundedRectangle(cornerRadius: 10)
                                            .fill(Color.black.opacity(0.5)) // Semi-transparent black background
                                            .padding()
                                        
                                        VStack {
                                            ForEach(carouselItems[currentIndex].1.indices, id: \.self) { index in
                                                let text = carouselItems[currentIndex].1[index]
                                                
                                                Text(text)
                                                    .font(index == 0 ? .title : .headline)
                                                    .foregroundColor(.white)
                                                    .fontWeight(index == 0 ? .bold : .regular)
                                                    .multilineTextAlignment(.leading) // Change alignment to leading (left-aligned)
                                                    .padding(
                                                    ) // Apply top padding if index is 0, otherwise apply bottom padding

                                            }
                                        }
                                    }
                            
                            // Buttons Section
                            VStack(spacing: 16) {
                              
                                // Page Indicator (Dots)
                                PageControl(numberOfPages: carouselItems.count, currentPage: $currentIndex)
                                
                                // Continue Button
                                Button(action: {
                                    isModalVisible.toggle()
                                }) {
                                    
                                    Text("Continue")
                                        .foregroundColor(.white)
                                        .cornerRadius(8)
                                        .frame(maxWidth: .infinity)
                                        .frame(height:30)
                                        .padding()
                                        .background(Color.green) // Set background color to green when enabled, gray when disabled
                                        .cornerRadius(20)
                                }
                                .padding(.horizontal, 20)
                                
                                .padding(.vertical, 16)
                            }
                        }
                    }
                    .gesture(
                        DragGesture()
                            .onEnded { value in
                                if value.translation.width < 0 {
                                    currentIndex = (currentIndex + 1) % carouselItems.count
                                } else {
                                    currentIndex = currentIndex == 0 ? carouselItems.count - 1 : currentIndex - 1
                                }
                            }
                    )
                    
                    .overlay(
                         ModalView(isVisible: $isModalVisible)
                             .animation(.easeInOut)
                     )
            
                    
                  
                }
                .navigationBarHidden(true)
            }
            .navigationBarHidden(true)
        }
        .navigationBarHidden(true)
    }
}

struct PageControl: View {
    var numberOfPages: Int
    @Binding var currentPage: Int

    var body: some View {
        HStack {
            ForEach(0..<numberOfPages) { page in
                Circle()
                    .fill(page == currentPage ? Color.green : Color.gray)
                    .frame(width: 10, height: 10)
                    .padding(5)
            }
        }
    }
}




struct ModalView: View {
    @Binding var isVisible: Bool
    @GestureState private var dragState = DragState()
    @State private var keyboardHeight: CGFloat = 0
    @State private var staffNumber = ""
    @State private var phoneNumber = ""
    @State private var isLoading = false
    @State private var navigationActive = false
    
    // State variable to track keyboard height
   
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                Spacer()
                ZStack {
                    Rectangle()
                        .fill(Color.white)
                        .frame(width: geometry.size.width, height: modalHeight)
                        .cornerRadius(20)
                    
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
                        
                        HStack {
                            VStack {
                                Text("Welcome to Efta")
                                    .font(.title)
                                    .fontWeight(.bold)
                                    .foregroundColor(Color(hex: "#2AA241"))
                                
                                Text("When other lenders say no, we often say yes.")
                                    .font(.headline)
                                    .foregroundColor(Color.gray)
                            }
                        }
                        
                        CustomTextField(placeholder: "Staff Number", text: $staffNumber)
                        
                        CustomTextField(placeholder: "Phone Number", text: $phoneNumber)
                        if isLoading {
                                ProgressView()
                                } else {
                                    submitButton
                                    }

                        
                    }
                    .padding()
                }
                .padding(.bottom, keyboardHeight) // Move below keyboard
            }
            
            .offset(y: isVisible ? 0 : geometry.size.height)// Adjust offset
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
            .background(
                          NavigationLink(destination: Verification(), isActive: $navigationActive) { EmptyView() }
                      )
        }
        .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardWillShowNotification)) { notification in
            guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
            self.keyboardHeight = keyboardFrame.height
        }
        .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardWillHideNotification)) { _ in
            self.keyboardHeight = 0
        }
    }
    private var submitButton: some View {
           Button("Continue") {
               sendStaffDetails()
           }
           .foregroundColor(.white)
           .frame(maxWidth: .infinity)
           .frame(height: 60)
           .background(Color.green)
           .cornerRadius(8)
           .padding(.horizontal)
           .padding(.vertical, 16)
       }
       
    
    private var modalHeight: CGFloat {
        UIScreen.main.bounds.height * 0.5
    }
    
    private struct DragState {
        // No need for any member here
    }
    
    private func sendStaffDetails() {
          isLoading = true
          NetworkManager.shared.sendStaffDetails(staffNumber: staffNumber, phoneNumber: phoneNumber) { success, error in
              isLoading = false
              if success {
                  navigationActive = true
              } else {
                  // Handle error, show an alert or message to the user
                  print(error?.localizedDescription ?? "Unknown error")
              }
          }
     }
}

struct CustomTextField: View {
    var placeholder: String
    @Binding var text: String

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 8) // Rounded rectangle background
                .stroke(Color.gray, lineWidth: 1) // Border color and width
                .frame(height: 50) // Adjust height as needed
            
            TextField(placeholder, text: $text) // TextField overlay
                .padding(.horizontal) // Add horizontal padding for text
        }
        .padding(.vertical, 8) // Adjust vertical padding as needed
    }
}
