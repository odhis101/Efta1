import SwiftUI
import Combine
import UIKit
import SwiftUI
import SwiftUI
import Combine
import UIKit

class SiteDetailsDataHandler: ObservableObject {
    // Site details
    @Published var fullDescriptionOfSite: UIImage?
    @Published var isLandOwnershipConfirmed: Bool = false
    @Published var landRentingDetails: String = ""
    @Published var deliveryChallenges: UIImage?
    @Published var securityArrangements: UIImage?
    @Published var electricalFacilities: UIImage?
    @Published var waterAndOtherFacilities: UIImage?
    @Published var siteChangesRequired: UIImage?
    @Published var experienceInMachinery: String = ""
    @Published var areCustomersOnSite: Bool = false
    
    // Documentation & Assets
    @Published var missingCertificates: UIImage?
    @Published var assetsInGoodStanding: UIImage?
    @Published var stockLevelsAligned: UIImage?
    @Published var orderBooksAndPayments: UIImage?
    
    // Market details
    @Published var isSectorNotFamiliarToEFTA: Bool = false
    @Published var areProductionProcessesDiscussed: Bool = false
    @Published var areTypicalCustomersDiscussed: Bool = false
    @Published var areTopThreeCustomersIdentified: Bool = false
    @Published var areKeyCompetitorsConfirmed: Bool = false
    @Published var isDifferentiationStrategyDiscussed: Bool = false
    @Published var areCreditTermsConfirmed: Bool = false
    
    @Published var isApplicantUnderstandingProductSalesTime: Bool = false
    @Published var isApplicantReliantOnGovernmentCustomers: Bool = false
    @Published var isApplicantSellingProductsAtOnce: Bool = false
    @Published var isApplicantSellingThroughoutYear: Bool = false
    @Published var isSeasonalityImpactingBusiness: Bool = false
    @Published var areForecastedVolumesMakingSense: Bool = false
    @Published var isOtherIncomeSourcesVerified: Bool = false
    @Published var isDifferentProductsProductionDiscussed: Bool = false
    @Published var areAdditionalServicesConsidered: Bool = false
    
    @Published var otherIncomeSourcesProof: UIImage?
    @Published var potentialProductDiversification: Bool = false
    @Published var additionalServicesConsideration: Bool = false
    
    // Character & Credit
    @Published var arePhoneNumbersAndReferencesCollected: Bool = false
    @Published var isCreditDisputeDiscussed: Bool = false
    @Published var isCreditInfoSearchConducted: Bool = false
    @Published var isDownpaymentDiscussed: Bool = false
    @Published var areExistingLoansReviewed: Bool = false
    @Published var areDebtorsChecked: Bool = false
    @Published var areNeighborsConsulted: Bool = false
    @Published var areEmployeesConsulted: Bool = false
    @Published var topThreeChallenges: Bool = false
    @Published var typicalApplicantsAndTheirBusinesses: Bool = false
    @Published var downPaymentDiscussion: Bool = false
    @Published var downPaymentPaymentPlan: Bool = false
    @Published var applicantsDebtors: Bool = false
    @Published var donwnPaymentPaymentPlan: Bool = false
    @Published var donwnPaymentDiscussion: Bool = false


    
    
    // Financial Data
    @Published var areSchedulesCompleted: Bool = false
    @Published var arePricesConsistent: Bool = false
    @Published var areWagesDiscussed: Bool = false
    @Published var isESGQuestionnaireCompleted: Bool = false
    @Published var plansToDifferentiate: Bool = false
    @Published var arePreRequisitesNoted: Bool = false
    @Published var isPhotographicEvidenceTaken: UIImage?
    
    
    
    // Impact Reporting
    @Published var numberOfPermanentMaleEmployees: String = ""
    @Published var numberOfPermanentFemaleEmployees: String = ""
    @Published var numberOfCasualMaleEmployees: String = ""
    @Published var numberOfCasualFemaleEmployees: String = ""
    @Published var daysEmployedPerMonthByCasuals: String = ""
    @Published var HealthInsurance: Bool = false
    @Published var monthlyWages: String = ""
    @Published var dailyWages: String = ""
    @Published var revenuesLastMonth: String = ""
    @Published var revenuesThisMonth: String = ""
    @Published var revenuesNextMonth: String = ""
    @Published var customerSignature: UIImage?
    @Published var captureSignatureImage: UIImage?
    @Published var hasHealthBenefitsForPermanentEmployees: Bool = false
}
