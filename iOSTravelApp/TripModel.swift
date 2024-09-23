//
//  TripModel.swift
//  iOSTravelApp
//
//  Created by Claudia on 9/22/24.
//

import Foundation

@objcMembers
public class TripModel: NSObject, Codable {
    public let id: UUID
    public var destination: String
    public var startDate: Date
    public var endDate: Date
    public var isFavorite: Bool
    public var itinerary: [String]
    public var packingList: [PackingItem]

    @objc public init(destination: String, startDate: Date, endDate: Date, isFavorite: Bool, itinerary: [String], packingList: [PackingItem]) {
        self.id = UUID()
        self.destination = destination
        self.startDate = startDate
        self.endDate = endDate
        self.isFavorite = isFavorite
        self.itinerary = itinerary
        self.packingList = packingList
        super.init()
    }

    public var isUpcoming: Bool {
        return startDate > Date() || endDate > Date()
    }
}

@objcMembers
public class PackingItem: NSObject, Codable {
    public var name: String
    public var isPacked: Bool

    public init(name: String, isPacked: Bool = false) {
        self.name = name
        self.isPacked = isPacked
        super.init()
    }
}
