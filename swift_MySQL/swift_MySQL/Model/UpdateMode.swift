//
//  UpdateMode.swift
//  swift_MySQL
//
//  Created by changbin an on 12/18/24.
//

import Foundation

protocol MainUpdateModelProtocol {
    func contactUpdated(success: Bool, message: String)
}
    // Update Contact Method
    class QueryModelUpdate {
        var delegate: MainUpdateModelProtocol?
        let baseURL = "http://127.0.0.1:8000"
        
        func updateContact(contactID: Int, name: String, phoneNumber: String, address: String, relation: String) async {
            guard let url = URL(string: "\(baseURL)/update_address/\(contactID)") else {
                delegate?.contactUpdated(success: false, message: "Invalid URL")
                return
            }
            
            var request = URLRequest(url: url)
            request.httpMethod = "PUT"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            
            let requestBody: [String: Any] = [
                "name": name,
                "phone_number": phoneNumber,
                "address": address,
                "relation": relation
            ]
            
            do {
                let jsonData = try JSONSerialization.data(withJSONObject: requestBody, options: .prettyPrinted)
                request.httpBody = jsonData
                
                let (data, response) = try await URLSession.shared.data(for: request)
                guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                    let errorMessage = String(data: data, encoding: .utf8) ?? "Unknown error"
                    delegate?.contactUpdated(success: false, message: errorMessage)
                    return
                }
                
                delegate?.contactUpdated(success: true, message: "Contact updated successfully")
            } catch {
                delegate?.contactUpdated(success: false, message: error.localizedDescription)
            }
        }
    }
