import SwiftUI
import Combine


/*
 on boarding screen
 */

struct LoginOnBoarding: View {
    // Array containing carousel items
    let carouselItems: [(String, [String])] = [
        ("background3", ["Flexible repayment plan", "To bring a transformative impact to the people "]),
        ("background1", ["Welcome to EFTA", "“When other lenders say no, we often say yes."]),
        ("background2", ["Access Equipment Financing", "For small and medium enterprises across all sectors."]),
    ]
    @State private var isModalVisible = true

    @State private var currentIndex = 0
    @EnvironmentObject var config: AppConfig

    var body: some View {
        NavigationView {
            GeometryReader { geometry in
                ZStack(alignment: .bottom) {
                    // Background Image Carousel
                    ForEach(carouselItems.indices, id: \.self) { index in
                        Image(carouselItems[index].0)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: geometry.size.width, height: geometry.size.height + 5 )
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
                                Image(config.splashImageName)
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: geometry.size.width * 0.5, height: geometry.size.width * 0.3)
                            }
                            .padding(.bottom, geometry.safeAreaInsets.bottom+300) // Adjust the bottom padding as needed
                            if !isModalVisible{
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(Color.black.opacity(0.5)) // Semi-transparent black background
                                    .padding()
                                    .frame(height:geometry.size.height * 0.25)
                                    .overlay(
                                
                                        VStack(alignment: .leading) {
                                    ForEach(carouselItems[currentIndex].1.indices, id: \.self) { index in
                                        let text = carouselItems[currentIndex].1[index]
                                        
                                        Text(text)
                                            .font(index == 0 ? .title : .headline)
                                            .foregroundColor(.white)
                                            .fontWeight(index == 0 ? .bold : .regular)
                                            .multilineTextAlignment(.leading)
                                            .padding(.top, index == 0 ? 8 : 8) // Add top padding for the first text
                                            .padding(.bottom, index == 0 ? 0 : 8) // Add top padding for the first text

                                            .padding(.horizontal)


                                    }
                                }
                                        
                                        
                            )
                                                        }
                            else{
                                Spacer ()
                            }
                           
                            
                            // Buttons Section
                            VStack(spacing: 16) {
                              
                                // Page Indicator (Dots)
                                //PageControl(numberOfPages: carouselItems.count, currentPage: $currentIndex)
                                Spacer ()
                                // Continue Button
                                Button(action: {
                                    isModalVisible.toggle()
                                }) {
                                    Text("Continue")
                                        .foregroundColor(.white) // Set text color to white
                                        .padding()
                                        .cornerRadius(8)
                                        .frame(maxWidth: .infinity)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 8)
                                                .stroke(config.primaryColor, lineWidth: 2)
                                        )
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
                         ModalViews(isVisible: $isModalVisible)
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





struct ModalViews: View {
    @Binding var isVisible: Bool
    @GestureState private var dragState = DragState()
    
    // State variables for input fields
    
    // State variable to track keyboard height
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
                    
                    VStack(spacing: 16) {
                        // Title
                        HStack {
                       
                                    Capsule()
                                        .fill(Color.gray.opacity(0.8))
                                        .frame(width: 30, height: 6)
                                
                        }
                        
                        HStack {
                            VStack(alignment: .leading) {
                                Text("Welcome to Efta")
                                    .font(.title)
                                    .fontWeight(.bold)
                                    .foregroundColor(config.primaryColor)
                                    .multilineTextAlignment(.leading)
                                    .padding(.bottom)
                                
                                Text("When other lenders say no, we often say yes.")
                                    .font(.headline)
                                    .foregroundColor(Color.gray)
                                    .multilineTextAlignment(.leading)
                                    .padding(.bottom)
                            }
                        }
                        // Continue Button
                      NavigationLink(destination: Login()) {
                            Text("Continue")
                                .foregroundColor(.white)
                                .cornerRadius(8)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(config.primaryColor) 

                        }
                        
                        HStack {
                            
                                RoundedRectangle(cornerRadius: 8)
                                         .foregroundColor(.gray)
                                         .frame(maxWidth: .infinity,minHeight: 20)
                                         .frame( height: 40 )
                                         .overlay(
                                             HStack {
                                                 Image(systemName: "phone")
                                                     .foregroundColor(.white)
                                                     .padding(.horizontal, 10)
                                                 Text("Contact us")
                                                     .foregroundColor(.white)
                                                     .padding(.vertical, 10)
                                             }
                                         )
                                         .onTapGesture {
                                             // Handle contact us button action here
                                         }
                                    
                                    Spacer()
                                    
                            RoundedRectangle(cornerRadius: 8)
                                         .foregroundColor(.gray)
                                         .frame(maxWidth: .infinity,minHeight: 20)
                                         .frame( height: 40 )
                                         .overlay(
                                             HStack {
                                                 Image("help")
                                                     .foregroundColor(.white)
                                                     .padding(.horizontal, 10)
                                                 Text("Help")
                                                     .foregroundColor(.white)
                                                     .padding(.vertical, 10)
                                             }
                                         )
                                         .onTapGesture {
                                             // Handle contact us button action here
                                         }
                            
                        }
                        
                    }
                    .padding()
                }.padding(.bottom, keyboardHeight) // Move below keyboard

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
        UIScreen.main.bounds.height * 0.35
    }
    
    private struct DragState {
        // No need for any member here
    }
}
