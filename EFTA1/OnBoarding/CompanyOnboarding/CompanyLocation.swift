import SwiftUI
import MapKit

struct CompanyLocation: View {
    @State private var searchText = ""
    @State private var searchResults: [MKMapItem] = []
    @State private var selectedCoordinate: CLLocationCoordinate2D?
    @State private var isSearchExpanded = false
    @State private var progress: CGFloat = 0.7 // Initial progress
    @EnvironmentObject var onboardingData: CompanyOnboardingData
    @EnvironmentObject var config: AppConfig
    @StateObject private var locationManager = LocationManager()
    @EnvironmentObject var StolenonboardingData: OnboardingData

    @Environment(\.presentationMode) var presentationMode

    
    var body: some View {
        GeometryReader { geometry in
        VStack {
            ProgressBar(geometry: geometry, progress: $progress,presentationMode: presentationMode, title:"\(StolenonboardingData.titleForCustomerOnboarding) location",description: "Kindly select the location of the customers ")

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
                
                    CustomNavigationButton(destination: CompanyDocument(), label: "Continue", backgroundColor: config.primaryColor)

                    
                    
                }
            }
            .onAppear {
                // Request location updates
                locationManager.requestLocation()
            }
            .onReceive(locationManager.$location) { location in
                // Update selectedCoordinate when location changes
                if let location = location {
                    onboardingData.selectedCoordinate = location.coordinate
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

