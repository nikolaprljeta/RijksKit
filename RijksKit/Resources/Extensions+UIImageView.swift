//
//  Extensions+UIImageView.swift
//  adastra.one
//
//  Created by Nikola Prljeta on 4.10.22..
//

import Foundation
import SDWebImage

extension UIImageView {
    func configureImage(with url: String, clipped clipToBounds: Bool, by cornerRadius: CGFloat = 5) {
        self.contentMode = .scaleAspectFill
        self.clipsToBounds = clipToBounds
        self.layer.cornerRadius = cornerRadius
        self.sd_setImage(with: URL(string: "\(url)"), completed: nil)
    }
}
