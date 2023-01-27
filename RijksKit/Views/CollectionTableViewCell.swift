//
//  CollectionTableViewCell.swift
//  adastra.one
//
//  Created by Nikola Prljeta on 4.10.22..
//

import UIKit

class CollectionTableViewCell: UITableViewCell {
    
    @IBOutlet weak var thumbnail: UIImageView!
    @IBOutlet weak var title: UILabel!
    
    static let identifier = "CollectionTableViewCell"
    
    func configure(image: String, title: String) {
        self.thumbnail.configureImage(with: image, clipped: true, by: 5)
        self.title.text = title
    }
    
    static func nib() -> UINib {
        return UINib(nibName: identifier, bundle: nil)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
