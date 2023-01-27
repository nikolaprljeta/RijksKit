//
//  ArtObjectViewModel.swift
//  adastra.one
//
//  Created by Nikola Prljeta on 7.10.22..
//

import Foundation
import Combine

class ArtObjectViewModel {
    
    enum Input {
        case viewDidAppear
        case didPullToRefresh
    }
    
    enum Output {
        case didFail(error: Error)
        case didSucceed(collectionResponse: CollectionDetailsResponse)
    }
    
    private let dataFetchable: DataFetchable
    private let output: PassthroughSubject<Output, Never> = .init()
    private var cancellables = Set<AnyCancellable>()
    
    init(dataFetchable: DataFetchable = APICaller()) {
        self.dataFetchable = dataFetchable
    }
    
    func transform(input: AnyPublisher<Input, Never>, with objectNumber: String) -> AnyPublisher<Output, Never> {
        input.sink { [weak self] event in
            switch event {
            case .viewDidAppear, .didPullToRefresh:
                self?.fetchCollectionDetails(with: objectNumber)
            }
        }.store(in: &cancellables)
        return self.output.eraseToAnyPublisher()
    }
    
    private func fetchCollectionDetails(with objectNumber: String) {
        dataFetchable.combineCollectionDetails(objectNumber: objectNumber).sink { [weak self] completion in
            if case .failure(let error) = completion {
                self?.output.send(.didFail(error: error))
            }
        } receiveValue: { [weak self] thing in
            self?.output.send(.didSucceed(collectionResponse: thing))
        }.store(in: &cancellables)
    }
}
