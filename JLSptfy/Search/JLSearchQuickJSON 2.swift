//
//  JLSearchQuickJSON.swift
//  JLSptfy
//
//  Created by Jonathan Lu on 2020/2/5.
//  Copyright © 2020 Jonathan Lu. All rights reserved.
//

import Foundation

// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let JLSearchQuickJSON = try JLSearchQuickJSON(json)

import Foundation

enum JLSearchType {
    case album
    case artist
    case track
    case playlist
    case all /*album,artist,track,playlist*/
    
    func description()->String {
        switch self {
        case .album:
            return "album"
        case .artist:
            return "artist"
        case .playlist:
            return "playlist"
        case .track:
            return "track"
        case .all:
            return "track,artist,album,playlist"
        }
    }
    
}

// MARK: - JLSearchQuickJSON
struct JLSearchQuickJSON: Codable {
    let albums: Search_PagingAlbums?
    let artists: Search_PagingArtists?
    let tracks: Search_PagingTracks?
    let playlists: Search_PagingPlaylists?
    let error: SPTJSONError?
}

// MARK: JLSearchQuickJSON convenience initializers and mutators

extension JLSearchQuickJSON {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(JLSearchQuickJSON.self, from: data)
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
        albums: Search_PagingAlbums?? = nil,
        artists: Search_PagingArtists?? = nil,
        tracks: Search_PagingTracks?? = nil,
        playlists: Search_PagingPlaylists?? = nil,
        error: SPTJSONError?? = nil
    ) -> JLSearchQuickJSON {
        return JLSearchQuickJSON(
            albums: albums ?? self.albums,
            artists: artists ?? self.artists,
            tracks: tracks ?? self.tracks,
            playlists: playlists ?? self.playlists,
            error: error ?? self.error
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
    
    
    func isError( )-> Bool {
        if (self.error != nil) {
            return true
        } else {
            return false
        }
    }
}








// MARK: - Search_PagingAlbums
struct Search_PagingAlbums: Codable {
    let href: String?
    let items: [Album_Simplified]?
    let limit: Int?
    let next: String?
    let offset: Int?
    let previous: String?
    let total: Int?
    
}

// MARK: Search_PagingAlbums convenience initializers and mutators

extension Search_PagingAlbums {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(Search_PagingAlbums.self, from: data)
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
        items: [Album_Simplified]?? = nil,
        limit: Int?? = nil,
        next: String?? = nil,
        offset: Int?? = nil,
        previous: String?? = nil,
        total: Int?? = nil
    ) -> Search_PagingAlbums {
        return Search_PagingAlbums(
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







// MARK: - Search_PagingArtists
struct Search_PagingArtists: Codable {
    let href: String?
    let items: [Artist_Full]?
    let limit: Int?
    let next: String?
    let offset: Int?
    let previous: String?
    let total: Int?
}

// MARK: Search_PagingArtists convenience initializers and mutators

extension Search_PagingArtists {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(Search_PagingArtists.self, from: data)
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
        items: [Artist_Full]?? = nil,
        limit: Int?? = nil,
        next: String?? = nil,
        offset: Int?? = nil,
        previous: String?? = nil,
        total: Int?? = nil
    ) -> Search_PagingArtists {
        return Search_PagingArtists(
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



// MARK: - Search_PagingPlaylists
struct Search_PagingPlaylists: Codable {
    let href: String?
    let items: [Playlist_Simplified]?
    let limit: Int?
    let next: String?
    let offset: Int?
    let previous: String?
    let total: Int?
}

// MARK: Search_PagingPlaylists convenience initializers and mutators

extension Search_PagingPlaylists {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(Search_PagingPlaylists.self, from: data)
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
        items: [Playlist_Simplified]?? = nil,
        limit: Int?? = nil,
        next: String?? = nil,
        offset: Int?? = nil,
        previous: String?? = nil,
        total: Int?? = nil
    ) -> Search_PagingPlaylists {
        return Search_PagingPlaylists(
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


// MARK: - Search_PagingTracks
struct Search_PagingTracks: Codable {
    let href: String?
    let items: [Track_Full]?
    let limit: Int?
    let next: String?
    let offset: Int?
    let previous: String?
    let total: Int?
}

// MARK: Search_PagingTracks convenience initializers and mutators

extension Search_PagingTracks {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(Search_PagingTracks.self, from: data)
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
        items: [Track_Full]?? = nil,
        limit: Int?? = nil,
        next: String?? = nil,
        offset: Int?? = nil,
        previous: String?? = nil,
        total: Int?? = nil
    ) -> Search_PagingTracks {
        return Search_PagingTracks(
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





