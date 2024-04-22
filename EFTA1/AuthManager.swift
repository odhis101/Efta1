import Foundation
import Combine

class AuthManager: ObservableObject {
    static let shared = AuthManager()
    
    private let keychainService = "com.yourapp.token"
    private let keychainAccount = "userToken"

    // Save token to Keychain
    func saveToken(_ token: String) {
        guard let data = token.data(using: .utf8) else {
            print("Failed to convert token to data")
            return
        }
        let isSaved = KeychainManager.shared.save(data, service: keychainService, account: keychainAccount)
        print(isSaved ? "Token saved successfully" : "Failed to save token")
    }
    
    // Load token from Keychain
    func loadToken() -> String? {
        guard let tokenData = KeychainManager.shared.load(service: keychainService, account: keychainAccount) else {
            print("No token found in Keychain")
            return nil
        }
        return String(data: tokenData, encoding: .utf8)
    }

    // Delete token from Keychain
    func deleteToken() {
        let isDeleted = KeychainManager.shared.delete(service: keychainService, account: keychainAccount)
        print(isDeleted ? "Token deleted successfully" : "Failed to delete token")
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
