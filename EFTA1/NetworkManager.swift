import Foundation
import Foundation
import UIKit

enum NetworkManagerError: Error {
    case unauthorized
}

class NetworkManager: ObservableObject {
    
    
    @Published var response: HTTPURLResponse?
    private let baseURL: String = Constants.baseURL
    static let shared = NetworkManager()  // Singleton instance


    func sendStaffDetails(staffNumber: String, phoneNumber: String, completion: @escaping (Bool, Error?) -> Void) {
        guard let url = URL(string: "\(baseURL)/SendStaffDetails") else {
            completion(false, NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"]))
            return
        }

        let body: [String: Any] = [
            "staffNumber": staffNumber,
            "phoneNumber": phoneNumber
        ]
        
        guard let jsonData = try? JSONSerialization.data(withJSONObject: body, options: []) else {
            completion(false, NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Error creating JSON"]))
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = jsonData
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(false, error)
                return
            }

            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                completion(false, NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid response or status code"]))
                return
            }

            completion(true, nil)
        }.resume()
    }
    
    func sendPinData(pinData: PinHandler, completion: @escaping (Bool, String?) -> Void) {
        guard let url = URL(string: "\(baseURL)/sendPinData") else {
            completion(false, nil)
            return
        }

        let body: [String: Any] = [
            "pinCode": pinData.pinCode,
            "selectedQuestion1": pinData.selectedQuestion1 ?? "",
            "selectedQuestion2": pinData.selectedQuestion2 ?? "",
            "selectedQuestion3": pinData.selectedQuestion3 ?? "",
            "answer1": pinData.answer1,
            "answer2": pinData.answer2,
            "answer3": pinData.answer3
        ]
        
        guard let jsonData = try? JSONSerialization.data(withJSONObject: body, options: []) else {
            completion(false, nil)
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = jsonData
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, let jsonResponse = try? JSONSerialization.jsonObject(with: data) as? [String: Any], let token = jsonResponse["token"] as? String else {
                completion(false, nil)
                return
            }

            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                completion(false, nil)
                return
            }

            completion(true, token)
        }.resume()
    }


