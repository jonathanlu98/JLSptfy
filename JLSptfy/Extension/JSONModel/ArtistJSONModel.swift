//
//  ArtistJSONModel.swift
//  JLSptfy
//
//  Created by Jonathan Lu on 2020/2/15.
//  Copyright © 2020 Jonathan Lu. All rights reserved.
//

import Foundation

enum ArtistsKind {
    case full(item: Artist_Full)
    case simplified(item: Artist_Simplified)
}


// MARK: - Artist_Full
struct Artist_Full: Codable {
    let externalUrls: ExternalUrls?
    let followers: Followers?
    let genres: [String]?
    let href: String?
    let id: String?
    let images: [Image]?
    let name: String?
    let popularity: Int?
    let type: String?
    let uri: String?

    enum CodingKeys: String, CodingKey {
        case externalUrls
        case followers, genres, href, id, images, name, popularity, type, uri
    }
}

// MARK: Artist_Full convenience initializers and mutators

extension Artist_Full {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(Artist_Full.self, from: data)
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
        followers: Followers?? = nil,
        genres: [String]?? = nil,
        href: String?? = nil,
        id: String?? = nil,
        images: [Image]?? = nil,
        name: String?? = nil,
        popularity: Int?? = nil,
        type: String?? = nil,
        uri: String?? = nil
    ) -> Artist_Full {
        return Artist_Full(
            externalUrls: externalUrls ?? self.externalUrls,
            followers: followers ?? self.followers,
            genres: genres ?? self.genres,
            href: href ?? self.href,
            id: id ?? self.id,
            images: images ?? self.images,
            name: name ?? self.name,
            popularity: popularity ?? self.popularity,
            type: type ?? self.type,
            uri: uri ?? self.uri
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}


// MARK: - Artist_Simplified
struct Artist_Simplified: Codable {
    let externalUrls: ExternalUrls?
    let href: String?
    let id, name: String?
    let type: String?
    let uri: String?
//    let displayName: String?

    enum CodingKeys: String, CodingKey {
        case externalUrls
        case href, id, name, type, uri
//        case displayName
    }
}

// MARK: Artist_Simplified convenience initializers and mutators

extension Artist_Simplified {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(Artist_Simplified.self, from: data)
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
        name: String?? = nil,
        type: String?? = nil,
        uri: String?? = nil
//        displayName: String?? = nil
    ) -> Artist_Simplified {
        return Artist_Simplified(
            externalUrls: externalUrls ?? self.externalUrls,
            href: href ?? self.href,
            id: id ?? self.id,
            name: name ?? self.name,
            type: type ?? self.type,
            uri: uri ?? self.uri
//            displayName: displayName ?? self.displayName
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}



// MARK: - Followers
struct Followers: Codable {
    let href: String?
    let total: Int?
}

// MARK: Followers convenience initializers and mutators

extension Followers {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(Followers.self, from: data)
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
        href: String?? = nil,
        total: Int?? = nil
    ) -> Followers {
        return Followers(
            href: href ?? self.href,
            total: total ?? self.total
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}
