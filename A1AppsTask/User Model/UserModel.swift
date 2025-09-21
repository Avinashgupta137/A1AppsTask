//
//  UserModel.swift
//  A1AppsTask
//
//  Created by Avinash Gupta on 20/09/25.
//
import Foundation

struct InterviewDetailsResponse: Codable {
    let success: Bool
    let data: [User]
    let message: String?
}

struct User: Identifiable, Codable {
    let id = UUID()
    let image: String
    let email: String
    let name: String
    let age: Int
    let dob: String
}
