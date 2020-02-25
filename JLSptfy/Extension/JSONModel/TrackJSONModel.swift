//
//  TrackJSONModel.swift
//  JLSptfy
//
//  Created by Jonathan Lu on 2020/2/15.
//  Copyright © 2020 Jonathan Lu. All rights reserved.
//

import Foundation

enum TrackKind {
    case full(item: Track_Full)
    case simplified(item: Track_Simplified)
}


// MARK: - Track_Full
struct Track_Full: Codable {
    let album: Album_Simplified?
    let artists: [Artist_Simplified]?
    let availableMarkets: [String]?
    let discNumber, durationMS: Int?
    let explicit: Bool?
    let externalIDS: ExternalIDS?
    let externalUrls: ExternalUrls?
    let href: String?
    let id: String?
    let isPlayable: Bool?
    let linkedFrom: Track_Link?
    let name: String?
    let popularity: Int?
    let previewURL: String?
    let trackNumber: Int?
    let type: String?
    let uri: String?
    let isLocal: Bool?
    
    enum CodingKeys: String, CodingKey {
        case album, artists
        case availableMarkets
        case discNumber
        case durationMS
        case explicit
        case externalIDS
        case externalUrls
        case href, id
        case isPlayable
        case linkedFrom
        case name, popularity
        case previewURL
        case trackNumber
        case type, uri
        case isLocal
    }
}

// MARK: Track_Full convenience initializers and mutators

extension Track_Full {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(Track_Full.self, from: data)
    }

    init(_ json: String, using encoding: String.Encoding = .utf8) throws {
        guard let data = json.data(using: encoding) else {
            throw NSError(domain: "JSONDecoding", code: 0, userInfo: nil)
        }
        try self.init(data: data)
    }

    init(fromURL url: URL) throws {
        try self.init(data: try Data(contentsOf: url))
    }

    func with(
        album: Album_Simplified?? = nil,
        artists: [Artist_Simplified]?? = nil,
        availableMarkets: [String]?? = nil,
        discNumber: Int?? = nil,
        durationMS: Int?? = nil,
        explicit: Bool?? = nil,
        externalIDS: ExternalIDS?? = nil,
        externalUrls: ExternalUrls?? = nil,
        href: String?? = nil,
        id: String?? = nil,
        isPlayable: Bool?? = nil,
        linkedFrom: Track_Link?? = nil,
        name: String?? = nil,
        popularity: Int?? = nil,
        previewURL: String?? = nil,
        trackNumber: Int?? = nil,
        type: String?? = nil,
        uri: String?? = nil,
        isLocal: Bool?? = nil
    ) -> Track_Full {
        return Track_Full(
            album: album ?? self.album,
            artists: artists ?? self.artists,
            availableMarkets: availableMarkets ?? self.availableMarkets,
            discNumber: discNumber ?? self.discNumber,
            durationMS: durationMS ?? self.durationMS,
            explicit: explicit ?? self.explicit,
            externalIDS: externalIDS ?? self.externalIDS,
            externalUrls: externalUrls ?? self.externalUrls,
            href: href ?? self.href,
            id: id ?? self.id,
            isPlayable: isPlayable ?? self.isPlayable,
            linkedFrom: linkedFrom ?? self.linkedFrom,
            name: name ?? self.name,
            popularity: popularity ?? self.popularity,
            previewURL: previewURL ?? self.previewURL,
            trackNumber: trackNumber ?? self.trackNumber,
            type: type ?? self.type,
            uri: uri ?? self.uri,
            isLocal: isLocal ?? self.isLocal
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}


// MARK: - Track_Simplified
struct Track_Simplified: Codable {
    let artists: [Artist_Simplified]?
    let availableMarkets: [String]?
    let discNumber, durationMS: Int?
    let explicit: Bool?
    let externalUrls: ExternalUrls?
    let href: String?
    let id: String?
    let isPlayable: Bool?
    let linkedFrom: Track_Link?
    let name: String?
    let previewURL: String?
    let trackNumber: Int?
    let type: String?
    let uri: String?
    let isLocal: Bool?
    
    enum CodingKeys: String, CodingKey {
        case artists
        case availableMarkets
        case discNumber
        case durationMS
        case explicit
        case externalUrls
        case href, id
        case isPlayable
        case linkedFrom
        case name
        case previewURL
        case trackNumber
        case type, uri
        case isLocal
    }
}

// MARK: Track_Simplified convenience initializers and mutators

extension Track_Simplified {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(Track_Simplified.self, from: data)
    }

    init(_ json: String, using encoding: String.Encoding = .utf8) throws {
        guard let data = json.data(using: encoding) else {
            throw NSError(domain: "JSONDecoding", code: 0, userInfo: nil)
        }
        try self.init(data: data)
    }

    init(fromURL url: URL) throws {
        try self.init(data: try Data(contentsOf: url))
    }

    func with(
        artists: [Artist_Simplified]?? = nil,
        availableMarkets: [String]?? = nil,
        discNumber: Int?? = nil,
        durationMS: Int?? = nil,
        explicit: Bool?? = nil,
        externalUrls: ExternalUrls?? = nil,
        href: String?? = nil,
        id: String?? = nil,
        isPlayable: Bool?? = nil,
        linkedFrom: Track_Link?? = nil,
        name: String?? = nil,
        previewURL: String?? = nil,
        trackNumber: Int?? = nil,
        type: String?? = nil,
        uri: String?? = nil,
        isLocal: Bool?? = nil
    ) -> Track_Simplified {
        return Track_Simplified(
            artists: artists ?? self.artists,
            availableMarkets: availableMarkets ?? self.availableMarkets,
            discNumber: discNumber ?? self.discNumber,
            durationMS: durationMS ?? self.durationMS,
            explicit: explicit ?? self.explicit,
            externalUrls: externalUrls ?? self.externalUrls,
            href: href ?? self.href,
            id: id ?? self.id,
            isPlayable: isPlayable ?? self.isPlayable,
            linkedFrom: linkedFrom ?? self.linkedFrom,
            name: name ?? self.name,
            previewURL: previewURL ?? self.previewURL,
            trackNumber: trackNumber ?? self.trackNumber,
            type: type ?? self.type,
            uri: uri ?? self.uri,
            isLocal: isLocal ?? self.isLocal
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}




//MARK: Track_Link
struct Track_Link: Codable {
    let externalUrls: ExternalUrls?
    let href: String?
    let id: String?
    let type: String?
    let uri: String?
    
    enum CodingKeys: String, CodingKey {
        case externalUrls
        case href, id
        case type, uri
    }
}

// MARK: Track_Link convenience initializers and mutators


extension Track_Link {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(Track_Link.self, from: data)
    }

    init(_ json: String, using encoding: String.Encoding = .utf8) throws {
        guard let data = json.data(using: encoding) else {
            throw NSError(domain: "JSONDecoding", code: 0, userInfo: nil)
        }
        try self.init(data: data)
    }

    init(fromURL url: URL) throws {
        try self.init(data: try Data(contentsOf: url))
    }
    func with(
        externalUrls: ExternalUrls?? = nil,
        href: String?? = nil,
        id: String?? = nil,
        type: String?? = nil,
        uri: String?? = nil
    ) -> Track_Link {
        return Track_Link(
            externalUrls: externalUrls ?? self.externalUrls,
            href: href ?? self.href,
            id: id ?? self.id,
            type: type ?? self.type,
            uri: uri ?? self.uri
        )
    }

}
