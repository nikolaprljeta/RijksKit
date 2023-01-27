//
//  Extensions+UILabel.swift
//  adastra.one
//
//  Created by Nikola Prljeta on 4.10.22..
//

import Foundation
import UIKit

extension UILabel {
    func configureLabel(with textColor: UIColor, and backgroundColor: UIColor) {
        self.layer.backgroundColor = backgroundColor.cgColor
        self.textColor = textColor
        self.layer.cornerRadius = 2
        self.clipsToBounds = true
    }
}
