//
//  GoogleSheetsService.swift
//  BugIT
//
//  Created by admin on 16/09/2024.
//

import Foundation
import Alamofire

class GoogleSheetsService {
    
    let sheetID = "YOUR_SHEET_ID" // Replace with your Google Sheet ID
    let apiKey = "YOUR_API_KEY"   // Replace with your Google Sheets API Key
    
    // Function to authenticate user (via OAuth2)
    func authenticateUser(completion: @escaping (Result<String, Error>) -> Void) {
        // TODO: Implement OAuth2 authentication logic here
        // You'll need to get an access token from the user
    }

    // Function to append bug data to Google Sheets
    func appendBugData(bugDescription: String, imageURL: String, completion: @escaping (Result<Void, Error>) -> Void) {
        
        // URL for Google Sheets API
        let url = "https://sheets.googleapis.com/v4/spreadsheets/\(sheetID)/values/Sheet1:append?valueInputOption=USER_ENTERED&key=\(apiKey)"
        
        // Prepare the bug data as an array
        let date = getCurrentDate()
        let values = [
            [date, bugDescription, imageURL]
        ]
        
        // Request body
        let parameters: [String: Any] = [
            "values": values
        ]
        
        // Perform the request
        AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default).response { response in
            if let error = response.error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }
    
    // Helper function to get current date as a string
    private func getCurrentDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.string(from: Date())
    }
}
