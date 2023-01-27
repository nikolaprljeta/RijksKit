//
//  Protocols.swift
//  adastra.one
//
//  Created by Nikola Prljeta on 3.10.22..
//

import Foundation
import Combine

protocol DataFetchable {
    func combineCollection() -> AnyPublisher<CollectionResponse, Error>
    func combineCollectionDetails(objectNumber: String) -> AnyPublisher<CollectionDetailsResponse, Error>
    func fetchCollection(completionHandler: @escaping (Result<CollectionResponse, Error>) -> Void)
}
