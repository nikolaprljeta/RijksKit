//
//  Extensions+UIViewController.swift
//  adastra.one
//
//  Created by Nikola Prljeta on 4.10.22..
//

import Foundation
import UIKit

extension UIViewController {
    func configureAlert(with title: String, and message: String, tap buttonTitle: String = "OK") {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: buttonTitle, style: .default, handler: { _ in
            //do nothing
        }))
        
        self.present(alert, animated: true)

    }
}
