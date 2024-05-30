import Foundation
import Combine

import Foundation
import Combine

class AuthManager: ObservableObject {
    static let shared = AuthManager()
    
    private let keychainServiceToken = "com.yourapp.token"
    private let keychainServiceUserId = "com.yourapp.userId"
    private let keychainServicePhoneNumber = "com.yourapp.phoneNumber"
    private let keychainServiceUsername = "com.yourapp.username"
    private let keychainAccountToken = "userToken"
    private let keychainAccountUserId = "userId"
    private let keychainAccountPhoneNumber = "userPhoneNumber"
    private let keychainAccountUsername = "userUsername"

    // Save token to Keychain
    func saveToken(_ token: String) {
        guard let data = token.data(using: .utf8) else {
            print("Failed to convert token to data")
            return
        }
        let isSaved = KeychainManager.shared.save(data, service: keychainServiceToken, account: keychainAccountToken)
        print(isSaved ? "Token saved successfully" : "Failed to save token")
    }
    
    // Save user ID to Keychain
    func saveUserId(_ userId: String) {
        guard let data = userId.data(using: .utf8) else {
            print("Failed to convert user ID to data")
            return
        }
        let isSaved = KeychainManager.shared.save(data, service: keychainServiceUserId, account: keychainAccountUserId)
        print(isSaved ? "User ID saved successfully" : "Failed to save user ID")
    }
    
    // Save phone number to Keychain
    func savePhoneNumber(_ phoneNumber: String) {
        guard let data = phoneNumber.data(using: .utf8) else {
            print("Failed to convert phone number to data")
            return
        }
        let isSaved = KeychainManager.shared.save(data, service: keychainServicePhoneNumber, account: keychainAccountPhoneNumber)
        print(isSaved ? "Phone number saved successfully" : "Failed to save phone number")
    }
    
    // Save username to Keychain
    func saveUsername(_ username: String) {
        guard let data = username.data(using: .utf8) else {
            print("Failed to convert username to data")
            return
        }
        let isSaved = KeychainManager.shared.save(data, service: keychainServiceUsername, account: keychainAccountUsername)
        print(isSaved ? "Username saved successfully" : "Failed to save username")
    }

    // Load token from Keychain
    func loadToken() -> String? {
        guard let tokenData = KeychainManager.shared.load(service: keychainServiceToken, account: keychainAccountToken) else {
            print("No token found in Keychain")
            return nil
        }
        return String(data: tokenData, encoding: .utf8)
    }
    
    // Load user ID from Keychain
    func loadUserId() -> String? {
        guard let userIdData = KeychainManager.shared.load(service: keychainServiceUserId, account: keychainAccountUserId) else {
            print("No user ID found in Keychain")
            return nil
        }
        return String(data: userIdData, encoding: .utf8)
    }

    // Load phone number from Keychain
    func loadPhoneNumber() -> String? {
        guard let phoneNumberData = KeychainManager.shared.load(service: keychainServicePhoneNumber, account: keychainAccountPhoneNumber) else {
            print("No phone number found in Keychain")
            return nil
        }
        return String(data: phoneNumberData, encoding: .utf8)
    }

    // Load username from Keychain
    func loadUsername() -> String? {
        guard let usernameData = KeychainManager.shared.load(service: keychainServiceUsername, account: keychainAccountUsername) else {
            print("No username found in Keychain")
            return nil
        }
        return String(data: usernameData, encoding: .utf8)
    }

    // Delete token from Keychain
    func deleteToken() {
        let isDeleted = KeychainManager.shared.delete(service: keychainServiceToken, account: keychainAccountToken)
        print(isDeleted ? "Token deleted successfully" : "Failed to delete token")
    }
    
    // Delete user ID from Keychain
    func deleteUserId() {
        let isDeleted = KeychainManager.shared.delete(service: keychainServiceUserId, account: keychainAccountUserId)
        print(isDeleted ? "User ID deleted successfully" : "Failed to delete user ID")
    }
    
    // Delete phone number from Keychain
    func deletePhoneNumber() {
        let isDeleted = KeychainManager.shared.delete(service: keychainServicePhoneNumber, account: keychainAccountPhoneNumber)
        print(isDeleted ? "Phone number deleted successfully" : "Failed to delete phone number")
    }

    // Delete username from Keychain
    func deleteUsername() {
        let isDeleted = KeychainManager.shared.delete(service: keychainServiceUsername, account: keychainAccountUsername)
        print(isDeleted ? "Username deleted successfully" : "Failed to delete username")
    }

    // Validate the token (this method could involve decoding a JWT, checking expiry, etc.)
    func validateToken() -> Bool {
        guard let token = loadToken() else {
            return false
        }
        // Here, add logic to validate the token (e.g., decoding JWT, checking expiry)
        // This example will assume the token is valid if it exists.
        return !token.isEmpty
    }
}


