//
//  NetworkingManager.swift
//  Crypto
//
//  Created by Fatih Kilit on 16.02.2022.
//

import Foundation
import Combine

/*
 
 class NetworkingManager {
    
    enum NetworkingError: LocalizedError {}
 
    static func download(url: URL) -> AnyPublished<Data, Error> {}
 
    static func handleURLResponse(output: URLSession.DataTaskPublisher.Output, url: URL) throws -> Data {}
 
    static func handleCompletion(completion: Subscribers.Completion<Error>) {}
 
 }
 
 */


class NetworkingManager {
    
    enum NetworkingError: LocalizedError {
        
        case badURLResponse(url: URL)
        case unknown
        
        var errorDescription: String? {
            switch self {
            case .badURLResponse(url: let url):
                return "Bad response from URL: \(url)"
            case .unknown:
                return "Unknown error occured."
            }
        }
    }
    
    static func download(url: URL) -> AnyPublisher<Data, Error> {
        URLSession.shared.dataTaskPublisher(for: url)
            //.subscribe(on: DispatchQueue.global(qos: .default))
            .tryMap({ try handleURLResponse(output: $0, url: url) })
            //.receive(on: DispatchQueue.main)
            .retry(3) // -> If url response fails it'll try for 3 more times.
            .eraseToAnyPublisher()
        
        // I will receive on main after decoding background thread.
    }
    
    static func handleURLResponse(output: URLSession.DataTaskPublisher.Output, url: URL) throws -> Data {
        guard let response = output.response as? HTTPURLResponse,
              response.statusCode >= 200 && response.statusCode < 300 else {
                  throw NetworkingError.badURLResponse(url: url)
              }
        
        return output.data
    }
    
    static func handleCompletion(completion: Subscribers.Completion<Error>) {
        switch completion {
        case .finished:
            break
        case .failure(let error):
            print(String(describing: error))
        }
    }
}
