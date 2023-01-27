//
//  DetailsViewController.swift
//  adastra.one
//
//  Created by Nikola Prljeta on 5.10.22..
//

import UIKit

class DetailsViewController: UIViewController {

    @IBOutlet weak var headerImage: UIImageView!
    @IBOutlet weak var about: UITextView!
    @IBOutlet weak var didTapDismiss: UIButton!
    
    var caller: ArtObjectViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    private func setup() {
        self.about.isEditable = false
        self.about.isSelectable = true
        
        self.didTapDismiss.configureButton(with: "Got it", imageName: "checkmark", colorName: "Tint")
        self.headerImage.configureImage(with: caller?.artObject?.headerImage?.url ?? "", clipped: false, by: 0)
        
        let longTitle = self.caller?.artObject?.longTitle ?? "Untitled"
        let objectNo = self.caller?.artObject?.objectNumber ?? "N/A"
        let title = self.caller?.artObject?.title ?? "This piece"
        let firstMaker = self.caller?.artObject?.principalOrFirstMaker ?? "an unknown artist"
        let description = self.caller?.collectionDetailsResponse?.artObject?.plaqueDescriptionEnglish ?? ""
        
        var productionPlaces = self.caller?.artObject?.productionPlaces?.joined(separator: ", ") ?? [""].joined()
        
        if productionPlaces.isEmpty {
            productionPlaces = "at an unknown location"
        }
        
        self.about.text = """
        \(objectNo): \(longTitle)
        
        \(title) was originally produced by \(firstMaker) (\(productionPlaces)).
        
        \(description)
        """
    }

    @IBAction func didTapDismiss(_ sender: Any) {
        self.dismiss(animated: true)
    }
}
