//
//  CompanyOnBoardingData.swift
//  EFTA1
//
//  Created by Joshua on 5/23/24.
//

import Combine
import UIKit
import SwiftUI
import MapKit




import SwiftUI
import Combine

class CompanyOnboardingData: ObservableObject,DocumentHandling {
    // Page 1

    @Published var companyName: String = ""
    @Published var TIN: String = ""
    @Published var VRN: String = ""
    @Published var postalAddress: String = ""
    @Published var region: String?
    @Published var district: String?
    @Published var districtOptions: [String] = []
    @Published var ward: String = ""

    // Page 2
    @Published var contactPersonName: String = ""
    @Published var idType: String?
    @Published var idNumber: String = ""
    @Published var phoneNumber: String = ""
    @Published var passportNumber: String = ""

    @Published var emailAddress: String = ""
    @Published var nationality: String? = nil // Nationality:<string>
    @Published var typeOfEquipment: String = ""
    @Published var priceOfEquipment: String = ""

    // Page 3 (Location-related variables)
    // Add your own logic here
    @Published var selectedCoordinate: CLLocationCoordinate2D? = nil // CustomerLocation


    // Page 4 (Documents-related variables)
    // Add your own logic here
    @Published var documentURLs: [String: [URL]] = [:]


    // Implement any DocumentHandling methods if required
    
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
    
    // Method to reset all properties to their initial values
      func reset() {
          companyName = ""
          TIN = ""
          VRN = ""
          postalAddress = ""
          region = nil
          district = nil
          districtOptions = []
          ward = ""
          contactPersonName = ""
          idType = nil
          idNumber = ""
          phoneNumber = ""
          passportNumber = ""
          emailAddress = ""
          nationality = nil
          typeOfEquipment = ""
          priceOfEquipment = ""
          selectedCoordinate = nil
          documentURLs = [:]
      }
}
