//
//  DragonBoatTeam.swift
//  PaddleApp
//
//  Created by Jack Chambers on 2025-01-19.
//

import Foundation
struct DragonBoatTeam: Identifiable, Codable {
    let id: String
    let crewname: String
    let coachname: String
    var members: [String]
    var coverImageURL: String?
}

extension DragonBoatTeam{
    static var MOCK_CREW = DragonBoatTeam(id:NSUUID().uuidString, crewname: "Blades of Therory", coachname: "Captain Throgthgar", members: ["Thorgar","Grommash","Gornak","Grommash","Gornak"], coverImageURL: nil)
}
