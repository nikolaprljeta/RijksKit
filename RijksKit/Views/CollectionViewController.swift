//
//  ViewController.swift
//  adastra.one
//
//  Created by Nikola Prljeta on 3.10.22..
//

import UIKit
import Combine

class CollectionViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    private let logo = UIImageView(image: UIImage(named: "logo"))
    
    private var collectionResponse: CollectionResponse?
    private var cancellables = Set<AnyCancellable>()
    
    private let viewModel = CollectionViewModel()
    private let input: PassthroughSubject<CollectionViewModel.Input, Never> = .init()
    
    lazy private var refresher: UIRefreshControl = {
            let refreshControl = UIRefreshControl()
            refreshControl.tintColor = UIColor.label
            refreshControl.addTarget(self, action: #selector(bind), for: .valueChanged)
            
            return refreshControl
        }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.bind()
        self.setup()
        self.setupLogo()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.showLogo(true)
        self.input.send(.viewDidAppear)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        self.showLogo(false)
    }
    
    private func setup() {
        self.title = "Rijksmuseum"
        self.navigationController?.navigationBar.barTintColor?.withAlphaComponent(0.1)
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.refreshControl = refresher
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        self.logo.isUserInteractionEnabled = true
        self.logo.addGestureRecognizer(tapGestureRecognizer)
    }
    
    @objc private func imageTapped(tapGestureRecognizer: UITapGestureRecognizer) {
        if let url = URL(string: "https://www.rijksmuseum.nl/en/tickets/articles") {
            UIApplication.shared.open(url)
        } else {
            return
        }
    }
    
    private func createSpinnerFooter() -> UIView {
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 100))
        
        let spinner = UIActivityIndicatorView()
        spinner.center = footerView.center
        spinner.color = UIColor.label
        
        footerView.addSubview(spinner)
        spinner.startAnimating()
        
        return footerView
    }
    
    private func refresh() {
        DispatchQueue.main.async {
            self.input.send(.viewDidAppear)
            self.refresher.endRefreshing()
            self.tableView.reloadData()
        }
    }
    
    @objc private func bind() {
        self.tableView.tableFooterView = createSpinnerFooter()
        let output = viewModel.transform(input: input.eraseToAnyPublisher())
        output
            .receive(on: DispatchQueue.main)
            .sink { [weak self] event in
            switch event {
                
            case .didSucceed(let data):
                self?.collectionResponse = data
                self?.tableView?.tableFooterView = nil
                self?.tableView.reloadData()
                
            case .didFail(let error):
                self?.configureAlert(with: "Error", and: error.localizedDescription)
            }
        }.store(in: &cancellables)
    }
}

extension CollectionViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1 //since it's just a subtitle and and not a type categorizer in this case
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 20
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let sectionTitle = "Top 100 Dutch Masterpieces"
        return sectionTitle
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 180
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.collectionResponse?.artObjects?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: CollectionTableViewCell.identifier, for: indexPath) as! CollectionTableViewCell
        
        let image = self.collectionResponse?.artObjects?[indexPath.row].headerImage?.url ?? ""
        let title = self.collectionResponse?.artObjects?[indexPath.row].longTitle ?? "Title N/A"
        
        cell.configure(image: image, title: title)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let artOjbectViewController = storyboard?.instantiateViewController(withIdentifier: "ArtObjectViewController") as? ArtObjectViewController else {
            return
        }
        
        artOjbectViewController.artObject = self.collectionResponse?.artObjects?[indexPath.row]
        
        self.navigationController?.pushViewController(artOjbectViewController, animated: true)
    }
}

extension CollectionViewController: UIScrollViewDelegate {
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if self.refresher.isRefreshing == true {
            self.refresh()
        }
    }
}

/*
 * MARK: - The Cherry on Top
 * Let's make the logo bounce around like the large title
 */

extension CollectionViewController {
    private struct Const {
        static let ImageSizeForLargeState: CGFloat = 40
        static let ImageRightMargin: CGFloat = 16
        static let ImageBottomMarginForLargeState: CGFloat = 12
        static let ImageBottomMarginForSmallState: CGFloat = 6
        static let ImageSizeForSmallState: CGFloat = 32
        static let NavBarHeightSmallState: CGFloat = 44
        static let NavBarHeightLargeState: CGFloat = 96.5
    }
    
    private func setupLogo() {
        guard let navigationBar = self.navigationController?.navigationBar else {
            return
        }

        navigationBar.addSubview(logo)
        self.logo.layer.cornerRadius = Const.ImageSizeForLargeState / 2
        self.logo.clipsToBounds = true
        self.logo.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            self.logo.rightAnchor.constraint(equalTo: navigationBar.rightAnchor, constant: -Const.ImageRightMargin),
            self.logo.bottomAnchor.constraint(equalTo: navigationBar.bottomAnchor, constant: -Const.ImageBottomMarginForLargeState),
            self.logo.heightAnchor.constraint(equalToConstant: Const.ImageSizeForLargeState),
            self.logo.widthAnchor.constraint(equalTo: logo.heightAnchor)
            ])
    }
    
    private func moveAndResizeLogo(for height: CGFloat) {
        let coeff: CGFloat = {
            let delta = height - Const.NavBarHeightSmallState
            let heightDifferenceBetweenStates = (Const.NavBarHeightLargeState - Const.NavBarHeightSmallState)
            return delta / heightDifferenceBetweenStates
        }()

        let factor = Const.ImageSizeForSmallState / Const.ImageSizeForLargeState

        let scale: CGFloat = {
            let sizeAddendumFactor = coeff * (1.0 - factor)
            return min(1.0, sizeAddendumFactor + factor)
        }()

        let sizeDiff = Const.ImageSizeForLargeState * (1.0 - factor) // 8.0
        let yTranslation: CGFloat = {
            let maxYTranslation = Const.ImageBottomMarginForLargeState - Const.ImageBottomMarginForSmallState + sizeDiff
            return max(0, min(maxYTranslation, (maxYTranslation - coeff * (Const.ImageBottomMarginForSmallState + sizeDiff))))
        }()

        let xTranslation = max(0, sizeDiff - coeff * sizeDiff)

        self.logo.transform = CGAffineTransform.identity
            .scaledBy(x: scale, y: scale)
            .translatedBy(x: xTranslation, y: yTranslation)
    }
    
    private func showLogo(_ show: Bool) {
        UIView.animate(withDuration: 0.2) {
            self.logo.alpha = show ? 1.0 : 0.0
        }
    }
}
