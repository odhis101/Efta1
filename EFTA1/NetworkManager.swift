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

    // account look up
    func sendStaffDetails(staffNumber: String, phoneNumber: String, completion: @escaping (Bool, Error?) -> Void) {
        // Prepare the request to check the staff account
        guard let url = URL(string: "\(baseURL)/auth/staffaccountlookup") else {
            // If the URL is invalid, call the completion handler with an error
            completion(false, NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"]))
            return
        }

        let body: [String: Any] = [
            "staffNumber": staffNumber,
        ]
        
        guard let jsonData = try? JSONSerialization.data(withJSONObject: body, options: []) else {
            // If there's an error creating JSON data, call the completion handler with an error
            completion(false, NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Error creating JSON"]))
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
                completion(false, error)
                return
            }

            guard let httpResponse = response as? HTTPURLResponse else {
                // If the response is not an HTTP response, call the completion handler with an error
                print("Invalid response: \(String(describing: response))")
                completion(false, NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid response"]))
                return
            }

            guard httpResponse.statusCode == 200 else {
                // If the response status code is not 200, call the completion handler with an error
                print("Invalid status code: \(httpResponse.statusCode)")
                completion(false, NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid status code \(httpResponse.statusCode)"]))
                return
            }

            // Parse the response data
            guard let responseData = data else {
                // If no data is received, call the completion handler with an error
                print("No data received")
                completion(false, NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No data received"]))
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
                    completion(false, NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid response format or status"]))
                    return
                }
                
                // Extract the last 9 digits of the retrieved phone number
                let last9Digits = String(retrievedPhoneNumber.suffix(9))
                
                // Extract the last 9 digits of the provided phone number
                let providedLast9Digits = String(phoneNumber.suffix(9))
                
                // Log the expected vs. the retrieved phone number for debugging
                print("Expected last 9 digits: \(providedLast9Digits)")
                print("Retrieved last 9 digits: \(last9Digits)")
                
                // Check if the last 9 digits of the retrieved phone number match the provided phone number
                if last9Digits == providedLast9Digits {
                    // If the phone numbers match, call the completion handler with success
                    completion(true, nil)
                } else {
                    // If the phone numbers do not match, log the mismatch and call the completion handler with an error
                    print("Phone number mismatch: Expected \(providedLast9Digits), got \(last9Digits)")
                    completion(false, NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid phone number"]))
                }
            } catch {
                // If there's an error parsing the response data, log the error and call the completion handler with the error
                print("JSON parsing error: \(error.localizedDescription)")
                completion(false, error)
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


    func submitSecurityQuestions(answers: [(answer: String, question: String)], phoneNumber: String, completion: @escaping (Bool, Error?) -> Void) {
        // Prepare the URL
        guard let url = URL(string: "\(baseURL)/auth/securityquestions") else {
            print("Error: Failed to construct URL with base URL \(baseURL) and endpoint /auth/securityquestions")
            completion(false, NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"]))
            return
        }
        
        // Construct the request body
        let requestBody: [String: Any] = [
            "answers": answers.map { ["answer": $0.answer, "question": $0.question] },
            "phonenumber": phoneNumber
        ]
        
        // Print the request body for debugging purposes
        print("Request Body: \(requestBody)")
        
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
        
        // Print the constructed URLRequest for debugging purposes
        print("Constructed URLRequest: \(request)")
        
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

    // send otp request



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
    
    
    func mobileAppLogin(phoneNumber: String, pin: String, completion: @escaping (Bool, Error?) -> Void) {
        guard let url = URL(string: "\(baseURL)/auth/mobileapplogin") else {
            completion(false, NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"]))
            return
        }

        // Construct the request body
        let requestBody: [String: Any] = [
            "phonenumber": phoneNumber,
            "pin": pin
        ]

        // Convert the request body to JSON data
        guard let jsonData = try? JSONSerialization.data(withJSONObject: requestBody) else {
            completion(false, NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Error creating JSON"]))
            return
        }

        // Log the request body
        print("Request Body:", requestBody)

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(false, error)
                return
            }

            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                completion(false, NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid response or status code"]))
                return
            }

            // Log the response body if available
            if let data = data, let responseBody = String(data: data, encoding: .utf8) {
                print("Response Body:", responseBody)
            }

            // Parse the response data if available
            if let data = data {
                do {
                    if let responseObject = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                        // Handle the response based on the parsed JSON object
                        if let status = responseObject["status"] as? String {
                            if status == "00" {
                                // Successful response
                                completion(true, nil)
                            } else {
                                // Unsuccessful response
                                completion(false, NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to log in"]))
                            }
                        } else {
                            // Unable to extract status from response
                            completion(false, NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid response format"]))
                        }
                    } else {
                        // Unable to parse JSON response
                        completion(false, NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid JSON response"]))
                    }
                } catch {
                    // Error parsing JSON
                    completion(false, error)
                }
            } else {
                // No data received
                completion(false, NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No data received"]))
            }
        }.resume()
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
