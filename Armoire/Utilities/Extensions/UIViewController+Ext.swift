//
//  UIViewController+Ext.swift
//  Armoire
//
//  Created by Geraldine Turcios on 1/31/21.
//

import SafariServices
import UIKit

fileprivate struct ProgressDialog {
    static var alert = UIAlertController()
    static var progressView = UIProgressView()

    static var progressPoint: Float = 0 {
        didSet {
            if (progressPoint == 1) {
                ProgressDialog.alert.dismiss(animated: true, completion: nil)
            }
        }
    }
}

extension UIViewController {
    func presentErrorAlert(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.view.tintColor = UIColor.accentColor
        alert.addAction(UIAlertAction(title: "Okay", style: .default))
        present(alert, animated: true)
    }

    func presentSafariViewController(with url: URL) {
        let safariViewController = SFSafariViewController(url: url)
        safariViewController.preferredControlTintColor = UIColor.accentColor
        present(safariViewController, animated: true)
    }

    func startLoadingOverlay(message: String) {
        ProgressDialog.alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)

        let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.style = .large
        loadingIndicator.startAnimating()

        ProgressDialog.alert.view.addSubview(loadingIndicator)
        present(ProgressDialog.alert, animated: true, completion: nil)
    }

    func stopLoadingOverlay(completion: (() -> Void)? = nil) {
        ProgressDialog.alert.dismiss(animated: true, completion: completion)
    }
}
