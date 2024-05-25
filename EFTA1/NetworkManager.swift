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

    func mobileAppLogin(phoneNumber: String, pin: String, completion: @escaping (Bool, Error?) -> Void) {
        guard let url = URL(string: "\(baseURL)/auth/mobileapplogin") else {
            completion(false, NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"]))
            return
        }
        let formattedPhoneNumber = formatPhoneNumber(phoneNumber)
        let requestBody: [String: Any] = [
            "phonenumber": formattedPhoneNumber,
            "pin": pin
        ]
        
        print("this is formatted number", formattedPhoneNumber)
        guard let jsonData = try? JSONSerialization.data(withJSONObject: requestBody) else {
            completion(false, NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Error creating JSON"]))
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData
        
        print ("Request Body for login: \(requestBody)")

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(false, error)
                return
            }

            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                completion(false, NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid response or status code"]))
                return
            }

            if let data = data, let responseBody = String(data: data, encoding: .utf8) {
                print("Response Body:", responseBody)
            }

            if let data = data {
                do {
                    if let responseObject = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                        if let status = responseObject["status"] as? String, status == "00",
                           let data = responseObject["data"] as? [String: Any],
                           let token = data["token"] as? String,
                           let userId = data["userId"] as? String {
                            
                            // Save the token and user ID
                            AuthManager.shared.saveToken(token)
                            AuthManager.shared.saveUserId(userId)
                            AuthManager.shared.savePhoneNumber(formattedPhoneNumber)

                            
                            completion(true, nil)
                        } else {
                            completion(false, NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to log in"]))
                        }
                    } else {
                        completion(false, NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid JSON response"]))
                    }
                } catch {
                    completion(false, error)
                }
            } else {
                completion(false, NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No data received"]))
            }
        }.resume()
    }
    
    // send customer onboarding
    
    private func appendToData(_ data: inout Data, string: String) {
           if let stringData = string.data(using: .utf8) {
               data.append(stringData)
           }
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
                files.append((data: imageData, fieldName: "999", fileName: "profile.jpg", mimeType: "image/jpeg"))
            }
            
        for (idType, urls) in onboardingData.documentURLs {
            for documentURL in urls {
                if let documentData = try? Data(contentsOf: documentURL) {
                    let fileName = documentURL.lastPathComponent
                    let fieldName = idType  // Use the ID type associated with the document
                    print("this is the field name", fieldName)
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
    func createMultipartFormData(boundary: String, parameters: [String: Any], files: [(data: Data, fieldName: String, fileName: String, mimeType: String)]) -> Data {
        var body = Data()

        // Add parameters
        for (key, value) in parameters {
            body.append("--\(boundary)\r\n".data(using: .utf8)!)
            body.append("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n".data(using: .utf8)!)
            body.append("\(value)\r\n".data(using: .utf8)!)
        }

        // Add files
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
    
    func logRequest(_ request: URLRequest) {
        print("Request: \(request.httpMethod ?? "NO METHOD") \(request.url?.absoluteString ?? "NO URL")")
        print("Headers: \(request.allHTTPHeaderFields ?? [:])")

        if let body = request.httpBody {
            if let bodyString = String(data: body, encoding: .utf8) {
                print("Body: \(bodyString)")
            } else {
                print("Body: (binary data)")
            }
        } else {
            print("Body: None")
        }
    }
   }
