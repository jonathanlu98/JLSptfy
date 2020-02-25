//
//  PlaylistJSONModel.swift
//  JLSptfy
//
//  Created by Jonathan Lu on 2020/2/15.
//  Copyright © 2020 Jonathan Lu. All rights reserved.
//

import Foundation

enum PlaylistKind {
    case full(item: Playlist_Full)
    case simplified(item: Playlist_Simplified)
}


// MARK: - Playlist_Full
struct Playlist_Full: Codable {
    let collaborative: Bool?
    let itemDescription: String?
    let externalUrls: ExternalUrls?
    let followers: Followers?
    let href: String?
    let id: String?
    let images: [Image]?
    let name: String?
    let owner: User_Public?
//    let primaryColor: String?
    let itemPublic: Bool?
    let snapshotID: String?
    let tracks: Paging_Simplified_Tracks?
    let type: String?
    let uri: String?

    enum CodingKeys: String, CodingKey {
        case collaborative
        case itemDescription
        case externalUrls
        case followers
        case href, id, images, name, owner
//        case primaryColor
        case itemPublic
        case snapshotID
        case tracks, type, uri
    }
}

// MARK: Playlist_Full convenience initializers and mutators

extension Playlist_Full {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(Playlist_Full.self, from: data)
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
        followers: Followers?? = nil,
        href: String?? = nil,
        id: String?? = nil,
        images: [Image]?? = nil,
        name: String?? = nil,
        owner: User_Public?? = nil,
//        primaryColor: String?? = nil,
        itemPublic: Bool?? = nil,
        snapshotID: String?? = nil,
        tracks: Paging_Simplified_Tracks?? = nil,
        type: String?? = nil,
        uri: String?? = nil
    ) -> Playlist_Full {
        return Playlist_Full(
            collaborative: collaborative ?? self.collaborative,
            itemDescription: itemDescription ?? self.itemDescription,
            externalUrls: externalUrls ?? self.externalUrls,
            followers: followers ?? self.followers,
            href: href ?? self.href,
            id: id ?? self.id,
            images: images ?? self.images,
            name: name ?? self.name,
            owner: owner ?? self.owner,
//            primaryColor: primaryColor ?? self.primaryColor,
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



// MARK: - Playlist_Simplified
struct Playlist_Simplified: Codable {
    let collaborative: Bool?
    let itemDescription: String?
    let externalUrls: ExternalUrls?
    let href: String?
    let id: String?
    let images: [Image]?
    let name: String?
    let owner: User_Public?
    let itemPublic: Bool?
    let snapshotID: String?
    let tracks: Paging_Simplified_Tracks?
    let type: String?
    let uri: String?

    enum CodingKeys: String, CodingKey {
        case collaborative
        case itemDescription
        case externalUrls
        case href, id, images, name, owner
        case itemPublic
        case snapshotID
        case tracks, type, uri
    }
}

// MARK: Playlist_Simplified convenience initializers and mutators

extension Playlist_Simplified {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(Playlist_Simplified.self, from: data)
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
        owner: User_Public?? = nil,
        itemPublic: Bool?? = nil,
        snapshotID: String?? = nil,
        tracks: Paging_Simplified_Tracks?? = nil,
        type: String?? = nil,
        uri: String?? = nil
    ) -> Playlist_Simplified {
        return Playlist_Simplified(
            collaborative: collaborative ?? self.collaborative,
            itemDescription: itemDescription ?? self.itemDescription,
            externalUrls: externalUrls ?? self.externalUrls,
            href: href ?? self.href,
            id: id ?? self.id,
            images: images ?? self.images,
            name: name ?? self.name,
            owner: owner ?? self.owner,
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
