//
//  ShareViewController.swift
//  AlphaWalletShare
//
//  Created by Vladyslav Shepitko on 10.11.2020.
//

import UIKit

@objc(ShareViewController)
class ShareViewController: UIViewController {
    
    private let storage = SharedDefaults()

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        guard let context = extensionContext, let extensionItem = context.inputItems.first as? NSExtensionItem else {
            extensionContext?.completeRequest(returningItems: nil)
            return
        }

        let valueResolver = DefaultItemProviderValueResolver()
        extensionItem.resolveAttachments(valueResolver: valueResolver) { [weak self] attachment in
            guard let strongSelf = self else { return }

            if let attachment = attachment {
                strongSelf.showOpenURL { result in
                    switch result {
                    case .success:
                        strongSelf.storage.attachement = attachment
                        strongSelf.openURL(ShareAction.content.url)
                    case .failure:
                        break
                    }

                    context.completeRequest(returningItems: nil)
                }
            } else {
                context.completeRequest(returningItems: nil)
            }
        }
    }

    private func showOpenURL(completion: @escaping (Result<Void, Error>) -> Void) {
        enum AnyError: Error {
            case canceled
        }

        let preferredStyle: UIAlertController.Style = UIDevice.current.userInterfaceIdiom == .pad ? .alert : .actionSheet
        let controller = UIAlertController(title: nil, message: nil, preferredStyle: preferredStyle)

        let alertAction = UIAlertAction(title: "Open in Browser", style: .default) { _ in
            completion(.success(()))
        }

        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { _ in
            completion(.failure(AnyError.canceled))
        }

        controller.addAction(alertAction)
        controller.addAction(cancelAction)

        present(controller, animated: false)
    }

    @discardableResult @objc func openURL(_ url: URL) -> Bool {
        var responder: UIResponder? = self
        while responder != nil {
            if let application = responder as? UIApplication {
                return application.perform(#selector(openURL), with: url) != nil
            }

            responder = responder?.next
        }

        return false
    }
}
