import Foundation
import Foundation
import UIKit
import CoreLocation
enum NetworkManagerError: Error {
    case unauthorized
}

class NetworkManager: ObservableObject {
    
    
    @Published var response: HTTPURLResponse?
    private let baseURL: String = Constants.baseURL
    private let baseURLData: String = Constants.baseURLData

    @Published var documentURLs: [URL] = [] // Documents to be handled separately

    static let shared = NetworkManager()  // Singleton instance

    // account look up
    func sendStaffDetails(staffNumber: String, phoneNumber: String, completion: @escaping (Bool, Bool, Bool, Bool, Error?) -> Void) {
        // Prepare the request to check the staff account
        guard let url = URL(string: "\(baseURL)/auth/staffaccountlookup") else {
            // If the URL is invalid, call the completion handler with an error
            completion(false, false, false, false, NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"]))
            return
        }

        let body: [String: Any] = [
            "staffNumber": staffNumber,
        ]
        
        guard let jsonData = try? JSONSerialization.data(withJSONObject: body, options: []) else {
            // If there's an error creating JSON data, call the completion handler with an error
            completion(false, false, false, false, NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Error creating JSON"]))
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = jsonData
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        // Send the request to check the staff account
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                // If there's a networking error, call the completion handler with the error
                print("Network error: \(error.localizedDescription)")
                completion(false, false, false, false, error)
                return
            }

            guard let httpResponse = response as? HTTPURLResponse else {
                // If the response is not an HTTP response, call the completion handler with an error
                print("Invalid response: \(String(describing: response))")
                completion(false, false, false, false, NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid response"]))
                return
            }

            guard httpResponse.statusCode == 200 else {
                // If the response status code is not 200, call the completion handler with an error
                print("Invalid status code: \(httpResponse.statusCode)")
                completion(false, false, false, false, NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid status code \(httpResponse.statusCode)"]))
                return
            }

            // Parse the response data
            guard let responseData = data else {
                // If no data is received, call the completion handler with an error
                print("No data received")
                completion(false, false, false, false, NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No data received"]))
                return
            }
            
            do {
                // Print the entire response for debugging purposes
                if let responseString = String(data: responseData, encoding: .utf8) {
                    print("Response: \(responseString)")
                }
                
                let json = try JSONSerialization.jsonObject(with: responseData, options: []) as? [String: Any]
                
                // Change the condition for valid status to 0 or 200
                guard let status = json?["status"] as? Int, status == 0,
                      let data = json?["data"] as? [String: Any],
                      let retrievedPhoneNumber = data["phonenumber"] as? String else {
                    // If the response format is invalid or status is not as expected, log the details
                    print("Unexpected response format or status:")
                    if let status = json?["status"] as? Int {
                        print("Status: \(status) (expected: 0)")
                    } else {
                        print("Status not found or invalid")
                    }
                    if let data = json?["data"] as? [String: Any] {
                        if let retrievedPhoneNumber = data["phonenumber"] as? String {
                            print("Retrieved Phone Number: \(retrievedPhoneNumber)")
                        } else {
                            print("Phone number not found or invalid")
                        }
                    } else {
                        print("Data not found or invalid")
                    }
                    completion(false, false, false, false, NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid response format or status"]))
                    return
                }
                
                // Extract the last 9 digits of the retrieved phone number
                let last9Digits = String(retrievedPhoneNumber.suffix(9))
                
                // Extract the last 9 digits of the provided phone number
                let providedLast9Digits = String(phoneNumber.suffix(9))
                
                // Log the expected vs. the retrieved phone number for debugging
                print("Expected last 9 digits: \(providedLast9Digits)")
                print("Retrieved last 9 digits: \(last9Digits)")
                
                // Extract additional fields
                let isPastAccLookUp = data["isPastAccLookUp"] as? Bool ?? false
                let hasSetPin = data["hasSetPin"] as? Bool ?? false
                let hasSetSecurityQuestions = data["hasSetSecurityQuestions"] as? Bool ?? false
                AuthManager.shared.savePhoneNumber(retrievedPhoneNumber)

                
                // Check if the last 9 digits of the retrieved phone number match the provided phone number
                if last9Digits == providedLast9Digits {
                    // If the phone numbers match, call the completion handler with success
                    completion(true, isPastAccLookUp, hasSetPin, hasSetSecurityQuestions, nil)
                } else {
                    // If the phone numbers do not match, log the mismatch and call the completion handler with an error
                    print("Phone number mismatch: Expected \(providedLast9Digits), got \(last9Digits)")
                    completion(false, false, false, false, NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid phone number"]))
                }
            } catch {
                // If there's an error parsing the response data, log the error and call the completion handler with the error
                print("JSON parsing error: \(error.localizedDescription)")
                completion(false, false, false, false, error)
            }
        }.resume()
    }

    func sendVerificationRequest(phoneNumber: String, otp: String, completion: @escaping (Bool) -> Void) {
        // Prepare the request to send the verification request
        guard let url = URL(string: "\(baseURL)/auth/validateotp") else {
            print("Error: Failed to construct URL with base URL \(baseURL) and endpoint /auth/validateotp")
            completion(false) // Call the completion handler with false if URL construction fails
            return
        }
        
        // Construct the request body
        let body: [String: Any] = [
            "phonenumber": phoneNumber,
            "otp": otp
        ]
        
        // Print the request body for debugging purposes
        print("Request Body: \(body)")
        
        guard let jsonData = try? JSONSerialization.data(withJSONObject: body) else {
            print("Error: Failed to encode request body into JSON")
            completion(false) // Call the completion handler with false if encoding fails
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData
        
        // Print the constructed URLRequest for debugging purposes
        print("Constructed URLRequest: \(request)")
        
        // Send the verification request
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error: Network request failed with error: \(error.localizedDescription)")
                completion(false) // Call the completion handler with false if there's an error
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                print("Error: Received invalid response (not an HTTPURLResponse)")
                completion(false) // Call the completion handler with false if response is not an HTTPURLResponse
                return
            }
            
            // Log the HTTP status code for debugging purposes
            print("HTTP Status Code: \(httpResponse.statusCode)")
            
            // Check if we received data in the response
            guard let responseData = data else {
                print("Error: No response data received")
                completion(false)
                return
            }
            
            do {
                // Print the entire response for debugging purposes
                if let responseString = String(data: responseData, encoding: .utf8) {
                    print("Response Data: \(responseString)")
                }
                
                // Parse the JSON response
                if let json = try JSONSerialization.jsonObject(with: responseData, options: []) as? [String: Any] {
                    // Log the entire parsed JSON for debugging
                    print("Parsed JSON: \(json)")
                    
                    // Extract and log the status and message
                    let status = json["status"] as? String ?? "No status"
                    let message = json["message"] as? String ?? "No message"
                    print("Status: \(status)")
                    print("Message: \(message)")
                    
                    // Extract and log the data if available
                    let data = json["data"] as? [String: Any] ?? [:]
                    print("Data: \(data)")
                    
                    // Determine success based on status
                    let success = status == "00"
                    if success {
                        print("Success: Verification request succeeded with status '00'")
                    } else {
                        print("Failure: Verification request failed with status '\(status)' and message '\(message)'")
                    }
                    completion(success)
                } else {
                    print("Error: Failed to parse response JSON")
                    completion(false)
                }
            } catch {
                print("Error: JSON parsing failed with error: \(error.localizedDescription)")
                completion(false)
            }
        }.resume()
    }

    func setNewPin(pin: String, phoneNumber: String, completion: @escaping (Bool, Error?) -> Void) {
        // Prepare the request to set a new pin
        guard let url = URL(string: "\(baseURL)/auth/setnewpin") else {
            completion(false, NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"]))
            return
        }
        
        // Construct the request body
        let body: [String: Any] = [
            "pin": pin,
            "phonenumber": phoneNumber
        ]
        
        guard let jsonData = try? JSONSerialization.data(withJSONObject: body) else {
            completion(false, NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Error creating JSON"]))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData
        
        // Send the request to set a new pin
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(false, error)
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                completion(false, NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid response or status code"]))
                return
            }
            
            guard let responseData = data else {
                completion(false, NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No data received"]))
                return
            }
            
            do {
                if let responseString = String(data: responseData, encoding: .utf8) {
                    print("Response: \(responseString)")
                }
                
                let json = try JSONSerialization.jsonObject(with: responseData, options: []) as? [String: Any]
                guard let status = json?["status"] as? String, status == "00" else {
                    completion(false, NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "PIN Set Failed"]))
                    return
                }
                
                completion(true, nil)
            } catch {
                completion(false, error)
            }
        }.resume()
    }

    func getSecurityQuestions(completion: @escaping ([String]?, Error?) -> Void) {
        guard let url = URL(string: "\(baseURL)/auth/getsecurityquestions") else {
            completion(nil, NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"]))
            return
        }

        // Log the request URL
        print("Request URL:", url)

        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                // Log the error
                print("Error:", error)
                completion(nil, error)
                return
            }

            // Log the response status code
            if let httpResponse = response as? HTTPURLResponse {
                print("Response Status Code:", httpResponse.statusCode)
            }

            guard let responseData = data else {
                completion(nil, NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No data received"]))
                return
            }

            // Log the response body
            if let responseBody = String(data: responseData, encoding: .utf8) {
                print("Response Body:", responseBody)
            }

            do {
                let json = try JSONSerialization.jsonObject(with: responseData, options: []) as? [String: Any]
                guard let status = json?["status"] as? String, status == "00",
                      let data = json?["data"] as? [String: Any],
                      let securityQuestions = data["securityquestions"] as? [[String: String]] else {
                    completion(nil, NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid response format or status"]))
                    return
                }

                // Extract the English security questions
                let englishQuestions = securityQuestions.compactMap { $0["english"] }

                completion(englishQuestions, nil)
            } catch {
                // Log the JSON parsing error
                print("JSON Parsing Error:", error)
                completion(nil, error)
            }
        }.resume()
    }
    func formatPhoneNumber(_ phoneNumber: String) -> String {
        if phoneNumber.hasPrefix("07") {
            // Replace the "07" prefix with "+2547"
            let formattedNumber = "+254" + phoneNumber.dropFirst(1)
            return formattedNumber
        }
        return phoneNumber
    }

    func submitSecurityQuestions(answers: [(answer: String, question: String)], phoneNumber: String, completion: @escaping (Bool, Error?) -> Void) {
        // Prepare the URL
        guard let url = URL(string: "\(baseURL)/auth/securityquestions") else {
            print("Error: Failed to construct URL with base URL \(baseURL) and endpoint /auth/securityquestions")
            completion(false, NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"]))
            return
        }
        
        
        // Deconstruct the array of answers
        let answer1 = answers.count > 0 ? answers[0].answer : ""
        let answer2 = answers.count > 1 ? answers[1].answer : ""
        let answer3 = answers.count > 2 ? answers[2].answer : ""
        let question1 = answers.count > 0 ? answers[0].question : ""
        let question2 = answers.count > 1 ? answers[1].question : ""
        let question3 = answers.count > 2 ? answers[2].question : ""
        
        let formattedPhoneNumber = formatPhoneNumber(phoneNumber)

        
        // Construct the request body
        let requestBody: [String: Any] = [
            "answers": [
                ["answer": answer1, "question": question1],
                ["answer": answer2, "question": question2],
                ["answer": answer3, "question": question3]
            ],
            "phonenumber": formattedPhoneNumber
        ]
        
        // Convert request body to JSON
        guard let jsonData = try? JSONSerialization.data(withJSONObject: requestBody) else {
            print("Error: Failed to encode request body into JSON")
            completion(false, NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Error creating JSON"]))
            return
        }
        
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData
        
        // Print the request body for debugging purposes
        if let jsonString = String(data: jsonData, encoding: .utf8) {
            print("Request Body: \(jsonString)")
        } else {
            print("Error: Failed to convert JSON data to string")
        }
        
        // Send the request
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error: Network request failed with error: \(error.localizedDescription)")
                completion(false, error)
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                print("Error: Received invalid response (not an HTTPURLResponse)")
                completion(false, NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid response"]))
                return
            }
            
            // Log the HTTP status code
            print("HTTP Status Code: \(httpResponse.statusCode)")
            
            // Print the response data for debugging purposes
            if let responseData = data {
                if let responseString = String(data: responseData, encoding: .utf8) {
                    print("Response Body: \(responseString)")
                } else {
                    print("Error: Failed to decode response data as UTF-8 string")
                }
            } else {
                print("Error: No response data received")
            }
            
            // Check for a 200 status code
            guard httpResponse.statusCode == 200 else {
                print("Error: Invalid response or status code: \(httpResponse.statusCode)")
                completion(false, NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid response or status code"]))
                return
            }
            
            // Process the response data
            if let responseData = data {
                do {
                    if let responseObject = try JSONSerialization.jsonObject(with: responseData, options: []) as? [String: Any] {
                        // Log the parsed JSON response
                        print("Parsed JSON: \(responseObject)")
                        
                        // Extract and log the status and message
                        let status = responseObject["status"] as? String ?? "No status"
                        let message = responseObject["message"] as? String ?? "No message"
                        print("Status: \(status)")
                        print("Message: \(message)")
                        
                        // Check for successful status
                        if status == "00" {
                            print("Success: Security questions submitted successfully")
                            completion(true, nil)
                        } else {
                            print("Failure: Security questions submission failed with status '\(status)' and message '\(message)'")
                            completion(false, NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to submit security questions"]))
                        }
                    } else {
                        print("Error: Failed to parse response JSON")
                        completion(false, NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid JSON response"]))
                    }
                } catch {
                    print("Error: JSON parsing failed with error: \(error.localizedDescription)")
                    completion(false, error)
                }
            } else {
                print("Error: No data received")
                completion(false, NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No data received"]))
            }
        }.resume()
    }

    func mobileAppLogin(phoneNumber: String, pin: String, completion: @escaping (Bool, String, Int?) -> Void) {
        guard let url = URL(string: "\(baseURL)/auth/mobileapplogin") else {
            print("Invalid URL")
            completion(false, "Invalid URL", nil)
            return
        }
        
        let formattedPhoneNumber = formatPhoneNumber(phoneNumber)
        let requestBody: [String: Any] = [
            "phonenumber": formattedPhoneNumber,
            "pin": pin
        ]

        guard let jsonData = try? JSONSerialization.data(withJSONObject: requestBody) else {
            print("Error creating JSON")
            completion(false, "Error creating JSON", nil)
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                completion(false, "Error: \(error.localizedDescription)", nil)
                return
            }

            guard let httpResponse = response as? HTTPURLResponse, let data = data else {
                print("Invalid response")
                completion(false, "Invalid response", nil)
                return
            }

            print("Response status code: \(httpResponse.statusCode)")
            if let responseBody = String(data: data, encoding: .utf8) {
                print("Response body: \(responseBody)")
            }

            do {
                let responseObject = try JSONDecoder().decode(LoginResponse.self, from: data)
                if responseObject.status == "00" {
                    // Successful login
                    if let loginData = responseObject.data {
                        // Save the token and user ID
                        AuthManager.shared.saveToken(loginData.token)
                        AuthManager.shared.saveUserId(loginData.userId)
                        AuthManager.shared.savePhoneNumber(formattedPhoneNumber)
                        AuthManager.shared.saveUsername(loginData.username)

                        
                    }
                    completion(true, responseObject.message, nil)
                } else {
                    // Failed login
                    let remainingAttempts = responseObject.remainingAttempts
                    completion(false, responseObject.message, remainingAttempts)
                }
            } catch {
                // Error decoding response
                print("Error decoding response: \(error.localizedDescription)")
                completion(false, "Error decoding response", nil)
            }
        }.resume()
    }

    struct LoginResponse: Codable {
        let status: String
        let message: String
        let data: LoginData?
        let remainingAttempts: Int? // Include remainingAttempts here
        
        struct LoginData: Codable {
            let token: String
            let userId: String
            let username: String

        }
    }

    // send customer onboarding
    
    private func appendToData(_ data: inout Data, string: String) {
           if let stringData = string.data(using: .utf8) {
               data.append(stringData)
           }
       }
    
    
    
    func fetchDocumentTypes(staffUserId: String, completion: @escaping (Result<[DocumentType], Error>) -> Void) {
            
        print("we are in fetch documents ")
        guard let url = URL(string: "\(baseURLData)/Mobile/getdoctypes") else {
            completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let parameters = ["StaffUserId": staffUserId]
        
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: parameters, options: [])
            request.httpBody = jsonData
            
            // Log the request details
            print("Request URL: \(url)")
            print("Request Headers: \(request.allHTTPHeaderFields ?? [:])")
            print("Request Body: \(String(data: jsonData, encoding: .utf8) ?? "")")
            
        } catch {
            completion(.failure(error))
            return
        }
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid HTTP response"])))
                return
            }
            
            print("Response Status Code: \(httpResponse.statusCode)")
            
            guard let data = data else {
                completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No data received"])))
                return
            }
            
            // Log the raw response data
            if let responseString = String(data: data, encoding: .utf8) {
                print("Response Data: \(responseString)")
            }
            
            do {
                let decoder = JSONDecoder()
                let response = try decoder.decode(DocumentTypesResponse.self, from: data)
                if response.status == "00" {
                    completion(.success(response.data))
                } else {
                    completion(.failure(NSError(domain: "", code: httpResponse.statusCode, userInfo: [NSLocalizedDescriptionKey: response.message])))
                }
            } catch {
                completion(.failure(error))
            }
        }
        task.resume()
    }


    func uploadData(onboardingData: OnboardingData, completion: @escaping (Bool, String) -> Void) {
        print("Starting data upload...")
        
        let url = URL(string: "\(baseURLData)/Mobile/individualcustomer")!
        print("Request URL: \(url)")
        
        let boundary = "Boundary-\(UUID().uuidString)"
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        var StaffUserId = ""
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        if let staffuserId = AuthManager.shared.loadUserId() {
            StaffUserId = staffuserId
        } else {
            print("No phone number found in Keychain")
        }
        
        let parameters: [String: Any] = [
            "CustomerType": onboardingData.customerType ?? "",
            "CustomerName": onboardingData.customerName,
            "IdType": onboardingData.idType ?? "",
            "IdNumber": onboardingData.idNumber,
            "PassportNumber": onboardingData.passportNumber ?? "",
            "Gender": onboardingData.gender ?? "",
            "MaritalStatus": onboardingData.maritalStatus ?? "",
            "PostalAddress": onboardingData.postalAddress,
            "Region": onboardingData.region ?? "",
            "District": onboardingData.district ?? "",
            "Ward": onboardingData.ward,
            "Nationality": onboardingData.nationality ?? "",
            "EmailAddress": onboardingData.emailAddress,
            "PhoneNumber": onboardingData.phoneNumber,
            "TIN": onboardingData.tin ?? "",
            "TypeOfEquipment": onboardingData.typeOfEquipment,
            "PriceOfEquipment": onboardingData.priceOfEquipment,
            "CustomerLocation.Latitude": onboardingData.selectedCoordinate?.latitude ?? 0.0,
            "CustomerLocation.Longitude": onboardingData.selectedCoordinate?.longitude ?? 0.0,
            "StaffUserId": StaffUserId
        ]
        
        print("These are the parameters", parameters)
        
        var files: [(data: Data, fieldName: String, fileName: String, mimeType: String)] = []
        
        if let profileImage = onboardingData.profileImage,
           let imageData = profileImage.jpegData(compressionQuality: 0.8) {
            files.append((data: imageData, fieldName: "CustomerPhoto", fileName: "profile.jpg", mimeType: "image/jpeg"))
        }
        
        for (idType, urls) in onboardingData.documentURLs {
            for documentURL in urls {
                do {
                    let documentData = try Data(contentsOf: documentURL)
                    let fileName = documentURL.lastPathComponent
                    files.append((data: documentData, fieldName: idType, fileName: fileName, mimeType: "application/octet-stream"))
                } catch {
                    print("Error loading document data:", error)
                    // Handle the error or skip the document if loading fails
                }
            }
        }
        
        let body = createMultipartFormData(boundary: boundary, parameters: parameters, files: files)
        request.httpBody = body
        
        // Log request details
        logRequest(request)
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error uploading data: \(error)")
                completion(false, "Error uploading data: \(error.localizedDescription)")
                return
            }
            guard let data = data, let response = response as? HTTPURLResponse else {
                print("No data or invalid response")
                completion(false, "Server error")
                return
            }
            
            print("Response status code: \(response.statusCode)")
            
            if response.statusCode == 200 {
                do {
                    let responseDict = try JSONDecoder().decode(UploadResponse.self, from: data)
                    if responseDict.status == "00" {
                        completion(true, responseDict.message)
                        // Log the response body
                        if let responseBody = String(data: data, encoding: .utf8) {
                            print("Response body: \(responseBody)")
                        }
                    } else {
                        completion(false, responseDict.message)
                    }
                } catch {
                    if let responseBody = String(data: data, encoding: .utf8) {
                        print("Response body: \(responseBody)")
                    }
                    print("Error decoding response: \(error)")
                    completion(false, "Error decoding response")
                }
            } else {
                if let responseBody = String(data: data, encoding: .utf8) {
                    print("Response body: \(responseBody)")
                }
                completion(false, "Server error: \(response.statusCode)")
            }
        }

        task.resume()
    }

    private func createMultipartFormData(boundary: String, parameters: [String: Any], files: [(data: Data, fieldName: String, fileName: String, mimeType: String)]) -> Data {
        var body = Data()
        
        for (key, value) in parameters {
            body.append("--\(boundary)\r\n".data(using: .utf8)!)
            body.append("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n".data(using: .utf8)!)
            body.append("\(value)\r\n".data(using: .utf8)!)
        }
        
        for file in files {
            body.append("--\(boundary)\r\n".data(using: .utf8)!)
            body.append("Content-Disposition: form-data; name=\"\(file.fieldName)\"; filename=\"\(file.fileName)\"\r\n".data(using: .utf8)!)
            body.append("Content-Type: \(file.mimeType)\r\n\r\n".data(using: .utf8)!)
            body.append(file.data)
            body.append("\r\n".data(using: .utf8)!)
        }
        
        body.append("--\(boundary)--\r\n".data(using: .utf8)!)
        return body
    }

    private func logRequest(_ request: URLRequest) {
        print("Request method: \(request.httpMethod ?? "N/A")")
        print("Request headers: \(request.allHTTPHeaderFields ?? [:])")
        if let body = request.httpBody, let bodyString = String(data: body, encoding: .utf8) {
            print("Request body: \(bodyString)")
        }
    }

  
    
    struct UploadResponse: Codable {
        let status: String
        let message: String
        let data: ResponseData?
        
        enum ResponseData: Codable {
            case dictionary([String: String])
            case string(String)
            
            init(from decoder: Decoder) throws {
                let container = try decoder.singleValueContainer()
                if let dictionary = try? container.decode([String: String].self) {
                    self = .dictionary(dictionary)
                } else if let string = try? container.decode(String.self) {
                    self = .string(string)
                } else {
                    throw DecodingError.typeMismatch(ResponseData.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Expected dictionary or string"))
                }
            }
            
            func encode(to encoder: Encoder) throws {
                var container = encoder.singleValueContainer()
                switch self {
                case .dictionary(let dictionary):
                    try container.encode(dictionary)
                case .string(let string):
                    try container.encode(string)
                }
            }
        }
    }

    
    func uploadCompanyOnboardingData(onboardingData: OnboardingData, companyData: CompanyOnboardingData, completion: @escaping (Bool, String) -> Void) {
        print("Starting company data upload...")
        
        let url = URL(string: "\(baseURLData)/Mobile/companyonboarding")!
        print("Request URL: \(url)")
        
        let boundary = "Boundary-\(UUID().uuidString)"
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        var staffUserId = ""
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        if let staffUserIdFromAuth = AuthManager.shared.loadUserId() {
            staffUserId = staffUserIdFromAuth
        } else {
            print("No user ID found in Keychain")
        }
        
        let formattedCompanyType = onboardingData.titleForCustomerOnboarding.replacingOccurrences(of: " ", with: "")
        
        let parameters: [String: Any] = [
            "CompanyType": formattedCompanyType,
            "CompanyName": companyData.companyName,
            "VRN": companyData.VRN,
            "ContactPersonName": companyData.contactPersonName,
            "ContactPersonIdType": companyData.idType ?? "",
            "ContactPersonIdNumber": companyData.idNumber,
            "ContactPersonPassportNumber": companyData.passportNumber ?? "",
            "StaffUserId": staffUserId,
            "TIN": companyData.TIN,
            "PostalAddress": companyData.postalAddress,
            "Region": companyData.region ?? "",
            "District": companyData.district ?? "",
            "Ward": companyData.ward,
            "Nationality": companyData.nationality ?? "",
            "EmailAddress": companyData.emailAddress,
            "PhoneNumber": companyData.phoneNumber,
            "TypeOfEquipment": companyData.typeOfEquipment,
            "PriceOfEquipment": companyData.priceOfEquipment,
            "CustomerLocation.Latitude": companyData.selectedCoordinate?.latitude ?? 0.0,
            "CustomerLocation.Longitude": companyData.selectedCoordinate?.longitude ?? 0.0
        ]
        
        print("These are the parameters", parameters)
        
        var files: [(data: Data, fieldName: String, fileName: String, mimeType: String)] = []
        
        for (idType, urls) in companyData.documentURLs {
            for documentURL in urls {
                if let documentData = try? Data(contentsOf: documentURL) {
                    let fileName = documentURL.lastPathComponent
                    let fieldName = idType  // Use the ID type associated with the document
                    print("This is the field name", fieldName)
                    files.append((data: documentData, fieldName: fieldName, fileName: fileName, mimeType: "application/octet-stream"))
                }
            }
        }
        
        let body = createMultipartFormData(boundary: boundary, parameters: parameters, files: files)
        request.httpBody = body
        
        // Log request details
        logRequest(request)
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error uploading data: \(error)")
                completion(false, "Error uploading data: \(error.localizedDescription)")
                return
            }
            guard let data = data, let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                if let httpResponse = response as? HTTPURLResponse {
                    print("Server error: \(httpResponse.statusCode)")
                    if let responseData = data, let responseBody = String(data: responseData, encoding: .utf8) {
                        print("Response body: \(responseBody)")
                    }
                } else {
                    print("Server error")
                }
                completion(false, "Server error")
                return
            }
            
            print("Response status code: \(response.statusCode)")
            print("Response body:")
            if let responseBody = String(data: data, encoding: .utf8) {
                print(responseBody)
                completion(true, "Submission successful!")
            } else {
                print("Unable to convert response data to string")
                completion(true, "Submission successful!")
            }
        }
        task.resume()
    }

    
    func appraiseCustomer(bearer: String, siteDetails: SiteDetailsDataHandler, completion: @escaping (Bool, String) -> Void) {
            print("Starting customer appraisal upload...")
            
            let url = URL(string: "\(baseURLData)/Mobile/appraiseCustomer")!
            print("Request URL: \(url)")
        var staffUserId = ""

     
            let boundary = "Boundary-\(UUID().uuidString)"
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("Bearer \(bearer)", forHTTPHeaderField: "Authorization")
            request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        if let staffUserIdFromAuth = AuthManager.shared.loadUserId() {
            staffUserId = staffUserIdFromAuth
        } else {
            print("No user ID found in Keychain")
        }
            
            let parameters: [String: Any] = [
                "customerPhoneNumber": siteDetails.isLandOwnershipConfirmed,  // Example value, replace with actual
                "isLandOwnershipConfirmed": siteDetails.isLandOwnershipConfirmed ? "true" : "false",
                "landRentingDetails": siteDetails.landRentingDetails,
                "experienceInMachinery": siteDetails.experienceInMachinery,
                "areCustomersOnSite": siteDetails.areCustomersOnSite ? "true" : "false",
                "areProductionProcessesDiscussed": siteDetails.areProductionProcessesDiscussed ? "true" : "false",
                "areTypicalCustomersDiscussed": siteDetails.areTypicalCustomersDiscussed ? "true" : "false",
                "areTopThreeCustomersIdentified": siteDetails.areTopThreeCustomersIdentified ? "true" : "false",
                "areKeyCompetitorsConfirmed": siteDetails.areKeyCompetitorsConfirmed ? "true" : "false",
                "isDifferentiationStrategyDiscussed": siteDetails.isDifferentiationStrategyDiscussed ? "true" : "false",
                "areCreditTermsConfirmed": siteDetails.areCreditTermsConfirmed ? "true" : "false",
                "didYouUnderstandProductSalesTime": siteDetails.didYouUnderstandProductSalesTime ? "true" : "false",
                "hasCheckedRelianceOnGovernmentCustomers": siteDetails.isApplicantReliantOnGovernmentCustomers ? "true" : "false",
                "hasCheckedIfApplicantSellingProductsAtOnce": siteDetails.isApplicantSellingProductsAtOnce ? "true" : "false",
                "hasCheckedIfSeasonalityImpactingBusiness": siteDetails.isSeasonalityImpactingBusiness ? "true" : "false",
                "areForecastedVolumesMakingSense": siteDetails.areForecastedVolumesMakingSense ? "true" : "false",
                "isDifferentProductsProductionDiscussed": siteDetails.isDifferentProductsProductionDiscussed ? "true" : "false",
                "areAdditionalServicesConsidered": siteDetails.areAdditionalServicesConsidered ? "true" : "false",
                "areSuppliersAndReferencesPhoneNumbersCollected": siteDetails.arePhoneNumbersAndReferencesCollected ? "true" : "false",
                "isCreditDisputeDiscussed": siteDetails.isCreditDisputeDiscussed ? "true" : "false",
                "isCreditInfoSearchConducted": siteDetails.isCreditInfoSearchConducted ? "true" : "false",
                "arePastLoansAndTheirMonthlyPaymentDiscussed": siteDetails.isDownpaymentDiscussed ? "true" : "false",
                "areNeighborsConsulted": siteDetails.areNeighborsConsulted ? "true" : "false",
                "isCustomersTopThreeChallengesDiscussed": siteDetails.topThreeChallenges ? "true" : "false",
                "isAppropriateDownpaymentAndProductDiscussed": siteDetails.downPaymentDiscussion ? "true" : "false",
                "isDownPaymentPlanDiscussed": siteDetails.downPaymentPaymentPlan ? "true" : "false",
                "hasCheckedPreviousDebtorsAndOutstandingLoan": siteDetails.applicantsDebtors ? "true" : "false",
                "areEmployeesConsultedAboutSizeOfBusiness": siteDetails.areEmployeesConsulted ? "true" : "false",
                "areSchedulesCompleted": siteDetails.areSchedulesCompleted ? "true" : "false",
                "arePricesConsistentWithInfoProvided": siteDetails.arePricesConsistent ? "true" : "false",
                "areWagesOfEmployeesDiscussed": siteDetails.areWagesDiscussed ? "true" : "false",
                "isESGQuestionnaireCompleted": siteDetails.isESGQuestionnaireCompleted ? "true" : "false",
                "arePreRequisitesNoted": siteDetails.arePreRequisitesNoted ? "true" : "false",
                "numberOfPermanentMaleEmployees": siteDetails.numberOfPermanentMaleEmployees,
                "numberOfPermanentFemaleEmployees": siteDetails.numberOfPermanentFemaleEmployees,
                "numberOfCasualMaleEmployees": siteDetails.numberOfCasualMaleEmployees,
                "numberOfCasualFemaleEmployees": siteDetails.numberOfCasualFemaleEmployees,
                "daysEmployedPerMonthByCasuals": siteDetails.daysEmployedPerMonthByCasuals,
                "hasHealthBenefitsForPermanentEmployees": siteDetails.hasHealthBenefitsForPermanentEmployees ? "true" : "false",
                "monthlyWages": siteDetails.monthlyWages,
                "dailyWages": siteDetails.dailyWages,
                "revenuesLastMonth": siteDetails.revenuesLastMonth,
                "revenuesThisMonth": siteDetails.revenuesThisMonth,
                "revenuesNextMonth": siteDetails.revenuesNextMonth,
                "StaffUserId": staffUserId,

            ]
            
            print("These are the parameters", parameters)
            
            var files: [(data: Data, fieldName: String, fileName: String, mimeType: String)] = []
            
            let imageFields: [(String, UIImage?)] = [
                ("fullDescriptionOfSite", siteDetails.fullDescriptionOfSite),
                ("deliveryChallenges", siteDetails.deliveryChallenges),
                ("securityArrangements", siteDetails.securityArrangements),
                ("electricalFacilities", siteDetails.electricalFacilities),
                ("waterAndOtherFacilities", siteDetails.waterAndOtherFacilities),
                ("siteChangesRequired", siteDetails.siteChangesRequired),
                ("missingCertificates", siteDetails.missingCertificates),
                ("assetsInGoodStanding", siteDetails.assetsInGoodStanding),
                ("stockLevelsAligned", siteDetails.stockLevelsAligned),
                ("orderBooksAndPayments", siteDetails.orderBooksAndPayments),
                ("proofIncomeSourcesVerified", siteDetails.otherIncomeSourcesProof),
                ("relevantPhotographicEvidence", siteDetails.isPhotographicEvidenceTaken),
                ("customerSignature", siteDetails.customerSignature),
                ("customerSignaturePhoto", siteDetails.captureSignatureImage)
            ]
            
            for (fieldName, image) in imageFields {
                if let image = image, let imageData = image.jpegData(compressionQuality: 0.7) {
                    files.append((data: imageData, fieldName: fieldName, fileName: "\(fieldName).jpg", mimeType: "image/jpeg"))
                }
            }
            
            let body = createMultipartFormData(boundary: boundary, parameters: parameters, files: files)
            request.httpBody = body
            
            // Log request details
            logRequest(request)
            
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    print("Error uploading data: \(error)")
                    completion(false, "Error uploading data: \(error.localizedDescription)")
                    return
                }
                guard let data = data, let response = response as? HTTPURLResponse else {
                    if let httpResponse = response as? HTTPURLResponse {
                        print("Server error: \(httpResponse.statusCode)")
                        if let responseData = data, let responseBody = String(data: responseData, encoding: .utf8) {
                            print("Response body: \(responseBody)")
                        }
                    } else {
                        print("Server error")
                    }
                    completion(false, "Server error")
                    return
                }
                
                print("Response status code: \(response.statusCode)")
                print("Response body:")
                if let responseBody = String(data: data, encoding: .utf8) {
                    print(responseBody)
                    completion(true, "Submission successful!")
                } else {
                    print("Unable to convert response data to string")
                    completion(true, "Submission successful!")
                }
            }
            task.resume()
        }
    
    

    struct CustomerListResponse: Decodable {
        let status: String
        let message: String
        let data: [CustomerData]?
    }

    func fetchCustomerList(completion: @escaping (Result<[CustomerData], Error>) -> Void) {
        let urlString = "\(baseURLData)/Mobile/customerlist"
        guard let url = URL(string: urlString) else {
            print("Invalid URL: \(urlString)")
            completion(.failure(NSError(domain: "Invalid URL", code: 0, userInfo: nil)))
            return
        }
        
        print("Request URL: \(urlString)")
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        var staffUserId = ""
        if let staffUserIdFromAuth = AuthManager.shared.loadUserId() {
            staffUserId = staffUserIdFromAuth
        } else {
            print("No user ID found in Keychain")
            completion(.failure(NSError(domain: "No User ID", code: 0, userInfo: nil)))
            return
        }
        
        print("Staff User ID: \(staffUserId)")
        let requestData: [String: String] = ["userId": staffUserId]
        guard let jsonData = try? JSONSerialization.data(withJSONObject: requestData) else {
            print("Failed to serialize JSON: \(requestData)")
            completion(.failure(NSError(domain: "JSON Serialization Error", code: 0, userInfo: nil)))
            return
        }
        
        request.httpBody = jsonData
        print("Request Body: \(String(data: jsonData, encoding: .utf8) ?? "nil")")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Network error: \(error.localizedDescription)")
                completion(.failure(error))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                print("Invalid response received")
                completion(.failure(NSError(domain: "Invalid Response", code: 0, userInfo: nil)))
                return
            }
            
            print("Response Status Code: \(httpResponse.statusCode)")
            guard httpResponse.statusCode == 200 else {
                print("Server error: Status code \(httpResponse.statusCode)")
                completion(.failure(NSError(domain: "Server Error", code: httpResponse.statusCode, userInfo: nil)))
                return
            }
            
            guard let data = data else {
                print("No data received from server")
                completion(.failure(NSError(domain: "No Data", code: 0, userInfo: nil)))
                return
            }
            
            if let jsonString = String(data: data, encoding: .utf8) {
                print("Response Data: \(jsonString)")
            } else {
                print("Unable to convert response data to string")
            }
            
            do {
                let response = try JSONDecoder().decode(CustomerListResponse.self, from: data)
                if response.status == "00", let customers = response.data {
                    print("Successfully decoded customer data")
                    completion(.success(customers))
                } else {
                    print("Response error: \(response.status)")
                    completion(.failure(NSError(domain: "Response Error", code: 0, userInfo: nil)))
                }
            } catch {
                print("Decoding error: \(error)")
                completion(.failure(error))
            }
        }.resume()
    }
    // Function to send a POST request to the specified endpoint
    func scheduleAppraisal(customerId: String, scheduledDate: String, completion: @escaping (Result<Data, Error>) -> Void) {
        // Define the URL
        let url = URL(string: "\(baseURLData)/Mobile/scheduleappraisal")!
        print("Request URL: \(url)")
        
        var staffUserId = ""
        if let staffUserIdFromAuth = AuthManager.shared.loadUserId() {
            staffUserId = staffUserIdFromAuth
        } else {
            print("No user ID found in Keychain")
            completion(.failure(NSError(domain: "No User ID", code: 0, userInfo: nil)))
            return
        }
        
        // Define the request body
        let requestBody: [String: Any] = [
            "staffUserId": staffUserId,
            "customerId": customerId,
            "scheduledDate": scheduledDate
        ]
        
        // Convert request body to JSON data
        guard let jsonData = try? JSONSerialization.data(withJSONObject: requestBody) else {
            completion(.failure(NetworkError.invalidData))
            return
        }
        
        // Create the request
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData
        
        // Create and start data task
        URLSession.shared.dataTask(with: request) { data, response, error in
            // Check for network errors
            if let error = error {
                completion(.failure(error))
                return
            }
            
            // Check for HTTP response status code
            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                completion(.failure(NetworkError.invalidResponse))
                print("Response body: \(response)")

                return
            }
            
            // Check if data is available
            guard let responseData = data else {
                completion(.failure(NetworkError.noData))
                return
            }
            
            // Data received successfully
            completion(.success(responseData))
        }.resume()
    }
    
    func updatePin(phoneNumber: String, oldPin: String, newPin: String, completion: @escaping (Bool, String) -> Void) {
            guard let url = URL(string: "\(baseURL)/auth/changepin") else {
                print("Invalid URL")
                completion(false, "Invalid URL")
                return
            }

            let formattedPhoneNumber = formatPhoneNumber(phoneNumber)
            let requestBody: [String: Any] = [
                "phonenumber": formattedPhoneNumber,
                "oldpin": oldPin,
                "newpin": newPin
            ]

            guard let jsonData = try? JSONSerialization.data(withJSONObject: requestBody) else {
                print("Error creating JSON")
                completion(false, "Error creating JSON")
                return
            }

            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = jsonData

            URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    print("Error: \(error.localizedDescription)")
                    completion(false, "Error: \(error.localizedDescription)")
                    return
                }

                guard let httpResponse = response as? HTTPURLResponse, let data = data else {
                    print("Invalid response")
                    completion(false, "Invalid response")
                    return
                }

                print("Response status code: \(httpResponse.statusCode)")
                if let responseBody = String(data: data, encoding: .utf8) {
                    print("Response body: \(responseBody)")
                }

                do {
                    let responseObject = try JSONDecoder().decode(UpdatePinResponse.self, from: data)
                    if responseObject.status == "00" {
                        // Successful pin update
                        completion(true, responseObject.message)
                    } else {
                        // Failed pin update
                        completion(false, responseObject.message)
                    }
                } catch {
                    // Error decoding response
                    print("Error decoding response: \(error.localizedDescription)")
                    completion(false, "Error decoding response")
                }
            }.resume()
        }

        struct UpdatePinResponse: Codable {
            let status: String
            let message: String
        }

  }

  // Define custom error types
  enum NetworkError: Error {
      case invalidURL
      case invalidData
      case invalidResponse
      case noData
  }

   
   
