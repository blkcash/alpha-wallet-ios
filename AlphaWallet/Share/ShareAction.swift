//
//  ShareAction.swift
//  AlphaWallet
//
//  Created by Vladyslav Shepitko on 11.11.2020.
//

import Foundation

enum ShareAction: String {

    static let scheme = "awallet"

    case content = "share_content"

    init?(url: URL) {
        guard let scheme = url.scheme, scheme == ShareAction.scheme, let host = url.host else { return nil }

        self.init(rawValue: host)
    }

    var url: URL {
        return URL(string: "\(ShareAction.scheme)://\(rawValue)")!
    }
}
