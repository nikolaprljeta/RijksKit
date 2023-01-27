//
//  Extensions+UIButton.swift
//  adastra.one
//
//  Created by Nikola Prljeta on 4.10.22..
//

import Foundation
import UIKit

extension UIButton {
    func configureButton(with title: String, imageName: String, colorName: String) {
        let tint = UIColor(named: colorName)
        let image = UIImage(named: imageName)
        let tintedImage = image?.withRenderingMode(.alwaysTemplate)
        
        self.setTitle(title, for: .normal)
        self.setTitleColor(UIColor.systemBackground, for: .normal)
        self.setImage(tintedImage, for: .normal)
        self.tintColor = tint
    }
}
