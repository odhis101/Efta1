import Combine
import UIKit
import SwiftUI
import MapKit

// Define the DocumentHandling protocol if not already defined
protocol DocumentHandling {
    var documentURLs: [String: [URL]] { get set }  // Dictionary to store document URLs indexed by ID type
    func addDocument(_ document: URL, forIDType idType: String)
    func clearDocuments()
}



class OnboardingData: ObservableObject, DocumentHandling {
    @Published var selectedQuestionIndex = 0
    @Published var isExpanded: Bool = false

    @Published var customerType: Int? = nil // CustomerType:<integer>
    @Published var customerName: String = "" // CustomerName:<string>
    @Published var idType: String? = nil // IdType:<integer>
    @Published var idNumber: String = "" // IdNumber:<string>
    @Published var passportNumber: String = "" // PassportNumber:<string>
    @Published var gender: String? = nil // Gender:<integer>
    @Published var maritalStatus: String? = nil // MaritalStatus:<integer>
    @Published var postalAddress: String = "" // PostalAddress:<string>
    @Published var region: String? = nil // Region:<string>
    @Published var district: String? = nil // District:<string>
    @Published var ward: String = "" // Ward:<string>
    @Published var nationality: String? = nil // Nationality:<string>
    @Published var emailAddress: String = "" // EmailAddress:<string>
    @Published var phoneNumber: String = "" // PhoneNumber:<string>
    @Published var tin: String = "" // TIN:<string>
    @Published var typeOfEquipment: String = "" // TypeOfEquipment:<string>
    @Published var priceOfEquipment: String = "" // PriceOfEquipment:<string>
    @Published var profileImage: UIImage? = nil
    @Published var selectedCoordinate: CLLocationCoordinate2D? = nil // CustomerLocation
    @Published var districtOptions: [String] = []
    @Published var titleForCustomerOnboarding: String = ""

    // UI related states
    @Published var isPickerPresented = false
    @Published var sourceType: UIImagePickerController.SourceType = .photoLibrary

    @Published var documentURLs: [String: [URL]] = [:]

    // Implement DocumentHandling protocol methods
       func addDocument(_ document: URL, forIDType idType: String) {
           if var existingDocuments = documentURLs[idType] {
               existingDocuments.append(document)
               documentURLs[idType] = existingDocuments
           } else {
               documentURLs[idType] = [document]
           }
       }

    func clearDocuments() {
        documentURLs.removeAll()
    }
}