    // Function to send verification request
    func sendVerificationRequest(verificationCodes: [String], completion: @escaping (Bool) -> Void) {
        // Encode the verification codes into JSON data
        guard let jsonData = try? JSONSerialization.data(withJSONObject: verificationCodes) else {
            completion(false) // Call the completion handler with false if encoding fails
            return
        }
        
        // Construct the full URL for the verification endpoint
        guard let url = URL(string: "\(baseURL)/verification") else {
            completion(false) // Call the completion handler with false if URL construction fails
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(false) // Call the completion handler with false if response is not an HTTPURLResponse
                return
            }
            
            DispatchQueue.main.async {
                self.response = httpResponse
                completion(httpResponse.statusCode == 200) // Call the completion handler with true if status code is 200, otherwise false
            }
        }.resume()
    }

    // Function to register a user
    func RegisterEndpoint( phoneNumber: String, staffNumber: String, pin: String, confirmPin: String, completion: @escaping (Bool) -> Void) {
        // Construct the full URL for the register endpoint
        guard let url = URL(string: "\(baseURL)/register") else {
            completion(false)
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let requestData: [String: Any] = [
            "phoneNumber": phoneNumber,
            "pin": pin,
            "confirmPin": confirmPin,
        ]
        
        guard let jsonData = try? JSONSerialization.data(withJSONObject: requestData) else {
            completion(false)
            return
        }
        
        request.httpBody = jsonData
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode == 200 {
                    completion(true)
                } else {
                    print("failed device verification")
                    completion(false)
                }
            } else {
                print("failed device verification")
                completion(false)
            }
        }
        
        task.resume()
    }
    
    // Function to handle user login
    func login(phoneNumber: String, password: String, completion: @escaping (Result<Void, Error>) -> Void) {
        guard let url = URL(string: "\(baseURL)/login") else {
            return completion(.failure(NSError(domain: "Invalid URL", code: -1, userInfo: nil)))
        }
        
        let parameters: [String: Any] = [
            "password": password,
            "phone_number": phoneNumber
        ]
        
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: parameters, options: [])
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = jsonData
            
            URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    completion(.failure(error))
                    return
                }
                
                guard let httpResponse = response as? HTTPURLResponse else {
                    completion(.failure(NSError(domain: "Invalid response", code: -1, userInfo: nil)))
                    return
                }
                
                switch httpResponse.statusCode {
                case 200...299:
                                if let data = data,
                                   let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                                   let token = json["token"] as? String {
                                    // Save token to UserDefaults
                                    print(token)
                                    UserDefaults.standard.set(token, forKey: "AuthToken")
                                    completion(.success(()))
                                } else {
                                    completion(.failure(NSError(domain: "Token not found in response", code: -1, userInfo: nil)))
                                }
                case 401:
                    completion(.failure(NetworkManagerError.unauthorized))
                default:
                    completion(.failure(NSError(domain: "Unknown error", code: httpResponse.statusCode, userInfo: nil)))
                }
            }.resume()
        } catch {
            completion(.failure(error))
        }
    }
    
    
    func loginWithPasscode(passcode: String, token: String? = nil, completion: @escaping (Result<Void, Error>) -> Void) {
        guard let url = URL(string: "\(baseURL)/loginWithPasscode") else {
            return completion(.failure(NSError(domain: "Invalid URL", code: -1, userInfo: nil)))
        }

        var parameters: [String: Any] = [
            "passcode": passcode
        ]
        
        // If a token is provided, include it in the request for session validation/refresh
        if let token = token {
            parameters["token"] = token
        }

        do {
            let jsonData = try JSONSerialization.data(withJSONObject: parameters, options: [])
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = jsonData
            
            URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    completion(.failure(error))
                    return
                }
                
                guard let httpResponse = response as? HTTPURLResponse else {
                    completion(.failure(NSError(domain: "Invalid response", code: -1, userInfo: nil)))
                    return
                }
                
                switch httpResponse.statusCode {
                case 200...299:
                    // Typically, you will receive a new token here
                    if let data = data,
                       let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                       let newToken = json["token"] as? String {
                        // Save the new token securely
                        let saved = KeychainManager.shared.save(newToken.data(using: .utf8)!, service: "com.yourapp.token", account: "userToken")
                        if saved {
                            completion(.success(()))
                        } else {
                            completion(.failure(NSError(domain: "Failed to save token", code: -1, userInfo: nil)))
                        }
                    } else {
                        completion(.failure(NSError(domain: "Token not found in response", code: -1, userInfo: nil)))
                    }
                case 401:
                    completion(.failure(NetworkManagerError.unauthorized))
                default:
                    completion(.failure(NSError(domain: "Unknown error", code: httpResponse.statusCode, userInfo: nil)))
                }
            }.resume()
        } catch {
            completion(.failure(error))
        }
    }

    
    
    func getTotal(completion: @escaping (Result<Data?, Error>) -> Void) {
            // Construct the full URL for the "total" endpoint
            guard let url = URL(string: "\(baseURL)/total") else {
                return completion(.failure(NSError(domain: "Invalid URL", code: -1, userInfo: nil)))
            }
            
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            
            URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    completion(.failure(error))
                    return
                }
                
                guard let httpResponse = response as? HTTPURLResponse else {
                    completion(.failure(NSError(domain: "Invalid response", code: -1, userInfo: nil)))
                    return
                }
                
                switch httpResponse.statusCode {
                case 200...299:
                    completion(.success(data))
                case 401:
                    completion(.failure(NetworkManagerError.unauthorized))
                default:
                    completion(.failure(NSError(domain: "Unknown error", code: httpResponse.statusCode, userInfo: nil)))
                }
            }.resume()
        }
    
    func updateProfile(name: String, emailAddress: String, username: String, selectedDate: Date, profileImage: UIImage?, completion: @escaping (Bool) -> Void) {
        // Convert UIImage to Data (JPEG format with compression quality 0.8)
        var imageData: Data? = nil
        if let profileImage = profileImage {
            imageData = profileImage.jpegData(compressionQuality: 0.8)
        }

        // Construct the full URL for the update profile endpoint
        guard let url = URL(string: "\(baseURL)/updateProfile") else {
            completion(false)
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        // Construct the request body with the profile data
        let profileData: [String: Any] = [
            "name": name,
            "emailAddress": emailAddress,
            "username": username,
            "selectedDate": selectedDate.timeIntervalSince1970, // Convert Date to Unix timestamp
            // Add any other profile data fields as needed
        ]

        if let imageData = imageData {
            let boundary = UUID().uuidString
            request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")

            request.httpBody = createFormDataBody(with: profileData, imageData: imageData, boundary: boundary)
        } else {
            request.httpBody = try? JSONSerialization.data(withJSONObject: profileData)
        }

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                completion(false)
                return
            }

            guard let httpResponse = response as? HTTPURLResponse else {
                completion(false)
                return
            }

            if httpResponse.statusCode == 200 {
                completion(true) // Profile updated successfully
            } else {
                completion(false) // Failed to update profile
            }
        }.resume()
    }

    private func createFormDataBody(with parameters: [String: Any], imageData: Data, boundary: String) -> Data {
        var body = Data()

        for (key, value) in parameters {
            if let stringValue = value as? String,
               let stringData = stringValue.data(using: .utf8) {
                body.append("--\(boundary)\r\n".data(using: .utf8)!)
                body.append("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n".data(using: .utf8)!)
                body.append(stringData)
                body.append("\r\n".data(using: .utf8)!)
            }
        }

        body.append("--\(boundary)\r\n".data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"profileImage\"; filename=\"image.jpeg\"\r\n".data(using: .utf8)!)
        body.append("Content-Type: image/jpeg\r\n\r\n".data(using: .utf8)!)
        body.append(imageData)
        body.append("\r\n".data(using: .utf8)!)

        body.append("--\(boundary)--\r\n".data(using: .utf8)!)

        return body
    }



    
}
