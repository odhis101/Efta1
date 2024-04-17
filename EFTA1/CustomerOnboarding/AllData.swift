import Combine
import UIKit
import SwiftUI
import MapKit


class OnboardingData: ObservableObject {
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
    @Published var nationalityState:String? = nil
    @Published var EmailAddress:String=""
    @Published var PhoneNumber:String=""
    @Published var TIN:String=""
    @Published var Equipmentprice:String=""
    @Published var profileImage: UIImage?
    @Published var selectedCoordinate: CLLocationCoordinate2D?
    @Published var titleForCustomerOnboarding:String=""
    @Published var isPickerPresented = false
    @Published var sourceType: UIImagePickerController.SourceType = .photoLibrary



}
