import SwiftUI
import Combine
import AlertToast


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
    @EnvironmentObject var config: AppConfig
    @EnvironmentObject var pinHandler: PinHandler



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

                    }
                    

                        VStack {
                            
                            HStack(alignment: .center) {
                                Image(config.splashImageName)
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: geometry.size.width * 0.5, height: geometry.size.width * 0.3)
                            }
                            .padding(.bottom,geometry.size.height*0.35)
                            Spacer ()
                        
                            
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
                                    
                            // Buttons Section
                            VStack(spacing: 16) {
                              
                                // Page Indicator (Dots)
                                if !isModalVisible{
                                    PageControl(numberOfPages: carouselItems.count, currentPage: $currentIndex)
                                }
                                else {
                                    Rectangle()
                                        .frame(width: geometry.size.width * 1, height: geometry.size.height * 0.2)
                                        .foregroundColor(.white)
                                    
                                }
                                
                                // Continue Button
                                if !isModalVisible{
                                    Button(action: {
                                        isModalVisible.toggle()
                                    }) {
                                        
                                        Text("Get Started")
                                            .foregroundColor(.white)
                                            .cornerRadius(8)
                                            .frame(width:geometry.size.width * 0.8)
                                            .frame(height:30)
                                            .padding()
                                            .background(config.primaryColor)
                                            .cornerRadius(10)
                                    }
                                }
                                else {
                                  
                        
                                    
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
                             .offset(y: isModalVisible ? 0 : geometry.size.height) // Set initial offset

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
    @EnvironmentObject var config: AppConfig

    var numberOfPages: Int
    @Binding var currentPage: Int

    var body: some View {
        HStack {
            ForEach(0..<numberOfPages) { page in
                Circle()
                    .fill(page == currentPage ? config.primaryColor : Color.gray)
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
    @EnvironmentObject var pinHandler: PinHandler
    @State private var isLoading = false
    @State private var navigationActive = false
    @State private var navigateToLogin = false
    @State private var navigateToSecurityQuestions = false


    @EnvironmentObject var config: AppConfig
    @State private var modalMove: CGFloat = 0
    @State var showAlert = false


    
    

    
    // State variable to track keyboard height
   
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                
                Spacer()
                    .toast(isPresenting: $showAlert) {
                                         AlertToast(displayMode: .hud, type: .error(Color.red), title: "Error", subTitle: "Something went wrong. Please try again.")
                                     }

                ZStack {
                    Rectangle()
                        .fill(Color.white)
                        .frame(width: geometry.size.width, height: modalHeight)
                    VStack(spacing: 16) {
                        // Title
                        HStack {
                       
                                    Capsule()
                                        .fill(Color.gray.opacity(0.8))
                                        .frame(width: 30, height: 6)
                                
                        }
                        
                        
                      
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

                                
                                CustomTextField(placeholder: "Staff Number", text: $pinHandler.staffNumber)
                                
                                CustomTextField(placeholder: "Phone Number", text: $pinHandler.phoneNumber)
                                
                                
                                                            }
                       
                       
                        
                        if isLoading {
                                ProgressView()
                                } else {

                                    Button("Continue") {
                                        sendStaffDetails()
                                    }
                                    .foregroundColor(.white)
                                    .cornerRadius(8)
                                    .frame(width:geometry.size.width * 0.8)
                                    .frame(height:60)
                                    .background(config.primaryColor)
                                    .cornerRadius(10)
                                
                                }

                        
                    }
                    .padding()
                }
                //.padding(.bottom, keyboardHeight) // Move below keyboard
                .padding(.bottom,modalMove)
                .padding(.top,-10)
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
            .background(
                          NavigationLink(destination: SecurityQuestions(), isActive: $navigateToSecurityQuestions) { EmptyView() }
                      )
            .background(
                          NavigationLink(destination: Login(), isActive: $navigateToLogin) { EmptyView() }
                      )
            .onTapGesture {
                            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                        }
        }
        .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardWillShowNotification)) { notification in
            guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
            self.keyboardHeight = keyboardFrame.height
            modalMove = 180
        }
        .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardWillHideNotification)) { _ in
            self.keyboardHeight = 0
            modalMove = 0
        }
    }
 
       
    private var modalHeight: CGFloat {
        UIScreen.main.bounds.height * 0.5
    }
    
    private struct DragState {
        // No need for any member here
    }
    
    private func sendStaffDetails() {
        isLoading = true
        NetworkManager.shared.sendStaffDetails(staffNumber: pinHandler.staffNumber, phoneNumber: pinHandler.phoneNumber) { success, isPastAccLookUp, hasSetPin, hasSetSecurityQuestions, error in
            DispatchQueue.main.async {
                self.isLoading = false
                print("staff number", self.pinHandler.staffNumber)
                if success {
                    if isPastAccLookUp == true && hasSetPin == true && hasSetSecurityQuestions == true  {
                        self.navigateToLogin = true
                        print("On Boarding Conditions  met: isPastAccLookUp: \(isPastAccLookUp), hasSetPin: \(hasSetPin), hasSetSecurityQuestions: \(hasSetSecurityQuestions)")

                    }
                    if isPastAccLookUp && hasSetPin && !hasSetSecurityQuestions {
                        self.navigateToSecurityQuestions = true
                        print("On Boarding Conditions not met but pin has been set : isPastAccLookUp: \(isPastAccLookUp), hasSetPin: \(hasSetPin), hasSetSecurityQuestions: \(hasSetSecurityQuestions)")

                        
                    }
                    if !isPastAccLookUp || !hasSetPin || !hasSetSecurityQuestions {
                        print("On Boarding Conditions not met: isPastAccLookUp: \(isPastAccLookUp), hasSetPin: \(hasSetPin), hasSetSecurityQuestions: \(hasSetSecurityQuestions)")
                    }
               
                } else {
                    // Handle error, show an alert or message to the user
                    print(error?.localizedDescription ?? "Unknown error")
                    self.showAlert = true
                }
            }
        }
    }
}

