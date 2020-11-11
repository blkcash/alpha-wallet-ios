//
//  SharedUserDefaults.swift
//  AlphaWallet
//
//  Created by Vladyslav Shepitko on 11.11.2020.
//

import Foundation

class SharedDefaults: NSObject {

    private enum Config {
        static let group = "group.com.stormbird.alphawallet"
    }

    private enum Keys {
        static let content = "content"
    }
    
    private let defaults = UserDefaults(suiteName: Config.group)

    var attachement: ShareContentAttachment? {
        get {
            guard let data = defaults?.data(forKey: Keys.content), let value = try? JSONDecoder().decode(ShareContentAttachment.self, from: data) else {
                return nil
            }
            return value
        }
        set {
            if let value = newValue, let data = try? JSONEncoder().encode(value) {
                defaults?.set(data, forKey: Keys.content)
            } else {
                defaults?.removeObject(forKey: Keys.content)
            }
        }
    }
}
