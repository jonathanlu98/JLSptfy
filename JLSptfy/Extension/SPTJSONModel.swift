//
//  SPTJSONModel.swift
//  JLSptfy
//
//  Created by Jonathan Lu on 2020/2/15.
//  Copyright © 2020 Jonathan Lu. All rights reserved.
//

import Foundation


// MARK: - User_Public
struct User_Public: Codable {
    let displayName: String?
    let externalUrls: ExternalUrls?
    let followers: Followers?
    let href: String?
    let id: String?
    let images: [Image]?
    let type: String?
    let uri: String?

    enum CodingKeys: String, CodingKey {
        case displayName
        case externalUrls
        case followers
        case href, id, images, type, uri
    }
}

// MARK: User_Public convenience initializers and mutators

extension User_Public {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(User_Public.self, from: data)
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
        displayName: String?? = nil,
        externalUrls: ExternalUrls?? = nil,
        followers: Followers?? = nil,
        href: String?? = nil,
        id: String?? = nil,
        images: [Image]?? = nil,
        type: String?? = nil,
        uri: String?? = nil

    ) -> User_Public {
        return User_Public(
            displayName: displayName ?? self.displayName,
            externalUrls: externalUrls ?? self.externalUrls,
            followers: followers ?? self.followers,
            href: href ?? self.href,
            id: id ?? self.id,
            images: images ?? self.images,
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



// MARK: - User_Private
struct User_Private: Codable {
    let country: String?
    let displayName: String?
    let email: String?
    let externalUrls: ExternalUrls?
    let followers: Followers?
    let href: String?
    let id: String?
    let images: [Image]?
    let product: String?
    let type: String?
    let uri: String?

    enum CodingKeys: String, CodingKey {
        case country
        case displayName
        case email
        case externalUrls
        case followers
        case href, id, images, product, type, uri
    }
}

// MARK: User_Private convenience initializers and mutators

extension User_Private {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(User_Private.self, from: data)
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
        country: String?? = nil,
        displayName: String?? = nil,
        email: String?? = nil,
        externalUrls: ExternalUrls?? = nil,
        followers: Followers?? = nil,
        href: String?? = nil,
        id: String?? = nil,
        images: [Image]?? = nil,
        product: String?? = nil,
        type: String?? = nil,
        uri: String?? = nil

    ) -> User_Private {
        return User_Private(
            country: country ?? self.country,
            displayName: displayName ?? self.displayName,
            email: email ?? self.email,
            externalUrls: externalUrls ?? self.externalUrls,
            followers: followers ?? self.followers,
            href: href ?? self.href,
            id: id ?? self.id,
            images: images ?? self.images,
            product: product ?? self.product,
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

// MARK: - Image
struct Image: Codable {
    let height: Int?
    let url: String?
    let width: Int?
}

// MARK: Image convenience initializers and mutators

extension Image {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(Image.self, from: data)
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
        height: Int?? = nil,
        url: String?? = nil,
        width: Int?? = nil
    ) -> Image {
        return Image(
            height: height ?? self.height,
            url: url ?? self.url,
            width: width ?? self.width
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

// MARK: - ExternalIDS
struct ExternalIDS: Codable {
    let isrc: String?
    let ean: String?
    let upc: String?
}

// MARK: ExternalIDS convenience initializers and mutators

extension ExternalIDS {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(ExternalIDS.self, from: data)
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
        isrc: String?? = nil,
        ean: String?? = nil,
        upc: String?? = nil
    ) -> ExternalIDS {
        return ExternalIDS(
            isrc: isrc ?? self.isrc,
            ean: ean ?? self.ean,
            upc: upc ?? self.upc
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}


// MARK: - ExternalUrls
struct ExternalUrls: Codable {
    let spotify: String?
}

// MARK: ExternalUrls convenience initializers and mutators

extension ExternalUrls {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(ExternalUrls.self, from: data)
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
        spotify: String?? = nil
    ) -> ExternalUrls {
        return ExternalUrls(
            spotify: spotify ?? self.spotify
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

//enum Artist_SimplifiedType: String, Codable {
//    case artist = "artist"
//    case user = "user"
//}


// MARK: - Helper functions for creating encoders and decoders

func newJSONDecoder() -> JSONDecoder {
    let decoder = JSONDecoder()
    if #available(iOS 10.0, OSX 10.12, tvOS 10.0, watchOS 3.0, *) {
        decoder.dateDecodingStrategy = .iso8601
    }
    return decoder
}

func newJSONEncoder() -> JSONEncoder {
    let encoder = JSONEncoder()
    if #available(iOS 10.0, OSX 10.12, tvOS 10.0, watchOS 3.0, *) {
        encoder.dateEncodingStrategy = .iso8601
    }
    return encoder
}

// MARK: - Encode/decode helpers

class JSONNull: Codable, Hashable {

    public static func == (lhs: JSONNull, rhs: JSONNull) -> Bool {
        return true
    }

    public var hashValue: Int {
        return 0
    }

    public init() {}

    public required init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if !container.decodeNil() {
            throw DecodingError.typeMismatch(JSONNull.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for JSONNull"))
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encodeNil()
    }
}


// MARK: - Paging_Simplified_Tracks
struct Paging_Simplified_Tracks: Codable {
    let href: String?
    let items: [Artist_Simplified]?
    let limit: Int?
    let next: String?
    let offset: Int?
    let previous: String?
    let total: Int?
    
}

// MARK: Paging_Simplified_Tracks convenience initializers and mutators

extension Paging_Simplified_Tracks {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(Paging_Simplified_Tracks.self, from: data)
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
        items: [Artist_Simplified]?? = nil,
        limit: Int?? = nil,
        next: String?? = nil,
        offset: Int?? = nil,
        previous: String?? = nil,
        total: Int?? = nil
    ) -> Paging_Simplified_Tracks {
        return Paging_Simplified_Tracks(
            href: href ?? self.href,
            items: items ?? self.items,
            limit: limit ?? self.limit,
            next: next ?? self.next,
            offset: offset ?? self.offset,
            previous: previous ?? self.previous,
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


//enum PagingItem: {
//
//    case playlist(item: PlaylistKind)
//    case album(item: AlbumKind)
//    case track(item: TrackKind)
//    case artist(item: ArtistsKind)
//}
