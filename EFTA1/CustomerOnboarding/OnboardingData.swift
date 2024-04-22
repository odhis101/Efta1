import Combine
import UIKit
import SwiftUI
import MapKit

// Define the DocumentHandling protocol if not already defined
protocol DocumentHandling: AnyObject {
    var documentURLs: [URL] { get set }
    func addDocuments(_ documents: [URL])
    func clearDocuments()
}

// OnboardingData class now explicitly conforms to DocumentHandling
class OnboardingData: ObservableObject, DocumentHandling {
    @Published var selectedQuestionIndex = 0
    @Published var isExpanded: Bool = false
    @Published var selectedRegion: String? = nil
    @Published var selectedDistrict: String? = nil
    @Published var gender: String? = nil
    @Published var maritalStatus: String? = nil
    @Published var idNumber: String = ""
    @Published var name: String = ""
    @Published var postalAddress: String = ""
    @Published var ward: String = ""
    @Published var districtOptions: [String] = []
    @Published var nationalityState: String? = nil
    @Published var EmailAddress: String = ""
    @Published var PhoneNumber: String = ""
    @Published var TIN: String = ""
    @Published var TypesOfEquipments: String = ""
    @Published var Equipmentprice: String = ""
    @Published var profileImage: UIImage?
    @Published var selectedCoordinate: CLLocationCoordinate2D?
    @Published var titleForCustomerOnboarding: String = ""
    @Published var isPickerPresented = false
    @Published var sourceType: UIImagePickerController.SourceType = .photoLibrary
    
    @Published var TypesOfEquimpments: String = ""

    @Published var IDtype: String? = nil
    @Published var documentURLs: [URL] = []  // This property is part of DocumentHandling

    // Implement DocumentHandling protocol methods
    func addDocuments(_ documents: [URL]) {
        documentURLs.append(contentsOf: documents)
    }

    func clearDocuments() {
        documentURLs.removeAll()
    }
}

