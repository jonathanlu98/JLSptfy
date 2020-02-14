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
    let albums: Albums?
    let artists: Artists?
    let tracks: Tracks?
    let playlists: Playlists?
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
        albums: Albums?? = nil,
        artists: Artists?? = nil,
        tracks: Tracks?? = nil,
        playlists: Playlists?? = nil
    ) -> JLSearchQuickJSON {
        return JLSearchQuickJSON(
            albums: albums ?? self.albums,
            artists: artists ?? self.artists,
            tracks: tracks ?? self.tracks,
            playlists: playlists ?? self.playlists
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

// MARK: - Albums
struct Albums: Codable {
    let href: String?
    let items: [AlbumElement]?
    let limit: Int?
    let next: String?
    let offset: Int?
    let previous: String?
    let total: Int?
    
}

// MARK: Albums convenience initializers and mutators

extension Albums {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(Albums.self, from: data)
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
        items: [AlbumElement]?? = nil,
        limit: Int?? = nil,
        next: String?? = nil,
        offset: Int?? = nil,
        previous: String?? = nil,
        total: Int?? = nil
    ) -> Albums {
        return Albums(
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

// MARK: - AlbumElement
struct AlbumElement: Codable {
    
    let albumType: String?
    let artists: [Owner]?
    let availableMarkets: [String]?
    let externalUrls: ExternalUrls?
    let href: String?
    let id: String?
    let images: [Image]?
    let name: String?
    let releaseDate: String?
    let releaseDatePrecision: String?
    let totalTracks: Int?
    let type: String?
    let uri: String?
    
    let genres: [String]?
    let popularity: Int?
    let label:String?
    let tracks: Tracks?
    let copyrights: [String]?
    let externalIDS: ExternalIDS?
    
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
        case totalTracks
        case tracks, type, uri

    }
}

// MARK: AlbumElement convenience initializers and mutators

extension AlbumElement {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(AlbumElement.self, from: data)
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
        albumType: String?? = nil,
        artists: [Owner]?? = nil,
        availableMarkets: [String]?? = nil,
        externalUrls: ExternalUrls?? = nil,
        href: String?? = nil,
        id: String?? = nil,
        images: [Image]?? = nil,
        name: String?? = nil,
        releaseDate: String?? = nil,
        releaseDatePrecision: String?? = nil,
        totalTracks: Int?? = nil,
        type: String?? = nil,
        uri: String?? = nil,
        
        genres: [String]?? = nil,
        popularity: Int?? = nil,
        label: String?? = nil,
        tracks: Tracks?? = nil,
        copyrights: [String]?? = nil,
        externalIDS: ExternalIDS?? = nil
    ) -> AlbumElement {
        return AlbumElement(
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
            totalTracks: totalTracks ?? self.totalTracks,
            type: type ?? self.type,
            uri: uri ?? self.uri,
            
            genres: genres ?? self.genres,
            popularity: popularity ?? self.popularity,
            label: label ?? self.label,
            tracks: tracks ?? self.tracks,
            copyrights: copyrights ?? self.copyrights,
            externalIDS: externalIDS ?? self.externalIDS
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

enum AlbumTypeEnum: String, Codable {
    case album = "album"
    case compilation = "compilation"
    case single = "single"
}

// MARK: - Owner
struct Owner: Codable {
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

// MARK: Owner convenience initializers and mutators

extension Owner {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(Owner.self, from: data)
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
    ) -> Owner {
        return Owner(
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

enum OwnerType: String, Codable {
    case artist = "artist"
    case user = "user"
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

enum ReleaseDatePrecision: String, Codable {
    case day = "day"
    case year = "year"
}

// MARK: - Artists
struct Artists: Codable {
    let href: String?
    let items: [ArtistsItem]?
    let limit: Int?
    let next: String?
    let offset: Int?
    let previous: String?
    let total: Int?
}

// MARK: Artists convenience initializers and mutators

extension Artists {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(Artists.self, from: data)
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
        items: [ArtistsItem]?? = nil,
        limit: Int?? = nil,
        next: String?? = nil,
        offset: Int?? = nil,
        previous: String?? = nil,
        total: Int?? = nil
    ) -> Artists {
        return Artists(
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

// MARK: - ArtistsItem
struct ArtistsItem: Codable {
    let externalUrls: ExternalUrls?
    let followers: Followers?
    let genres: [String]?
    let href: String?
    let id: String?
    let images: [Image]?
    let name: String?
    let popularity: Int?
    let type: OwnerType?
    let uri: String?

    enum CodingKeys: String, CodingKey {
        case externalUrls
        case followers, genres, href, id, images, name, popularity, type, uri
    }
}

// MARK: ArtistsItem convenience initializers and mutators

extension ArtistsItem {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(ArtistsItem.self, from: data)
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
        type: OwnerType?? = nil,
        uri: String?? = nil
    ) -> ArtistsItem {
        return ArtistsItem(
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

// MARK: - Playlists
struct Playlists: Codable {
    let href: String?
    let items: [PlaylistsItem]?
    let limit: Int?
    let next: String?
    let offset: Int?
    let previous: String?
    let total: Int?
}

// MARK: Playlists convenience initializers and mutators

extension Playlists {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(Playlists.self, from: data)
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
        items: [PlaylistsItem]?? = nil,
        limit: Int?? = nil,
        next: String?? = nil,
        offset: Int?? = nil,
        previous: String?? = nil,
        total: Int?? = nil
    ) -> Playlists {
        return Playlists(
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

// MARK: - PlaylistsItem
struct PlaylistsItem: Codable {
    let collaborative: Bool?
    let itemDescription: String?
    let externalUrls: ExternalUrls?
    let href: String?
    let id: String?
    let images: [Image]?
    let name: String?
    let owner: Owner?
    let primaryColor: String?
    let itemPublic: Bool?
    let snapshotID: String?
    let tracks: Followers?
    let type: String?
    let uri: String?

    enum CodingKeys: String, CodingKey {
        case collaborative
        case itemDescription
        case externalUrls
        case href, id, images, name, owner
        case primaryColor
        case itemPublic
        case snapshotID
        case tracks, type, uri
    }
}

// MARK: PlaylistsItem convenience initializers and mutators

extension PlaylistsItem {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(PlaylistsItem.self, from: data)
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
        collaborative: Bool?? = nil,
        itemDescription: String?? = nil,
        externalUrls: ExternalUrls?? = nil,
        href: String?? = nil,
        id: String?? = nil,
        images: [Image]?? = nil,
        name: String?? = nil,
        owner: Owner?? = nil,
        primaryColor: String?? = nil,
        itemPublic: Bool?? = nil,
        snapshotID: String?? = nil,
        tracks: Followers?? = nil,
        type: String?? = nil,
        uri: String?? = nil
    ) -> PlaylistsItem {
        return PlaylistsItem(
            collaborative: collaborative ?? self.collaborative,
            itemDescription: itemDescription ?? self.itemDescription,
            externalUrls: externalUrls ?? self.externalUrls,
            href: href ?? self.href,
            id: id ?? self.id,
            images: images ?? self.images,
            name: name ?? self.name,
            owner: owner ?? self.owner,
            primaryColor: primaryColor ?? self.primaryColor,
            itemPublic: itemPublic ?? self.itemPublic,
            snapshotID: snapshotID ?? self.snapshotID,
            tracks: tracks ?? self.tracks,
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

// MARK: - Tracks
struct Tracks: Codable {
    let href: String?
    let items: [TracksItem]?
    let limit: Int?
    let next: String?
    let offset: Int?
    let previous: String?
    let total: Int?
}

// MARK: Tracks convenience initializers and mutators

extension Tracks {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(Tracks.self, from: data)
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
        items: [TracksItem]?? = nil,
        limit: Int?? = nil,
        next: String?? = nil,
        offset: Int?? = nil,
        previous: String?? = nil,
        total: Int?? = nil
    ) -> Tracks {
        return Tracks(
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

// MARK: - TracksItem
struct TracksItem: Codable {
    let album: AlbumElement?
    let artists: [Owner]?
    let availableMarkets: [String]?
    let discNumber, durationMS: Int?
    let explicit: Bool?
    let externalIDS: ExternalIDS?
    let externalUrls: ExternalUrls?
    let href: String?
    let id: String?
    let isLocal: Bool?
    let name: String?
    let popularity: Int?
    let previewURL: String?
    let trackNumber: Int?
    let type: FluffyType?
    let uri: String?

    enum CodingKeys: String, CodingKey {
        case album, artists
        case availableMarkets
        case discNumber
        case durationMS
        case explicit
        case externalIDS
        case externalUrls
        case href, id
        case isLocal
        case name, popularity
        case previewURL
        case trackNumber
        case type, uri
    }
}

// MARK: TracksItem convenience initializers and mutators

extension TracksItem {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(TracksItem.self, from: data)
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
        album: AlbumElement?? = nil,
        artists: [Owner]?? = nil,
        availableMarkets: [String]?? = nil,
        discNumber: Int?? = nil,
        durationMS: Int?? = nil,
        explicit: Bool?? = nil,
        externalIDS: ExternalIDS?? = nil,
        externalUrls: ExternalUrls?? = nil,
        href: String?? = nil,
        id: String?? = nil,
        isLocal: Bool?? = nil,
        name: String?? = nil,
        popularity: Int?? = nil,
        previewURL: String?? = nil,
        trackNumber: Int?? = nil,
        type: FluffyType?? = nil,
        uri: String?? = nil
    ) -> TracksItem {
        return TracksItem(
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
            isLocal: isLocal ?? self.isLocal,
            name: name ?? self.name,
            popularity: popularity ?? self.popularity,
            previewURL: previewURL ?? self.previewURL,
            trackNumber: trackNumber ?? self.trackNumber,
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

// MARK: - ExternalIDS
struct ExternalIDS: Codable {
    let isrc: String?
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
        isrc: String?? = nil
    ) -> ExternalIDS {
        return ExternalIDS(
            isrc: isrc ?? self.isrc
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

enum FluffyType: String, Codable {
    case track = "track"
}

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
