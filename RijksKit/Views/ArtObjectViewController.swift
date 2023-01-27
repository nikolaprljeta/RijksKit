//
//  ArtObjectViewController.swift
//  adastra.one
//
//  Created by Nikola Prljeta on 5.10.22..
//

import UIKit
import Combine
import ImageScrollView

class ArtObjectViewController: UIViewController {
    
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    @IBOutlet weak var scrollView: ImageScrollView! //subclass of UIScrollView
    @IBOutlet weak var didTapInfo: UIButton!
    
    var artObject: ArtObject?
    var collectionDetailsResponse: CollectionDetailsResponse?
    
    private let artPiece = UIImageView()
    private var cancellables = Set<AnyCancellable>()
    
    private let viewModel = ArtObjectViewModel()
    private let input: PassthroughSubject<ArtObjectViewModel.Input, Never> = .init()
    
    @IBAction func didTapInfo(_ sender: Any) {
        //handled via segue
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.hidesBarsOnTap = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.input.send(.viewDidAppear)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.hidesBarsOnTap = false
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "detailsSegue") {
            if let detailsViewController: DetailsViewController = segue.destination as? DetailsViewController {
                detailsViewController.caller = self
            }
        }
    }
    
    private func setup() {
        self.spinner.hidesWhenStopped = true
        self.scrollView.setup()
        
        self.spinner.startAnimating()
        self.artPiece.configureImage(with: self.artObject?.webImage?.url ?? "", clipped: false, by: 0)
        
        DispatchQueue.main.asyncAfter(wallDeadline: .now() + 2) {
            guard let artUnwrapped = self.artPiece.image else {
                return
            }
            
            self.scrollView.display(image: artUnwrapped)
            self.spinner.stopAnimating()
        }
    }
    
    private func bind() {
        self.spinner.startAnimating()
        let output = viewModel.transform(input: input.eraseToAnyPublisher(), with: artObject?.objectNumber ?? "")
        output
            .receive(on: DispatchQueue.main)
            .sink { [weak self] event in
            switch event {
                
            case .didSucceed(let data):
                self?.collectionDetailsResponse = data
                self?.spinner.stopAnimating()
            case .didFail(let error):
                self?.configureAlert(with: "Error", and: error.localizedDescription)
            }
        }.store(in: &cancellables)
    }
}

extension ArtObjectViewController: ImageScrollViewDelegate {
    func imageScrollViewDidChangeOrientation(imageScrollView: ImageScrollView) {
        print("Did change orientation")
    }
    
    func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat) {
        print("scrollViewDidEndZooming at scale \(scale)")
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        print("scrollViewDidScroll at offset \(scrollView.contentOffset)")
    }
}
