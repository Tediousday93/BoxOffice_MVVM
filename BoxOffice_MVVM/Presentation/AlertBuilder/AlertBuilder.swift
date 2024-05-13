//
//  AlertBuilder.swift
//  BoxOffice_MVVM
//
//  Created by Rowan on 2024/04/22.
//

import UIKit

final class AlertBuilder {
    private let alertController: UIAlertController
    
    private weak var presentingViewController: UIViewController?
    
    init(
        alertStyle: UIAlertController.Style,
        presentingViewController: UIViewController
    ) {
        self.alertController = .init(title: nil, message: nil, preferredStyle: alertStyle)
        self.presentingViewController = presentingViewController
    }
    
    func setTitle(_ title: String ) -> Self {
        alertController.title = title
        return self
    }
    
    func setMessage(_ message: String) -> Self {
        alertController.message = message
        return self
    }
    
    func addAction(
        title: String,
        style: UIAlertAction.Style,
        handler: (() -> Void)?
    ) -> Self {
        let alertAction = UIAlertAction(title: title, style: style) { _ in
            guard let handler = handler else { return }
            handler()
        }
        
        alertController.addAction(alertAction)
        
        return self
    }
    
    func show() {
        presentingViewController?.present(alertController, animated: true)
    }
}
