//
//  CCHTTPClient.swift
//  Code Challenge
//
//  Created by Youngjoon Kim on 8/23/24.
//

import Foundation

enum NetworkError: Error {
    case decodeFailure(Error)
    case fetchFailure
    case badResponse
    case responseFailure(Int)
    case badUrl
}

// Singleton client for API request
class HTTPClient {
    
    static let shared = {
        let instance = HTTPClient()
        return instance
    }()
    
    lazy var session = { // URLSession to make API request
        let config = URLSessionConfiguration.default
        config.waitsForConnectivity = false
        config.timeoutIntervalForRequest = 10.0
        return URLSession(configuration: config)
    }()
    
    private init() {}
    
    // T: Decodable type that the requested data must be decoded into.
    func requestAndDecode<T: Decodable>(request: URLRequest) async -> Result<T, Error> {
        // Tetching raw data.
        let result = await requestRaw(request: request)
        print("Some")
        
        switch result {
        case .success(let data) :
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            do {
                let decoded = try decoder.decode(T.self, from: data)
                return .success(decoded)
            } catch let decodeError {
                return .failure(NetworkError.decodeFailure(decodeError))
            }
        case .failure(let error) :
            print(error.localizedDescription)
            return .failure(error)
        }
    }
    
    // This function throws the request to the API endpoint and check if the request was successful.
    func requestRaw(request: URLRequest) async -> Result<Data, Error> {
        guard let (data, response) = try? await session.data(for: request) else {
            return .failure(NetworkError.fetchFailure)
        }
        
        // Received response should be a HTTP response
        guard let response = response as? HTTPURLResponse else {
            return .failure(NetworkError.badResponse)
        }
        
        // Check for request success error code(200 ~ 299).
        if response.statusCode >= 299 || response.statusCode < 200 {
            return .failure(NetworkError.responseFailure(response.statusCode))
        }
        
        return .success(data)
    }
}
