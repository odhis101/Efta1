import SwiftUI
import MapKit

struct CompanyLocation: View {
    @State private var searchText = ""
    @State private var searchResults: [MKMapItem] = []
    @State private var selectedCoordinate: CLLocationCoordinate2D?
    @State private var isSearchExpanded = false
    @State private var progress: CGFloat = 0.6 // Initial progress
    @EnvironmentObject var onboardingData: CompanyOnboardingData
    @EnvironmentObject var config: AppConfig

    @Environment(\.presentationMode) var presentationMode

    
    var body: some View {
        GeometryReader { geometry in
        VStack {
            ProgressBar(geometry: geometry, progress: $progress,presentationMode: presentationMode, title:"Company onboarding",description: "Kindly collect the following information from the customer")

          
            RoundedRectangle(cornerRadius: 10)
                .fill(Color(hex: "#F2F2F7"))
                .frame(height: 50)
                .frame(maxWidth: .infinity)
                .overlay(
                    HStack {
                        Image("magnifyingglass")
                            .padding(.leading)
                            
                        TextField("Where do you currently stay?", text: $searchText,onEditingChanged: { editing in
                            isSearchExpanded = editing
                        }, onCommit: {
                            // Handle the commit action if needed (e.g., user presses return)
                        }).onChange(of: searchText) { newValue in
                            // This will be called every time searchText changes
                            searchForLocations() // Fetch locations as user types each character
                        }
                    }
                )
                .padding(.horizontal)
        
            
                
            
            ZStack {
                MapView(coordinate: $onboardingData.selectedCoordinate)
                    .edgesIgnoringSafeArea(.all)
                    .frame(height: UIScreen.main.bounds.height * 0.7)
                    .frame(width:UIScreen.main.bounds.width * 1)
                    .padding(.top)
                VStack {
                    if isSearchExpanded {
                        ScrollView {
                            VStack(spacing: 8) {
                                ForEach(searchResults, id: \.self) { mapItem in
                                    VStack(alignment: .leading) {
                                        Text(mapItem.placemark.title ?? "")
                                            .font(.headline)
                                            .foregroundColor(.primary)
                                        Text(mapItem.name ?? "")
                                            .font(.subheadline)
                                            .foregroundColor(.secondary)
                                    }
                                    .padding(.vertical, 8)
                                    .padding(.horizontal)
                                    .background(Color.white)
                                    .cornerRadius(10)
                                    .onTapGesture {
                                        // Update map view coordinates and text field
                                        onboardingData.selectedCoordinate = mapItem.placemark.coordinate
                                        searchText = mapItem.placemark.title ?? ""
                                        isSearchExpanded = false
                                    }
                                }
                            }
                            .padding(.horizontal)
                            .background(Color.white)
                            .cornerRadius(10)
                            .shadow(radius: 5)
                        }
                        .padding(.top, 20) // Adjust the top padding as needed
                        .padding(.horizontal)
                    }
                    
                    Spacer()
                    /*
                    NavigationLink(destination: CustomerDocument()) {
                        Text("Continue")
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height:40)
                            .background(config.primaryColor)
                            .cornerRadius(8)
                            .padding(.horizontal)
                            .padding(.bottom) // Add padding to separate the button from the map
                    }
                     */
                    
                    CustomNavigationButton(destination: CompanyDocument(), label: "Continue", backgroundColor: config.primaryColor)

                    
                    
                }
            }

         
        }
        .onTapGesture {
            // Dismiss keyboard
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        }
    }

    }
    
    private func searchForLocations() {
        let searchRequest = MKLocalSearch.Request()
        searchRequest.naturalLanguageQuery = searchText
        
        let search = MKLocalSearch(request: searchRequest)
        search.start { response, error in
            guard let response = response else {
                print("Error searching for locations: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            
            DispatchQueue.main.async {
                searchResults = response.mapItems
                print("Search Results: \(searchResults)")
            }
        }
    }
}

struct MapView: UIViewRepresentable {
    @Binding var coordinate: CLLocationCoordinate2D?
    
    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.delegate = context.coordinator
        return mapView
    }
    
    func updateUIView(_ uiView: MKMapView, context: Context) {
        if let coordinate = coordinate {
            let region = MKCoordinateRegion(center: coordinate, span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05))
            uiView.setRegion(region, animated: true)
            
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            uiView.removeAnnotations(uiView.annotations)
            uiView.addAnnotation(annotation)
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, MKMapViewDelegate {
        var parent: MapView
        
        init(_ parent: MapView) {
            self.parent = parent
        }
    }
}


struct QuestionWithSearchField: View {
    var placeholder: String
    @State private var searchResults: [MKMapItem] = []
    @Binding var selectedOption: String
    var onCommit: () -> Void // Closure for handling the commit action

    var body: some View {
        VStack(spacing: 10) {
            RoundedRectangle(cornerRadius: 10)
                .fill(Color(hex: "#F2F2F7"))
                .frame(height: 40)
                .frame(maxWidth: .infinity)
                .overlay(
                    HStack {
                        Image("magnifyingglass")
                        TextField(placeholder, text: $selectedOption, onEditingChanged: { editing in
                            // Handle editing changed if needed
                        }, onCommit: {
                            onCommit() // Call the onCommit closure when the user presses return
                        })
                        .padding()
                        .onChange(of: selectedOption) { newValue in
                            // This will be called every time selectedOption changes
                            // You can perform any additional actions here
                            // For example, fetch data based on the new value
                            searchForLocations() // Fetch locations as user types each character
                        }
                    }
                )
                .padding(.horizontal)
        }
    }

    private func searchForLocations() {
        let searchRequest = MKLocalSearch.Request()
        searchRequest.naturalLanguageQuery = selectedOption // Use selectedOption as the query
        
        let search = MKLocalSearch(request: searchRequest)
        search.start { response, error in
            guard let response = response else {
                print("Error searching for locations: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            
            DispatchQueue.main.async {
                self.searchResults = response.mapItems // Access searchResults using self
                print("Search Results: \(self.searchResults)")
            }
        }
    }
}
