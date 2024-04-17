import SwiftUI
/*
 splash view screen
 */
struct SplashView: View {
    @State private var isActive = false
    
    var body: some View {
        NavigationView {
            GeometryReader { geometry in
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        Image("splashView")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(maxWidth:.infinity)
                            
                        
                        
                            .onAppear {
                                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                                    isActive = true
                                }
                            }
                         
                        Spacer()
                    }
                    Spacer()
                }
                .edgesIgnoringSafeArea(.all)
                .navigationBarHidden(true)
                
                
                 .background(
                    
                    NavigationLink(
                        destination:
                            OnBoard(),
                        isActive: $isActive,
                        label: { EmptyView() }
                    )
                )
                 
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

