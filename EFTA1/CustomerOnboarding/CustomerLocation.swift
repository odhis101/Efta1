import SwiftUI
import MapKit

struct CustomerLocation: View {
    @State private var searchText = ""
    @State private var searchResults: [MKMapItem] = []
    @State private var selectedCoordinate: CLLocationCoordinate2D?
    @State private var isSearchExpanded = false
    @State private var progress: CGFloat = 0.8 // Initial progress
    @EnvironmentObject var onboardingData: OnboardingData
    @EnvironmentObject var config: AppConfig


    
    var body: some View {
        GeometryReader { geometry in
        VStack {
            ProgressBar(geometry: geometry, progress: $progress,title:"\(onboardingData.titleForCustomerOnboarding) location",description: "Kindly select the location of the customers ")
                .padding(.trailing, 20)


            // make this search bar look better and more searchier 
            TextField("Where do you currently stay?", text: $searchText, onEditingChanged: { editing in
                isSearchExpanded = editing
            }, onCommit: {
                // Handle the commit action if needed (e.g., user presses return)
            }).onChange(of: searchText) { newValue in
                // This will be called every time searchText changes
                searchForLocations() // Fetch locations as user types each character
            }
            .padding()
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .background(Color.white)
            .cornerRadius(10)
            .padding(.horizontal)
            .offset(y: 20) // Adjust the offset as needed

            
            
            
                
            
            ZStack {
                MapView(coordinate: $onboardingData.selectedCoordinate)
                    .edgesIgnoringSafeArea(.all)
                    .frame(height: UIScreen.main.bounds.height * 0.5) // Set map height to 50% of the screen height
                    .padding(.horizontal) // Add horizontal padding
                    
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
            }
            Spacer()
            NavigationLink(destination: CustomerDocument()) {

            Text("Continue")
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .frame(height:40)
                .background(config.primaryColor) // Gray background when profileImage is nil
                .cornerRadius(8)
                .padding(.horizontal)
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
