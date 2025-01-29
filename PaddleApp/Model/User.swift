//
//  User.swift
//  PaddleApp
//
//  Created by Jack Chambers on 2025-01-18.
//

import Foundation

struct User: Identifiable, Codable {
    let id: String
    let fullname: String
    let email: String
    let coach: Bool
    var crews: [String]
    var initals: String {
        let formatter = PersonNameComponentsFormatter()
        if let componets = formatter.personNameComponents(from: fullname) {
            formatter.style = .abbreviated
            return formatter.string(from: componets)
        }
        return ""
    }
}

extension User{
    static var MOCK_USER = User(id: NSUUID().uuidString, fullname: "Jackson Chambers", email: "jackchambers5@gmail.com", coach: false, crews: ["Crew 1", "Crew 2"]
    )
}
