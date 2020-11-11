//
//  ShareContentAttachment.swift
//  AlphaWallet
//
//  Created by Vladyslav Shepitko on 11.11.2020.
//

import Foundation

enum ShareContentAttachment: Codable {

    enum Keys: String, CodingKey {
        case value
    }

    case url(URL)
    case string(String)
    case unknown

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Keys.self)
        if let value = try container.decodeIfPresent(URL.self, forKey: .value) {
            self = .url(value)
        } else if let value = try container.decodeIfPresent(String.self, forKey: .value) {
            self = .string(value)
        } else {
            self = .unknown
        }
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: Keys.self)
        switch self {
        case .url(let value):
            try container.encode(value, forKey: .value)
        case .string(let value):
            try container.encode(value, forKey: .value)
        case .unknown:
            break
        }
    }
}

