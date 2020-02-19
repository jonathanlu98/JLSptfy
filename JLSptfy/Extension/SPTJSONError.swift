//
//  SPTJSONError.swift
//  JLSptfy
//
//  Created by Jonathan Lu on 2020/2/18.
//  Copyright © 2020 Jonathan Lu. All rights reserved.
//

import UIKit

// MARK: - SPTJSONError
struct SPTJSONError: Codable {
    let error: ErrorItem?
}

// MARK: SPTJSONError convenience initializers and mutators

extension SPTJSONError {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(SPTJSONError.self, from: data)
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
        error: ErrorItem?? = nil
    ) -> SPTJSONError {
        return SPTJSONError(
            error: error ?? self.error
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
    
    func getError() -> Error {
        let error = NSError.init(domain: JLFetchManagement.description(), code: (self.error?.status)!, userInfo: ["error":self.error?.message])
        return error
    }
}

// MARK: - Error
struct ErrorItem: Codable {
    let status: Int?
    let message: String?
}

// MARK: Error convenience initializers and mutators

extension ErrorItem {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(ErrorItem.self, from: data)
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
        status: Int?? = nil,
        message: String?? = nil
    ) -> ErrorItem {
        return ErrorItem(
            status: status ?? self.status,
            message: message ?? self.message
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

