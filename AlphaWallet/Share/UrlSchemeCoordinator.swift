//
//  UrlSchemeCoordinator.swift
//  AlphaWallet
//
//  Created by Vladyslav Shepitko on 11.11.2020.
//

import Foundation

protocol UrlSchemeResolver: class {
    func openURLInBrowser(url: URL)
}

protocol UrlSchemeCoordinatorDelegate: class {
    func resolve(for coordinator: UrlSchemeCoordinator) -> UrlSchemeResolver?
}

class UrlSchemeCoordinator {
    private let storage: SharedDefaults
    var pendingUrl: URL?

    weak var delegate: UrlSchemeCoordinatorDelegate?

    init(storage: SharedDefaults) {
        self.storage = storage
    }

    @discardableResult func handleOpen(url: URL) -> Bool {
        if canHandle(url: url) {
            if let inCoordinator = delegate?.resolve(for: self) {
                self.process(url: url, with: inCoordinator)
            } else {
                pendingUrl = url
            }

            return true
        } else {
            return false
        }
    }

    func processPendingURL(in inCoordinator: UrlSchemeResolver) {
        guard let url = pendingUrl else { return }

        process(url: url, with: inCoordinator)
    }

    private func process(url: URL, with inCoordinator: UrlSchemeResolver) {
        switch (ShareAction(url: url), storage.attachement) {
        case (.content, let attachement):
            switch attachement {
            case .url(let url):
                inCoordinator.openURLInBrowser(url: url)
            case .string(let string):
                break
            case .none, .some(.unknown):
                break
            }
        default:
            break
        }

        pendingUrl = .none
        storage.attachement = .none
    }

    func canHandle(url: URL) -> Bool {
        switch (ShareAction(url: url), storage.attachement) {
        case (.content, .some):
            return true
        default:
            return false
        }
    }
}
