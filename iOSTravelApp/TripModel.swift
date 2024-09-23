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
    public var notes: String?

    @objc public init(destination: String, startDate: Date, endDate: Date, isFavorite: Bool, itinerary: [String], packingList: [PackingItem]) {
        self.id = UUID()
        self.destination = destination
        self.startDate = startDate
        self.endDate = endDate
        self.isFavorite = isFavorite
        self.itinerary = itinerary
        self.packingList = packingList
        self.notes = nil
        super.init()
    }

    public init(id: UUID = UUID(), destination: String, startDate: Date, endDate: Date, isFavorite: Bool = false, itinerary: [String] = [], packingList: [PackingItem] = [], notes: String? = nil) {
        self.id = id
        self.destination = destination
        self.startDate = startDate
        self.endDate = endDate
        self.isFavorite = isFavorite
        self.itinerary = itinerary
        self.packingList = packingList
        self.notes = notes
        super.init()
    }

    public var isUpcoming: Bool {
        return startDate > Date() || endDate > Date()
    }


    // MARK: - Codable

    enum CodingKeys: String, CodingKey {
        case id, destination, startDate, endDate, isFavorite, itinerary, packingList, notes
    }

    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UUID.self, forKey: .id)
        destination = try container.decode(String.self, forKey: .destination)
        startDate = try container.decode(Date.self, forKey: .startDate)
        endDate = try container.decode(Date.self, forKey: .endDate)
        isFavorite = try container.decode(Bool.self, forKey: .isFavorite)
        itinerary = try container.decode([String].self, forKey: .itinerary)
        packingList = try container.decode([PackingItem].self, forKey: .packingList)
        notes = try container.decodeIfPresent(String.self, forKey: .notes)
        super.init()
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(destination, forKey: .destination)
        try container.encode(startDate, forKey: .startDate)
        try container.encode(endDate, forKey: .endDate)
        try container.encode(isFavorite, forKey: .isFavorite)
        try container.encode(itinerary, forKey: .itinerary)
        try container.encode(packingList, forKey: .packingList)
        try container.encodeIfPresent(notes, forKey: .notes)
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

    // MARK: - Codable

    enum CodingKeys: String, CodingKey {
        case name, isPacked
    }

    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        name = try container.decode(String.self, forKey: .name)
        isPacked = try container.decode(Bool.self, forKey: .isPacked)
        super.init()
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: .name)
        try container.encode(isPacked, forKey: .isPacked)
    }
}
