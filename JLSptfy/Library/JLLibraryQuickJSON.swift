//
//  JLLibraryQuickJSON.swift
//  JLSptfy
//
//  Created by Jonathan Lu on 2020/2/14.
//  Copyright © 2020 Jonathan Lu. All rights reserved.
//

import UIKit


enum JLLibraryListSectionItem {
    case ArtistSectionItem(item: Artist_Full)
    case AlbumSectionItem(item: Library_Albums)
    case SongSectionItem(item: Library_Tracks)
    case PlaylistSectionItem(item: Playlist_Simplified)

}

enum JLLibraryContentType {
    case Playlists
    case Artists
    case Albums
    case Tracks
    
    func description() -> String {
        switch self {

        case .Playlists:
            return "playlists"
        case .Artists:
            return "artists"
        case .Albums:
            return "albums"
        case .Tracks:
            return "tracks"

        }
    }
}

enum JLLibraryQuickJSON {
    case Playlists(item: Search_PagingPlaylists)
    case Albums(item: Library_PagingAlbums)
    case Artists(item: Library_Following)
    case Songs(item: Library_PagingTracks)
    case none
    
    
    func getLastFollowingID() -> String? {
        switch self {
        case .Artists(let item):
            return item.artists?.cursors?.after
        default:
            return nil
        }
    }
}

// MARK: - Library_PagingAlbums
struct Library_PagingAlbums: Codable {
    let href: String?
    let items: [Library_Albums]?
    let limit: Int?
    let next: String?
    let offset: Int?
    let previous: String?
    let total: Int?
}

// MARK: Library_PagingAlbums convenience initializers and mutators

extension Library_PagingAlbums {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(Library_PagingAlbums.self, from: data)
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
        items: [Library_Albums]?? = nil,
        limit: Int?? = nil,
        next: String?? = nil,
        offset: Int?? = nil,
        previous: String?? = nil,
        total: Int?? = nil
    ) -> Library_PagingAlbums {
        return Library_PagingAlbums(
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

// MARK: - Library_Albums
struct Library_Albums: Codable {
    let addedAt: Date?
    let album: Album_Full?

    enum CodingKeys: String, CodingKey {
        case addedAt
        case album
    }
}

// MARK: Library_Albums convenience initializers and mutators

extension Library_Albums {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(Library_Albums.self, from: data)
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
        addedAt: Date?? = nil,
        album: Album_Full?? = nil
    ) -> Library_Albums {
        return Library_Albums(
            addedAt: addedAt ?? self.addedAt,
            album: album ?? self.album
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}





// MARK: - Library_PagingTracks
struct Library_PagingTracks: Codable {
    let href: String?
    let items: [Library_Tracks]?
    let limit: Int?
    let next: String?
    let offset: Int?
    let previous: String?
    let total: Int?
}

// MARK: Library_PagingTracks convenience initializers and mutators

extension Library_PagingTracks {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(Library_PagingTracks.self, from: data)
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
        items: [Library_Tracks]?? = nil,
        limit: Int?? = nil,
        next: String?? = nil,
        offset: Int?? = nil,
        previous: String?? = nil,
        total: Int?? = nil
    ) -> Library_PagingTracks {
        return Library_PagingTracks(
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

// MARK: - Library_Tracks
struct Library_Tracks: Codable {
    let addedAt: Date?
    let track: Track_Full?

    enum CodingKeys: String, CodingKey {
        case addedAt
        case track
    }
}

// MARK: Library_Tracks convenience initializers and mutators

extension Library_Tracks {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(Library_Tracks.self, from: data)
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
        addedAt: Date?? = nil,
        track: Track_Full?? = nil
    ) -> Library_Tracks {
        return Library_Tracks(
            addedAt: addedAt ?? self.addedAt,
            track: track ?? self.track
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}


// MARK: - Library_Following
struct Library_Following: Codable {
    let artists: Library_PagingArtists?
}

// MARK: Library_Following convenience initializers and mutators

extension Library_Following {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(Library_Following.self, from: data)
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
        artists: Library_PagingArtists?? = nil
    ) -> Library_Following {
        return Library_Following(
            artists: artists ?? self.artists
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}


// MARK: - Library_PagingArtists
struct Library_PagingArtists: Codable {
    let items: [Artist_Full]?
    let next: String?
    let total: Int?
    let cursors: Cursors?
    let limit: Int?
    let href: String?
}

// MARK: Library_PagingArtists convenience initializers and mutators

extension Library_PagingArtists {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(Library_PagingArtists.self, from: data)
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
        items: [Artist_Full]?? = nil,
        next: String?? = nil,
        total: Int?? = nil,
        cursors: Cursors?? = nil,
        limit: Int?? = nil,
        href: String?? = nil
    ) -> Library_PagingArtists {
        return Library_PagingArtists(
            items: items ?? self.items,
            next: next ?? self.next,
            total: total ?? self.total,
            cursors: cursors ?? self.cursors,
            limit: limit ?? self.limit,
            href: href ?? self.href
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}





// MARK: - Cursors
struct Cursors: Codable {
    let after: String?
}

// MARK: Cursors convenience initializers and mutators

extension Cursors {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(Cursors.self, from: data)
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
        after: String?? = nil
    ) -> Cursors {
        return Cursors(
            after: after ?? self.after
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}
