//
//  APICaller.swift
//  adastra.one
//
//  Created by Nikola Prljeta on 3.10.22..
//

import Foundation
import Combine

class APICaller: DataFetchable {
    
    struct Constants {
        static let apiKey = "?key=i1Wfml80"
        static let baseURL = "https://www.rijksmuseum.nl/api/nl"
        static let limit = "&ps=100"
    }
    
    //MARK: - REQUESTS
    func combineCollection() -> AnyPublisher<CollectionResponse, Error> {
        
        let url = URL(string: "\(Constants.baseURL)/collection\(Constants.apiKey)\(Constants.limit)")!
        let session = URLSession.shared
        
        return session.dataTaskPublisher(for: url)
            .catch { error in
                return Fail(error: error).eraseToAnyPublisher()
            }.map({ $0.data})
            .decode(type: CollectionResponse.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
    
    func combineCollectionDetails(objectNumber: String) -> AnyPublisher<CollectionDetailsResponse, Error> {
        
        let url = URL(string: "\(Constants.baseURL)/collection/\(objectNumber)\(Constants.apiKey)")!
        let session = URLSession.shared
        
        return session.dataTaskPublisher(for: url)
            .catch { error in
                return Fail(error: error).eraseToAnyPublisher()
            }.map({ $0.data})
            .decode(type: CollectionDetailsResponse.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
}

//MARK: - DEPRECATED
extension APICaller {
    public func fetchCollection(completionHandler: @escaping (Result<CollectionResponse, Error>) -> Void) {
        
        guard let url = URL(string: "\(Constants.baseURL)/collection\(Constants.apiKey)\(Constants.limit)") else {
            return
        }
        
        let session = URLSession.shared
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        let task = session.dataTask(with: request) { data, response, error in
            
            guard let httpResponse = response as? HTTPURLResponse else {
                return
            }
            
            if httpResponse.statusCode == 200 {
                request.cachePolicy = .reloadIgnoringLocalCacheData
                if let data = data {
                    do {
                        let decoder = JSONDecoder()
                        let response = try decoder.decode(CollectionResponse.self, from: data)
                        
                        completionHandler( .success(response))
                    } catch {
                        completionHandler(.failure(error))
                        debugPrint(error)
                    }
                }
            }
        }
        task.resume()
    }
}
