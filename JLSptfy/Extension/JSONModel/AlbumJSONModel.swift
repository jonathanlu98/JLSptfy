//
//  AlbumJSONModel.swift
//  JLSptfy
//
//  Created by Jonathan Lu on 2020/2/15.
//  Copyright © 2020 Jonathan Lu. All rights reserved.
//

import Foundation


enum AlbumKind {
    case full(item: Album_Full)
    case simplified(item: Album_Simplified)
}

// MARK: - Album_Full
struct Album_Full: Codable {
    
    let albumType: AlbumTypeEnum?
    let artists: [Artist_Simplified]?
    let availableMarkets: [String]?
    let copyrights: [Copyright]?
    let externalIDS: ExternalIDS?
    let externalUrls: ExternalUrls?
    let genres: [String]?
    let href: String?
    let id: String?
    let images: [Image]?
    let label:String?
    let name: String?
    let popularity: Int?
    let releaseDate: String?
    let releaseDatePrecision: String?
    let tracks: Paging_Simplified_Tracks?
    let totalTracks: Int?
    let type: String?
    let url: String?
    
    
    
    enum CodingKeys: String, CodingKey {
        case albumType
        case artists
        case availableMarkets
        case copyrights
        case externalIDS
        case externalUrls
        case genres, href, id, images, label, name, popularity
        case releaseDate
        case releaseDatePrecision
        case tracks
        case totalTracks
        case type, url

    }
}

// MARK: Album_Full convenience initializers and mutators

extension Album_Full {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(Album_Full.self, from: data)
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


    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}


// MARK: - Album_Simplified
struct Album_Simplified: Codable {
    
    let albumType: AlbumTypeEnum?
    let artists: [Artist_Simplified]?
    let availableMarkets: [String]?
    let externalUrls: ExternalUrls?
    let href: String?
    let id: String?
    let images: [Image]?
    let name: String?
    let releaseDate: String?
    let releaseDatePrecision: String?
    let type: String?
    let uri: String?
    
    
    enum CodingKeys: String, CodingKey {
        case albumType
        case artists
        case availableMarkets
        case externalUrls
        case href, id, images, name
        case releaseDate
        case releaseDatePrecision
        case type, uri

    }
}

// MARK: Simplified convenience initializers and mutators

extension Album_Simplified {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(Album_Simplified.self, from: data)
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
        albumType: AlbumTypeEnum?? = nil,
        artists: [Artist_Simplified]?? = nil,
        availableMarkets: [String]?? = nil,
        externalUrls: ExternalUrls?? = nil,
        href: String?? = nil,
        id: String?? = nil,
        images: [Image]?? = nil,
        name: String?? = nil,
        releaseDate: String?? = nil,
        releaseDatePrecision: String?? = nil,
        type: String?? = nil,
        uri: String?? = nil
        

    ) -> Album_Simplified {
        return Album_Simplified(
            albumType: albumType ?? self.albumType,
            artists: artists ?? self.artists,
            availableMarkets: availableMarkets ?? self.availableMarkets,
            externalUrls: externalUrls ?? self.externalUrls,
            href: href ?? self.href,
            id: id ?? self.id,
            images: images ?? self.images,
            name: name ?? self.name,
            releaseDate: releaseDate ?? self.releaseDate,
            releaseDatePrecision: releaseDatePrecision ?? self.releaseDatePrecision,
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







// MARK: - Copyright
struct Copyright: Codable {
    let text: String?
    let type: CopyrightType?
}

// MARK: Copyright convenience initializers and mutators

extension Copyright {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(Copyright.self, from: data)
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
        text: String?? = nil,
        type: CopyrightType?? = nil
    ) -> Copyright {
        return Copyright(
            text: text ?? self.text,
            type: type ?? self.type
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}




enum CopyrightType: String, Codable {
    case c = "C"
    case p = "P"
}


enum AlbumTypeEnum: String, Codable {
    case album = "album"
    case compilation = "compilation"
    case single = "single"
}

enum ReleaseDatePrecision: String, Codable {
    case day = "day"
    case year = "year"
}
