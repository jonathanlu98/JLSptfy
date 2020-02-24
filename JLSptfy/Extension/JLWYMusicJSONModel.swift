//
//  JLWYMusicJSONModel.swift
//  JLSptfy
//
//  Created by Jonathan Lu on 2020/2/20.
//  Copyright © 2020 Jonathan Lu. All rights reserved.
//

import UIKit

// MARK: - WYMusicJSON
struct WYMusicJSON: Codable {
    let result: WYMusicResult?
    let code: Int?
}

// MARK: WYMusicJSON convenience initializers and mutators

extension WYMusicJSON {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(WYMusicJSON.self, from: data)
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
        result: WYMusicResult?? = nil,
        code: Int?? = nil
    ) -> WYMusicJSON {
        return WYMusicJSON(
            result: result ?? self.result,
            code: code ?? self.code
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

// MARK: - WYMusicResult
struct WYMusicResult: Codable {
    let songs: [WYMusicSong]?
    let songCount: Int?
}

// MARK: WYMusicResult convenience initializers and mutators

extension WYMusicResult {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(WYMusicResult.self, from: data)
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
        songs: [WYMusicSong]?? = nil,
        songCount: Int?? = nil
    ) -> WYMusicResult {
        return WYMusicResult(
            songs: songs ?? self.songs,
            songCount: songCount ?? self.songCount
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

// MARK: - WYMusicSong
struct WYMusicSong: Codable {
    let id: Int?
    let name: String?
    let artists: [WYMusicArtist]?
    let album: WYMusicAlbum?
    let duration, copyrightID, status: Int?
    let alias: [String]?
    let rtype, ftype, mvid, fee: Int?
    let rURL: String?
    let mark: Int?

    enum CodingKeys: String, CodingKey {
        case id, name, artists, album, duration
        case copyrightID
        case status, alias, rtype, ftype, mvid, fee
        case rURL
        case mark
    }
}

// MARK: WYMusicSong convenience initializers and mutators

extension WYMusicSong {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(WYMusicSong.self, from: data)
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
        id: Int?? = nil,
        name: String?? = nil,
        artists: [WYMusicArtist]?? = nil,
        album: WYMusicAlbum?? = nil,
        duration: Int?? = nil,
        copyrightID: Int?? = nil,
        status: Int?? = nil,
        alias: [String]?? = nil,
        rtype: Int?? = nil,
        ftype: Int?? = nil,
        mvid: Int?? = nil,
        fee: Int?? = nil,
        rURL: String?? = nil,
        mark: Int?? = nil
    ) -> WYMusicSong {
        return WYMusicSong(
            id: id ?? self.id,
            name: name ?? self.name,
            artists: artists ?? self.artists,
            album: album ?? self.album,
            duration: duration ?? self.duration,
            copyrightID: copyrightID ?? self.copyrightID,
            status: status ?? self.status,
            alias: alias ?? self.alias,
            rtype: rtype ?? self.rtype,
            ftype: ftype ?? self.ftype,
            mvid: mvid ?? self.mvid,
            fee: fee ?? self.fee,
            rURL: rURL ?? self.rURL,
            mark: mark ?? self.mark
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

// MARK: - WYMusicAlbum
struct WYMusicAlbum: Codable {
    let id: Int?
    let name: String?
    let artist: WYMusicArtist?
    let publishTime, size, copyrightID, status: Int?
    let picID: Double?
    let mark: Int?

    enum CodingKeys: String, CodingKey {
        case id, name, artist, publishTime, size
        case copyrightID
        case status
        case picID
        case mark
    }
}

// MARK: WYMusicAlbum convenience initializers and mutators

extension WYMusicAlbum {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(WYMusicAlbum.self, from: data)
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
        id: Int?? = nil,
        name: String?? = nil,
        artist: WYMusicArtist?? = nil,
        publishTime: Int?? = nil,
        size: Int?? = nil,
        copyrightID: Int?? = nil,
        status: Int?? = nil,
        picID: Double?? = nil,
        mark: Int?? = nil
    ) -> WYMusicAlbum {
        return WYMusicAlbum(
            id: id ?? self.id,
            name: name ?? self.name,
            artist: artist ?? self.artist,
            publishTime: publishTime ?? self.publishTime,
            size: size ?? self.size,
            copyrightID: copyrightID ?? self.copyrightID,
            status: status ?? self.status,
            picID: picID ?? self.picID,
            mark: mark ?? self.mark
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

// MARK: - WYMusicArtist
struct WYMusicArtist: Codable {
    let id: Int?
    let name: String?
    let picURL: String?
    let alias: [String]?
    let albumSize, picID: Int?
    let img1V1URL: String?
    let img1V1: Int?
    let trans: String?

    enum CodingKeys: String, CodingKey {
        case id, name
        case picURL
        case alias, albumSize
        case picID
        case img1V1URL
        case img1V1
        case trans
    }
}

// MARK: WYMusicArtist convenience initializers and mutators

extension WYMusicArtist {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(WYMusicArtist.self, from: data)
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
        id: Int?? = nil,
        name: String?? = nil,
        picURL: String?? = nil,
        alias: [String]?? = nil,
        albumSize: Int?? = nil,
        picID: Int?? = nil,
        img1V1URL: String?? = nil,
        img1V1: Int?? = nil,
        trans: String?? = nil
    ) -> WYMusicArtist {
        return WYMusicArtist(
            id: id ?? self.id,
            name: name ?? self.name,
            picURL: picURL ?? self.picURL,
            alias: alias ?? self.alias,
            albumSize: albumSize ?? self.albumSize,
            picID: picID ?? self.picID,
            img1V1URL: img1V1URL ?? self.img1V1URL,
            img1V1: img1V1 ?? self.img1V1,
            trans: trans ?? self.trans
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}


// MARK: - WYMusicDataJSON
struct WYMusicDataJSON: Codable {
    let data: [WYSongData]?
    let code: Int?
}

// MARK: WYMusicDataJSON convenience initializers and mutators

extension WYMusicDataJSON {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(WYMusicDataJSON.self, from: data)
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
        data: [WYSongData]?? = nil,
        code: Int?? = nil
    ) -> WYMusicDataJSON {
        return WYMusicDataJSON(
            data: data ?? self.data,
            code: code ?? self.code
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

// MARK: - WYSongData
struct WYSongData: Codable {
    let id: Int?
    let url: String?
    let br, size: Int?
    let md5: String?
    let code, expi: Int?
    let type: String?
    let gain, fee: Int?
    let uf: String?
    let payed, flag: Int?
    let canExtend: Bool?
    let freeTrialInfo: String?
    let level, encodeType: String?
}

// MARK: WYSongData convenience initializers and mutators

extension WYSongData {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(WYSongData.self, from: data)
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
        id: Int?? = nil,
        url: String?? = nil,
        br: Int?? = nil,
        size: Int?? = nil,
        md5: String?? = nil,
        code: Int?? = nil,
        expi: Int?? = nil,
        type: String?? = nil,
        gain: Int?? = nil,
        fee: Int?? = nil,
        uf: String?? = nil,
        payed: Int?? = nil,
        flag: Int?? = nil,
        canExtend: Bool?? = nil,
        freeTrialInfo: String?? = nil,
        level: String?? = nil,
        encodeType: String?? = nil
    ) -> WYSongData {
        return WYSongData(
            id: id ?? self.id,
            url: url ?? self.url,
            br: br ?? self.br,
            size: size ?? self.size,
            md5: md5 ?? self.md5,
            code: code ?? self.code,
            expi: expi ?? self.expi,
            type: type ?? self.type,
            gain: gain ?? self.gain,
            fee: fee ?? self.fee,
            uf: uf ?? self.uf,
            payed: payed ?? self.payed,
            flag: flag ?? self.flag,
            canExtend: canExtend ?? self.canExtend,
            freeTrialInfo: freeTrialInfo ?? self.freeTrialInfo,
            level: level ?? self.level,
            encodeType: encodeType ?? self.encodeType
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}
