//
//  APIService.swift
//  A1AppsTask
//
//  Created by Avinash Gupta on 20/09/25.
//
import Foundation

enum APIError: Error {
    case invalidURL
    case invalidResponse
    case decodingError(Error)
    case httpError(statusCode: Int)
}

class APIService {
    static let shared = APIService()
    private let baseURL = "https://core-apis.a1apps.co/ios"
    
    private init() {}
    
    func fetchInterviewDetails() async throws -> [User] {
        let urlString = "\(baseURL)/interview-details"
        
        guard let url = URL(string: urlString) else {
            throw APIError.invalidURL
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
            throw APIError.invalidResponse
        }
        
        let jsonObject = try JSONSerialization.jsonObject(with: data, options: [])
        let decoder = JSONDecoder()
        
        if let dict = jsonObject as? [String: Any], let dataArray = dict["data"] {
            let jsonData = try JSONSerialization.data(withJSONObject: dataArray)
            return try decoder.decode([User].self, from: jsonData)
        } else if jsonObject is [[String: Any]] {
            return try decoder.decode([User].self, from: data)
        } else {
            throw APIError.decodingError(NSError(domain: "Unexpected JSON format", code: 0))
        }
    }
}