struct CustomTextField: View {
    var placeholder: String
    @Binding var text: String

    var body: some View {
      
            TextField(placeholder, text: $text)
                .textFieldStyle(CustomTextFieldStyle())
                .keyboardType(.numberPad) // Restrict input to numbers only


    }
}

struct CustomTextFieldStyle: TextFieldStyle {
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .padding(.horizontal, 16) // Add horizontal padding to the placeholder text
            .frame(height: 50)
            .background(Color(hex: "#F2F2F7")) // Set background color with opacity
            .cornerRadius(8)
            //.foregroundColor(.red) // changed to red to see if anything changes 
            
    }
}

struct ModalViewStatement: View {
    @Binding var isVisible: Bool
    @GestureState private var dragState = DragState()
    @State private var keyboardHeight: CGFloat = 0
    @EnvironmentObject var pinHandler: PinHandler
    @State private var isLoading = false
    @State private var navigationActive = false
    @EnvironmentObject var config: AppConfig
    @State private var modalMove: CGFloat = 0

    @EnvironmentObject var onboardingData: OnboardingData
    var body: some View {
        GeometryReader { geometry in
            VStack {
                Spacer()
                ZStack {
                    Rectangle()
                        .fill(Color.white)
                        .frame(width: geometry.size.width, height: modalHeight)
                        .cornerRadius(20)
                        .shadow(color: Color.black.opacity(0.5), radius: 10, x: 0, y: 5)

                    
                    VStack(spacing: 16) {
                        // Title
                        HStack {
                       
                                    Capsule()
                                        .fill(Color.gray.opacity(0.8))
                                        .frame(width: 30, height: 6)
                                
                        }
                        
                      
                            VStack(alignment: .leading) {
                                Text("Get Statement")
                                    .fontWeight(.bold)
                                    .foregroundColor(config.primaryColor)
                                    .multilineTextAlignment(.leading)
                                    .padding(.bottom)
                                
                                Text("Kindly fill in the details below to generate  statement")
                                    .font(.caption)
                                    .foregroundColor(Color.gray)
                                    .multilineTextAlignment(.leading)
                                    .padding(.bottom)

                                
                                QuestionWithDropdownStatement(question: "Type Of ID", options: ["Driving License", "Passport","National ID "], selectedOption: $onboardingData.idType)
                                QuestionWithDateStatement(question: "Start Date")
                                QuestionWithDateStatement(question: "End Date")

                                
                                
                                                            }
                       
                       
                        
                        if isLoading {
                                ProgressView()
                                } else {

                                    Button("Generate Statment") {
                                        sendStaffDetails()
                                    }
                                    .foregroundColor(.white)
                                    .frame(width:geometry.size.width * 0.8)
                                    .frame(height:30)
                                    .padding()
                                    .background(config.primaryColor)
                                
                                }

                        
                    }
                    .padding()
                }
                //.padding(.bottom, keyboardHeight) // Move below keyboard
                .padding(.bottom,modalMove)
                .padding(.top,-10)
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
            modalMove = 200
        }
        .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardWillHideNotification)) { _ in
            self.keyboardHeight = 0
            modalMove = 0
        }
    }
 
       
    private var modalHeight: CGFloat {
        UIScreen.main.bounds.height * 0.6
    }
    
    private struct DragState {
        // No need for any member here
    }
    
    private func sendStaffDetails() {
        isLoading = true
        NetworkManager.shared.sendStaffDetails(staffNumber: pinHandler.staffNumber, phoneNumber: pinHandler.phoneNumber) { success, isPastAccLookUp, hasSetPin, hasSetSecurityQuestions, error in
            DispatchQueue.main.async {
                self.isLoading = false
                print("staff number", self.pinHandler.staffNumber)
                if success {
                    if isPastAccLookUp && hasSetPin && hasSetSecurityQuestions {
                        self.navigationActive = true
                    } else {
                        // Handle the case where not all conditions are met
                        print("Conditions not met: isPastAccLookUp: \(isPastAccLookUp), hasSetPin: \(hasSetPin), hasSetSecurityQuestions: \(hasSetSecurityQuestions)")
                       // self.showAlert = true
                    }
                } else {
                    // Handle error, show an alert or message to the user
                    print(error?.localizedDescription ?? "Unknown error")
                    //self.showAlert = true
                }
            }
        }
    }
}
struct OnBoard_Previews: PreviewProvider {
    static var previews: some View {
        OnBoard()
            .environmentObject(AppConfig(region: .efken))
            .environmentObject(PinHandler())
    }
}
